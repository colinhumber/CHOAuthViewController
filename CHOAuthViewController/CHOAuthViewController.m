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
	self = [super init];
	
	if (self) {
		NSAssert(serviceDefinition != nil, @"Cannot provide a nil service definition");
		
		self.serviceDefinition = serviceDefinition;
		
		NSURL *requestURL = [NSURL URLWithString:[_serviceDefinition requestURLPath]];
		NSURL *authorizeURL = [NSURL URLWithString:[_serviceDefinition authorizeURLPath]];
		NSURL *tokenURL = [NSURL URLWithString:[_serviceDefinition tokenURLPath]];
		NSURL *redirectURL = [NSURL URLWithString:[_serviceDefinition redirectURLPath]];
		
		NSAssert([serviceDefinition serviceName] != nil, @"A service name must be provided");
		NSAssert([serviceDefinition clientID] != nil, @"A client ID must be provided");
		NSAssert([serviceDefinition clientSecret] != nil, @"A client secret must be provided");
		NSAssert(redirectURL != nil, @"A valid redirect URL path must be provided");
		NSAssert(authorizeURL != nil, @"A valid authorize URL path must be provided");
		NSAssert(tokenURL != nil, @"A valid token URL path must be provided");
		
		if (self.useLegacyOAuth) {
			NSAssert(requestURL != nil, @"A valid request URL path must be provided");
		
			self.legacyClient = [[CHOAuthClient alloc] initWithConsumerKey:[_serviceDefinition clientID] 
															consumerSecret:[_serviceDefinition clientSecret] 
																requestURL:requestURL
															  authorizeURL:authorizeURL
																 accessURL:tokenURL
															   callbackURL:redirectURL];
			self.legacyClient.delegate = self;
		}
		else {
			self.client = [[LROAuth2Client alloc] initWithClientID:[_serviceDefinition clientID] 
															secret:[_serviceDefinition clientSecret]
													   redirectURL:redirectURL];
			_client.delegate = self;
			_client.userURL = authorizeURL;
			_client.tokenURL = tokenURL;
			
			if ([_serviceDefinition respondsToSelector:@selector(accessTokenKeyPath)]) {
				_client.accessTokenKeyPath = [self.serviceDefinition accessTokenKeyPath];
			}
		}

		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	return self;
}

- (void)loadView {
	if (_webView) {
		self.view = _webView;
	}
	else {
		CGRect applicationBounds = CGRectOffset([UIScreen mainScreen].applicationFrame, 0, -20);
		self.view = [[UIView alloc] initWithFrame:applicationBounds];

		self.spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

		_navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, applicationBounds.size.width, 44)];
		_navigationBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
		
		UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:[NSString stringWithFormat:@"Connect to %@", [self.serviceDefinition serviceName]]];
		navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
		navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.spinner];
		[_navigationBar pushNavigationItem:navigationItem animated:NO];
		[self.view addSubview:_navigationBar];
		
		self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, applicationBounds.size.width, applicationBounds.size.height - 44)];
		_webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | 
									UIViewAutoresizingFlexibleHeight;
		
		[self.view addSubview:_webView];
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
