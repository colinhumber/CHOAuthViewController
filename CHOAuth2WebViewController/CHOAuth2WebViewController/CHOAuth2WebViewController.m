//
//  CHOAuth2WebViewController.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHOAuth2WebViewController.h"
#import "CHServiceConfiguration.h"
#import "LROAuth2Client.h"
#import "LROAuth2ClientDelegate.h"
#import "CHOAuthClient.h"
#import "CHOAuthClientDelegate.h"

NSString *const CHOAuthReceivedAccessTokenNotification  = @"CHOAuthReceivedAccessTokenNotification";
NSString *const CHOAuthRefreshedAccessTokenNotification = @"CHOAuthRefreshedAccessTokenNotification";


@interface CHOAuth2WebViewController () <LROAuth2ClientDelegate, CHOAuthClientDelegate>
@property (nonatomic, weak) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSDictionary *additionalParameters;
@property (nonatomic, strong) LROAuth2Client *client;
@property (nonatomic, strong) CHOAuthClient *oAuthClient;
- (IBAction)cancel;
@end


@implementation CHOAuth2WebViewController

@synthesize webView = _webView;
@synthesize client = _client;
@synthesize oAuthClient = _oAuthClient;
@synthesize additionalParameters = _additionalParameters;

- (id)initWithService:(CHOAuthService)serviceType {
	self = [super initWithNibName:@"CHOAuth2WebViewController" bundle:nil];
	
	if (self) {
		NSString *clientID = nil;
		NSString *clientSecret = nil;
		NSURL *redirectURL = nil;
		NSURL *authorizeURL = nil;
		NSURL *tokenURL = nil;
		NSString *settingPrefix = nil;
		
		switch (serviceType) {
			case CHOAuthServiceInstagram:
			{
				settingPrefix = @"instagram";
				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
										 @"code", @"response_type",
										 nil];
				break;
			}
			case CHOAuthServiceFacebook:
			{
				settingPrefix = @"facebook";
				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
										 @"touch", @"display",
										 @"publish_stream", @"scope",
										 nil];
				break;
			}
			case CHOAuthServiceTwitter:
				settingPrefix = @"twitter";
				break;
				
			case CHOAuthServiceGoogle:
			{
				settingPrefix = @"google";
				_additionalParameters = [[NSDictionary alloc] initWithObjectsAndKeys:
										 @"code", @"response_type",
										 @"offline", @"access_type",
										 @"https://picasaweb.google.com/data/", @"scope",
										 nil];
				break;
			}
				
			default:
				NSAssert(NO, @"A valid service type must be provided.");
				break;
		}
		
		CHServiceConfiguration *serviceConfiguration = [CHServiceConfiguration sharedInstance];
		clientID = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@ClientId", settingPrefix]];
		clientSecret = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@ClientSecret", settingPrefix]];
		redirectURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@RedirectURL", settingPrefix]];
		authorizeURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@AuthorizeURL", settingPrefix]];
		tokenURL = [serviceConfiguration valueForSetting:[NSString stringWithFormat:@"%@TokenURL", settingPrefix]];

		if (serviceType == CHOAuthServiceTwitter) {
			self.oAuthClient = [[CHOAuthClient alloc] initWithConsumerKey:clientID 
														   consumerSecret:clientSecret 
															   requestURL:[NSURL URLWithString:@"https://api.twitter.com/oauth/request_token"] 
															 authorizeURL:authorizeURL 
																accessURL:tokenURL 
															  callbackURL:redirectURL];
			self.oAuthClient.delegate = self;
		}
		self.client = [[LROAuth2Client alloc] initWithClientID:clientID 
														secret:clientSecret
												   redirectURL:redirectURL];
		_client.delegate = self;
		_client.userURL = authorizeURL;
		_client.tokenURL = tokenURL;

		self.modalPresentationStyle = UIModalPresentationFormSheet;
	}
	
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	[_oAuthClient authorizeUsingWebView:self.webView];
//	[_client authorizeUsingWebView:self.webView additionalParameters:_additionalParameters];
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
