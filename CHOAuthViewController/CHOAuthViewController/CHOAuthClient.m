//
//  CHOAuthClient.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHOAuthClient.h"
#import "OAuthConsumer.h"
#import <LROAuth2Client/LRURLRequestOperation.h>
#import <LROAuth2Client/LROAuth2AccessToken.h>
#import <LROAuth2Client/NSDictionary+QueryString.h>
#import <LROAuth2Client/NSURL+QueryInspector.h>

@interface CHOAuthClient () <UIWebViewDelegate>
@property (nonatomic, strong) OAConsumer *consumer;
@property (nonatomic, strong) OAToken *requestToken;
@property (nonatomic, strong) id<OASignatureProviding> signatureProvider;
@property (nonatomic, strong) NSDictionary *authorizeResponseQueryVars;
@property (nonatomic, weak) UIWebView *webView;

- (void)tokenRequest;
- (void)tokenAuthorize;
- (void)tokenAccess;
@end


@implementation CHOAuthClient

@synthesize delegate = _delegate;
@synthesize webView = _webView;
@synthesize consumerKey = _consumerKey;
@synthesize consumerSecret = _consumerSecret;
@synthesize requestURL = _requestURL;
@synthesize authorizeURL = _authorizeURL;
@synthesize accessURL = _accessURL;
@synthesize callbackURL = _callbackURL;
@synthesize consumer = _consumer;
@synthesize requestToken = _requestToken;
@synthesize accessToken = _accessToken;
@synthesize authorizeResponseQueryVars = _authorizeResponseQueryVars;
@synthesize signatureProvider = _signatureProvider;


- (id)initWithConsumerKey:(NSString *)consumerKey 
		   consumerSecret:(NSString *)consumerSecret
			   requestURL:(NSURL *)requestURL
			 authorizeURL:(NSURL *)authorizeURL
				accessURL:(NSURL *)accessURL
			  callbackURL:(NSURL *)callbackURL {
	
	self = [super init];
	if (self) {
		self.consumerKey = consumerKey;
		self.consumerSecret = consumerSecret;
		self.requestURL = requestURL;
		self.authorizeURL = authorizeURL;
		self.accessURL = accessURL;
		self.callbackURL = callbackURL;
		
		self.consumer = [[OAConsumer alloc] initWithKey:consumerKey secret:consumerSecret];
	}
	
	return self;
}

#pragma mark - UI
- (void)authorizeUsingWebView:(UIWebView *)webView {
	[self authorizeUsingWebView:webView additionalParameters:nil];
}

- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters {
	self.webView = webView;
	self.webView.delegate = self;
	[self tokenRequest];
}

#pragma mark - Token Request
- (void)tokenRequest {
	OAMutableURLRequest *authRequest = [[OAMutableURLRequest alloc] initWithURL:self.requestURL
																	consumer:self.consumer
																	   token:nil   
																	   realm:nil   
														   signatureProvider:self.signatureProvider];
	
	[authRequest setHTTPMethod:@"POST"];
	[authRequest prepare];
	
	LRURLRequestOperation *operation = [[LRURLRequestOperation alloc] initWithURLRequest:authRequest];
	
    __weak id blockOperation = operation;
	
    [operation setCompletionBlock:^{
		[self tokenRequestCompleted:blockOperation];
    }];
	[operation start];
}

- (void)tokenRequestCompleted:(LRURLRequestOperation *)operation {
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.URLResponse;
	
	OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:(OAMutableURLRequest*)operation.URLRequest 
															  response:operation.URLResponse 
																  data:operation.responseData 
															didSucceed:response.statusCode < 400];

	if (ticket.didSucceed) {
		NSString *responseBody = [[NSString alloc] initWithData:operation.responseData
													   encoding:NSUTF8StringEncoding];
		OAToken *aToken = [[OAToken alloc] initWithHTTPResponseBody:responseBody];
        self.requestToken = aToken;
		
		[self tokenAuthorize];
	}	
	else {
		NSLog(@"Ticket failed: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	}
}

#pragma mark - Token Authorize
- (void)tokenAuthorize {
	NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?oauth_token=%@", _authorizeURL.absoluteString, _requestToken.key]];
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}

#pragma mark - Token Access
- (void)tokenAccess{
	OAMutableURLRequest *accessRequest = [[OAMutableURLRequest alloc] initWithURL:_accessURL
																		 consumer:_consumer
																			token:_requestToken
																			realm:nil					// our service provider doesn't specify a realm
																signatureProvider:_signatureProvider];	// use the default method, HMAC-SHA1
	[accessRequest setHTTPMethod:@"POST"];
   	[accessRequest prepare];
	
	LRURLRequestOperation *operation = [[LRURLRequestOperation alloc] initWithURLRequest:accessRequest];
	
    __weak id blockOperation = operation;
	
    [operation setCompletionBlock:^{
		[self tokenAccessCompleted:blockOperation];
    }];
	[operation start];
}

- (void)tokenAccessCompleted:(LRURLRequestOperation *)operation {
	NSHTTPURLResponse *response = (NSHTTPURLResponse *)operation.URLResponse;
	
	OAServiceTicket *ticket = [[OAServiceTicket alloc] initWithRequest:(OAMutableURLRequest*)operation.URLRequest 
															  response:operation.URLResponse 
																  data:operation.responseData 
															didSucceed:response.statusCode < 400];

	if (ticket.didSucceed) {
		NSString *responseString = [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding];
		OAToken *accessToken = [[OAToken alloc] initWithHTTPResponseBody:responseString];
        
		self.accessToken = accessToken;        
		
		if ([self.delegate respondsToSelector:@selector(oAuthLegacyClientDidReceiveAccessToken:)]) {
			[self.delegate oAuthLegacyClientDidReceiveAccessToken:self];
		}
	}
	else {
		NSLog(@"Ticket failed: %@", [[NSString alloc] initWithData:operation.responseData encoding:NSUTF8StringEncoding]);
	}
}


#pragma mark - UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {		
	if ([request.URL.absoluteString rangeOfString:_callbackURL.absoluteString options:NSCaseInsensitiveSearch].location != NSNotFound) {
		if (request.URL.query != nil) {
			self.authorizeResponseQueryVars = [request.URL queryDictionary];
		}
		
		[self tokenAccess];

		return NO;
	}
	
	return YES;
}

@end
