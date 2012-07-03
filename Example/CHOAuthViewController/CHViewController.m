//
//  CHViewController.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHViewController.h"
#import "CHOAuthViewController.h"
#import "CHInstagramDefinition.h"
#import "CHFacebookDefinition.h"
#import "CHTwitterDefinition.h"
#import "CHGoogleDefinition.h"
#import "CH500PixelsDefinition.h"
#import "CHYammerDefinition.h"
#import "CHFlickrDefinition.h"
#import "LROAuth2AccessToken.h"

@interface CHViewController ()
@property (nonatomic, strong) IBOutlet UILabel *accessTokenLabel;
@property (nonatomic, strong) id accessToken;
@end

@implementation CHViewController

@synthesize accessTokenLabel;
@synthesize accessToken;

NSString *AccessTokenSavePath(NSString *serviceName) {
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
	return [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@OAuthAccessToken.cache", serviceName]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didReceiveAccessToken:) name:CHOAuthDidReceiveAccessTokenNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didRefreshAccessToken:) name:CHOAuthDidRefreshAccessTokenNotification object:nil];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

#pragma mark - Actions
- (void)loginToService:(id<CHOAuthServiceDefinition>)service {
	CHOAuthViewController *oauthController = [[CHOAuthViewController alloc] initWithServiceDefinition:service];
	[self presentViewController:oauthController animated:YES completion:nil];
}

- (IBAction)loginToInstagram {
	self.accessToken = nil;
	[self loginToService:[[CHInstagramDefinition alloc] init]];
}

- (IBAction)loginToFacebook {
	self.accessToken = nil;
	[self loginToService:[[CHFacebookDefinition alloc] init]];
}

- (IBAction)loginToTwitter {
	self.accessToken = nil;
	[self loginToService:[[CHTwitterDefinition alloc] init]];
}

- (IBAction)loginToGoogle {
	self.accessToken = nil;
	[self loginToService:[[CHGoogleDefinition alloc] init]];
}

- (IBAction)loginToYammer {
    self.accessToken = nil;
    [self loginToService:[[CHYammerDefinition alloc] init]];
}

- (IBAction)refreshCurrentToken {
	CHOAuthViewController *oauthController = [[CHOAuthViewController alloc] initWithServiceDefinition:[[CHGoogleDefinition alloc] init]];
	[oauthController refreshAccessToken:self.accessToken];
}

#pragma mark - Notifications
- (void)didReceiveAccessToken:(NSNotification *)note {
	id<CHOAuthServiceDefinition> definition = [note.userInfo objectForKey:CHServiceDefinitionKey];
	self.accessToken = note.object;

	self.accessTokenLabel.text = [self.accessToken description];
	[NSKeyedArchiver archiveRootObject:accessToken toFile:AccessTokenSavePath([definition serviceName])];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRefreshAccessToken:(NSNotification *)note {
}

@end
