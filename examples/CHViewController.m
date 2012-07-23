//
//  CHViewController.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHViewController.h"
#import "CHOAuthViewController.h"
#import "CHInstagramDefinition.h"
#import "CHFacebookDefinition.h"
#import "CHTwitterDefinition.h"
#import "CHGoogleDefinition.h"
#import "CHYammerDefinition.h"
#import <LROAuth2Client/LROAuth2AccessToken.h>

@interface CHViewController ()
@property (nonatomic, strong) IBOutlet UILabel *accessTokenLabel;
@property (nonatomic, strong) id accessToken;
@end

@implementation CHViewController

@synthesize accessTokenLabel;
@synthesize accessToken;

NSString* AccessTokenSavePath(NSString *serviceName) {
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
- (void)loginToService:(CHOAuthServiceDefinition *)service {
	CHOAuthViewController *oauthController = [[CHOAuthViewController alloc] initWithServiceDefinition:service];
	[self presentViewController:oauthController animated:YES completion:nil];
}

- (IBAction)loginToInstagram {
	self.accessToken = nil;
	[self loginToService:[[ CHInstagramDefinition alloc] initWithClientId:@"d2eb5be8b572404383d6a3ac94f654c4" secret:@"3849d8323799403580eb80beda7b152f"]];
}

- (IBAction)loginToFacebook {
	self.accessToken = nil;
	[self loginToService:[[CHFacebookDefinition alloc] initWithClientId:@"175666859124998" secret:@"bf72778ae068d0d71f9a01a93cdedb51"]];
}

- (IBAction)loginToTwitter {
	self.accessToken = nil;
	[self loginToService:[[CHTwitterDefinition alloc] initWithClientId:@"izjw1JYePlsOzgv2EhLOyg" secret:@"7VYIAYTLCpLPmNpW2tXqfadBas01OAf6hLvQQvhbg"]];
}

- (IBAction)loginToGoogle {
	self.accessToken = nil;
	[self loginToService:[[CHGoogleDefinition alloc] initWithClientId:@"807033624458.apps.googleusercontent.com" secret:@"o_BG5A-krWXae_mki9OXGROd"]];
}

- (IBAction)loginToYammer {
    self.accessToken = nil;
    [self loginToService:[[CHYammerDefinition alloc] initWithClientId:@"hgcfOES0jojCR1rrYqdtQ" secret:@"UaTdF5ww5GbQ2OxuakiMQwVDrH6ThVkl37Dokp38gY"]];
}

- (IBAction)refreshCurrentToken {
	CHOAuthViewController *oauthController = [[CHOAuthViewController alloc] initWithServiceDefinition:[[CHGoogleDefinition alloc] init]];
	[oauthController refreshAccessToken:self.accessToken];
}

#pragma mark - Notifications
- (void)didReceiveAccessToken:(NSNotification *)note {
	CHOAuthServiceDefinition* definition = [note.userInfo objectForKey:CHServiceDefinitionKey];
	self.accessToken = note.object;

	self.accessTokenLabel.text = [self.accessToken description];
	[NSKeyedArchiver archiveRootObject:accessToken toFile:AccessTokenSavePath([definition serviceName])];
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRefreshAccessToken:(NSNotification *)note {
}

@end
