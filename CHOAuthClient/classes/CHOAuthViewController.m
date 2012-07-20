//
//  CHOAuthViewController.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHOAuthViewController.h"
#import "CHOAuthServiceDefinition.h"
#import <LROAuth2Client/LROAuth2Client.h>
#import <LROAuth2Client/LROAuth2ClientDelegate.h>
#import "CHOAuthClient.h"
#import "CHOAuthClientDelegate.h"


NSString *const CHOAuthDidReceiveAccessTokenNotification  = @"CHOAuthDidReceiveAccessTokenNotification";
NSString *const CHOAuthDidRefreshAccessTokenNotification = @"CHOAuthDidRefreshAccessTokenNotification";

@interface CHOAuthViewController () <LROAuth2ClientDelegate, CHOAuthClientDelegate>

@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, strong) CHOAuthServiceDefinition *serviceDefinition;
@property (nonatomic, strong) LROAuth2Client *client;
@property (nonatomic, strong) CHOAuthClient *legacyClient;

- (void)cancel;
- (BOOL)useLegacyOAuth;
- (NSDictionary *)notificationUserInfo;

@end

@implementation CHOAuthViewController

@synthesize webView = _webView;
@synthesize navigationBar = _navigationBar;
@synthesize serviceDefinition = _serviceDefinition;
@synthesize client = _client;
@synthesize legacyClient = _legacyClient;

- (BOOL)useLegacyOAuth {
	return [self.serviceDefinition oAuthVersion] == 1.0;
}

- (id)initWithServiceDefinition:(CHOAuthServiceDefinition *)serviceDefinition {

	self = [super init];
	
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
			NSAssert([serviceDefinition respondsToSelector:@selector(requestURLPath)]
						&& [serviceDefinition requestURLPath] != nil, @"A valid request URL path must be provided for OAuth1 services");
		
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
			_client.accessTokenKeyPath = _serviceDefinition.accessTokenKeyPath;
		}

		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	return self;
}

#pragma mark - View management

-(void) loadView {
	
	UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 100.0, 100.0)];
	view.backgroundColor = [UIColor blackColor];
	self.view = view;

	// Create widgets.
	UILabel *connectMsg = [[UILabel alloc] init];
	connectMsg.text = @"Connecting ...";
	connectMsg.textColor = [UIColor whiteColor];
	connectMsg.backgroundColor = [UIColor clearColor];
	CGSize msgSize = [connectMsg.text sizeWithFont:connectMsg.font];
	connectMsg.frame = CGRectMake(0.0, 0.0, msgSize.width, msgSize.height);
	
	UIActivityIndicatorView *busy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	[busy startAnimating];
	busy.backgroundColor = [UIColor clearColor];

	// work out size of widget frame.
	CGFloat widgetsWidth = fmaxf(busy.bounds.size.width, msgSize.width);
	CGFloat widgetsHeight = busy.bounds.size.height + msgSize.height + 4;
	
	// Add a view to group the central widgets.
	UIView *busyView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, widgetsWidth, widgetsHeight)];
	busyView.backgroundColor = [UIColor clearColor];
	busyView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin
	| UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
	busyView.center = CGPointMake(50.0,50.0);
	[view addSubview:busyView];

	// Add widgets.
	[busyView addSubview:connectMsg];
	busy.center = CGPointMake(widgetsWidth / 2, widgetsHeight - busy.bounds.size.height / 2);
	[busyView addSubview:busy];
	
	UINavigationBar *navBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
	navBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	[view addSubview:navBar];
	
	UINavigationItem *navItem = [[UINavigationItem alloc] init];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
	navItem.leftBarButtonItem = cancelButton;
	
	[navBar pushNavigationItem:navItem animated:NO];

	UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 100, 66)];
	webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	webView.hidden = YES;
	[view addSubview:webView];
	
	self.webView = webView;
	self.navigationBar = navBar;
	
}

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationBar.topItem.title = [NSString stringWithFormat:@"Connect to %@", [self.serviceDefinition serviceName]];
}

- (void)viewDidAppear:(BOOL)animated {
	if (self.useLegacyOAuth) {
		[self.legacyClient authorizeUsingWebView:self.webView];
	}
	else {
		NSDictionary *additionalParameters = nil;
		if ([self.serviceDefinition respondsToSelector:@selector(additionalParameters)]) {
			additionalParameters = [self.serviceDefinition additionalParameters];		
		}
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
		NSLog(@"OAuth 1.0 does not support refreshing access token.");
	}
	else {
		[self.client refreshAccessToken:accessToken];		
	}
}

- (void)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
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

// Passed through from LROAuth2Client web view management.
-(void) webViewDidFinishLoad:(UIWebView *)webView {
	webView.hidden = NO;
}


#pragma mark - CHOAuthClientDelegate
- (void)oAuthLegacyClientDidReceiveAccessToken:(CHOAuthClient *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthDidReceiveAccessTokenNotification object:client.accessToken userInfo:[self notificationUserInfo]];		
	});
}

@end
