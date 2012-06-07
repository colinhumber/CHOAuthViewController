//
//  CHOAuthViewController.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHOAuthViewController.h"
#import "CHServiceConfiguration.h"
#import "CHOAuthServiceDefinition.h"
#import "LROAuth2Client.h"
#import "LROAuth2ClientDelegate.h"
#import "CHOAuthClient.h"
#import "CHOAuthClientDelegate.h"

NSString *const CHOAuthReceivedAccessTokenNotification  = @"CHOAuthReceivedAccessTokenNotification";
NSString *const CHOAuthRefreshedAccessTokenNotification = @"CHOAuthRefreshedAccessTokenNotification";


@interface CHOAuthViewController () <LROAuth2ClientDelegate, CHOAuthClientDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, weak) IBOutlet UINavigationBar *navigationBar;

@property (nonatomic, strong) id<CHOAuthServiceDefinition> serviceDefinition;
@property (nonatomic, strong) LROAuth2Client *client;
@property (nonatomic, strong) CHOAuthClient *oAuthClient;

- (IBAction)cancel;
- (BOOL)useLegacyOAuth;

@end


@implementation CHOAuthViewController

@synthesize webView = _webView;
@synthesize navigationBar = _navigationBar;
@synthesize serviceDefinition = _serviceDefinition;
@synthesize client = _client;
@synthesize oAuthClient = _oAuthClient;

- (BOOL)useLegacyOAuth {
	return [self.serviceDefinition oAuthVersion] == 1.0;
}

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
		
			self.oAuthClient = [[CHOAuthClient alloc] initWithConsumerKey:[_serviceDefinition clientID] 
														   consumerSecret:[_serviceDefinition clientSecret] 
															   requestURL:[NSURL URLWithString:[_serviceDefinition requestURLPath]]
															 authorizeURL:[NSURL URLWithString:[_serviceDefinition authorizeURLPath]]
																accessURL:[NSURL URLWithString:[_serviceDefinition tokenURLPath]]
															  callbackURL:[NSURL URLWithString:[_serviceDefinition redirectURLPath]]];
			self.oAuthClient.delegate = self;
		}
		else {
			self.client = [[LROAuth2Client alloc] initWithClientID:[_serviceDefinition clientID] 
															secret:[_serviceDefinition clientSecret]
													   redirectURL:[NSURL URLWithString:[_serviceDefinition redirectURLPath]]];
			_client.delegate = self;
			_client.userURL = [NSURL URLWithString:[_serviceDefinition authorizeURLPath]];
			_client.tokenURL = [NSURL URLWithString:[_serviceDefinition tokenURLPath]];
		}
		
		
//		switch (serviceType) {
//			case CHOAuthServiceInstagram:
//			{
//				settingPrefix = @"instagram";
//				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
//										 @"code", @"response_type",
//										 nil];
//				break;
//			}
//			case CHOAuthServiceFacebook:
//			{
//				settingPrefix = @"facebook";
//				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
//										 @"touch", @"display",
//										 @"publish_stream", @"scope",
//										 nil];
//				break;
//			}
//			case CHOAuthServiceTwitter:
//				settingPrefix = @"twitter";
//				break;
//				
//			case CHOAuthServiceGoogle:
//			{
//				settingPrefix = @"google";
//				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
//										 @"code", @"response_type",
//										 @"offline", @"access_type",
//										 @"https://picasaweb.google.com/data/", @"scope",
//										 nil];
//				break;
//			}
//				
//			default:
//				NSAssert(NO, @"A valid service type must be provided.");
//				break;
//		}
		
//		CHServiceConfiguration *serviceConfiguration = [CHServiceConfiguration sharedInstance];
//		clientID = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@ClientId", settingPrefix]];
//		clientSecret = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@ClientSecret", settingPrefix]];
//		redirectURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@RedirectURL", settingPrefix]];
//		authorizeURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@AuthorizeURL", settingPrefix]];
//		tokenURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@TokenURL", settingPrefix]];


		

		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.navigationBar.topItem.title = [NSString stringWithFormat:@"Connect to %@", [self.serviceDefinition serviceName]];
}

- (void)viewDidAppear:(BOOL)animated {
//	[_oAuthClient authorizeUsingWebView:self.webView];
	[_client authorizeUsingWebView:self.webView additionalParameters:[self.serviceDefinition additionalParameters]];
}

- (void)viewDidUnload {
    [super viewDidUnload];
	self.webView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Actions
- (void)refreshAccessToken:(LROAuth2AccessToken *)accessToken {
	[_client refreshAccessToken:accessToken];
}

- (IBAction)cancel {
	[self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - LROAuth2ClientDelegate methods
- (void)oauthClientDidReceiveAccessToken:(LROAuth2Client *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthReceivedAccessTokenNotification object:client.accessToken];		
	});
}

- (void)oauthClientDidRefreshAccessToken:(LROAuth2Client *)client {
	dispatch_async(dispatch_get_main_queue(), ^{
		[[NSNotificationCenter defaultCenter] postNotificationName:CHOAuthRefreshedAccessTokenNotification object:client.accessToken];
	});
}


@end
