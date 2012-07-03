//
//  CHOAuthViewController.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHOAuthViewController.h"
#import "CHOAuthServiceDefinition.h"
#import "LROAuth2Client.h"
#import "LROAuth2ClientDelegate.h"
#import "CHOAuthClient.h"
#import "CHOAuthClientDelegate.h"


NSString *const CHOAuthDidReceiveAccessTokenNotification  = @"CHOAuthDidReceiveAccessTokenNotification";
NSString *const CHOAuthDidRefreshAccessTokenNotification = @"CHOAuthDidRefreshAccessTokenNotification";

@protocol CHOAuthClient;

@interface CHOAuthViewController () <LROAuth2ClientDelegate, CHOAuthClientDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) UIActivityIndicatorView *spinner;

@property (nonatomic, strong) id<CHOAuthServiceDefinition> serviceDefinition;
@property (nonatomic, strong) LROAuth2Client *client;
@property (nonatomic, strong) CHOAuthClient *legacyClient;
@property (nonatomic, readonly) BOOL useLegacyOAuth;

- (IBAction)cancel;
- (NSDictionary *)notificationUserInfo;
@end


@implementation CHOAuthViewController

@synthesize webView = _webView;
@synthesize navigationBar = _navigationBar;
@synthesize spinner = _spinner;
@synthesize serviceDefinition = _serviceDefinition;
@synthesize client = _client;
@synthesize legacyClient = _legacyClient;
@dynamic useLegacyOAuth;


- (id)initWithServiceDefinition:(id<CHOAuthServiceDefinition>)serviceDefinition {
	self = [super initWithNibName:@"CHOAuthViewController" bundle:nil];
	
	if (self) {
		NSAssert(serviceDefinition != nil, @"Cannot provide a nil service definition");
		
		self.serviceDefinition = serviceDefinition;
		
		NSAssert([serviceDefinition serviceName] != nil, @"A service name must be provided");
		NSAssert([serviceDefinition clientID] != nil, @"A client ID must be provided");
		NSAssert([serviceDefinition clientSecret] != nil, @"A client secret must be provided");
		NSAssert([serviceDefinition redirectURLPath] != nil, @"A valid redirect URL path must be provided");
		NSAssert([serviceDefinition authorizeURLPath] != nil, @"A valid authorize URL path must be provided");
		NSAssert([serviceDefinition tokenURLPath] != nil, @"A valid token URL path must be provided");
		
		if (self.useLegacyOAuth) {
			NSAssert([serviceDefinition requestURLPath] != nil, @"A valid request URL path must be provided");
		
			self.legacyClient = [[CHOAuthClient alloc] initWithConsumerKey:[_serviceDefinition clientID] 
															consumerSecret:[_serviceDefinition clientSecret] 
																requestURL:[NSURL URLWithString:[_serviceDefinition requestURLPath]]
															  authorizeURL:[NSURL URLWithString:[_serviceDefinition authorizeURLPath]]
																 accessURL:[NSURL URLWithString:[_serviceDefinition tokenURLPath]]
															   callbackURL:[NSURL URLWithString:[_serviceDefinition redirectURLPath]]];
			self.legacyClient.delegate = self;
		}
		else {
			self.client = [[LROAuth2Client alloc] initWithClientID:[_serviceDefinition clientID] 
															secret:[_serviceDefinition clientSecret]
													   redirectURL:[NSURL URLWithString:[_serviceDefinition redirectURLPath]]];
			_client.delegate = self;
			_client.userURL = [NSURL URLWithString:[_serviceDefinition authorizeURLPath]];
			_client.tokenURL = [NSURL URLWithString:[_serviceDefinition tokenURLPath]];
			
			if ([_serviceDefinition respondsToSelector:@selector(accessTokenKeyPath)]) {
				_client.accessTokenKeyPath = [self.serviceDefinition accessTokenKeyPath];
			}
		}

		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationBar.topItem.title = [NSString stringWithFormat:@"Connect to %@", [self.serviceDefinition serviceName]];
	self.navigationBar.topItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
}

- (void)viewDidAppear:(BOOL)animated {
	NSDictionary *additionalParameters = nil;
	if ([self.serviceDefinition respondsToSelector:@selector(additionalParameters)]) {
		additionalParameters = [self.serviceDefinition additionalParameters];		
	}

	if (self.useLegacyOAuth) {
		[self.legacyClient authorizeUsingWebView:self.webView additionalParameters:[self.serviceDefinition additionalParameters]];
	}
	else {
		[self.client authorizeUsingWebView:self.webView additionalParameters:additionalParameters];		
	}
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Actions
- (void)refreshAccessToken:(id)accessToken {
	NSAssert(self.serviceDefinition != nil, @"A service definition must be provided before refreshing an access token.");
	
	if (self.useLegacyOAuth) {
		NSLog(@"OAuth 1.0(A) does not support refreshing access token.");
	}
	else {
		[self.client refreshAccessToken:accessToken];		
	}
}

- (IBAction)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Dynamic Properties
- (BOOL)useLegacyOAuth {
	return [self.serviceDefinition oAuthVersion] == 1.0;
}

- (NSDictionary *)notificationUserInfo {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			self.serviceDefinition, CHServiceDefinitionKey,
			nil];
}

#pragma mark - LROAuth2ClientDelegate methods
- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthDidReceiveAccessTokenNotification object:client.accessToken userInfo:[self notificationUserInfo]];		
	});
}

- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthDidRefreshAccessTokenNotification object:client.accessToken userInfo:[self notificationUserInfo]];
	});
}


#pragma mark - CHOAuthClientDelegate
- (void)oAuthLegacyClientDidReceiveAccessToken:(CHOAuthClient *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthDidReceiveAccessTokenNotification object:client.accessToken userInfo:[self notificationUserInfo]];		
	});
}

#pragma mark - UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView {
	[self.spinner startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self.spinner stopAnimating];
}

@end
