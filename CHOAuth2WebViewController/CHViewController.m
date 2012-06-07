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

@interface CHViewController ()
@property (nonatomic, strong) IBOutlet UILabel *instagramAccessTokenLabel;
@property (nonatomic, strong) IBOutlet UILabel *instagramUsernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *facebookAccessTokenLabel;
@property (nonatomic, strong) IBOutlet UILabel *facebookUsernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *twitterAccessTokenLabel;
@property (nonatomic, strong) IBOutlet UILabel *twitterUsernameLabel;
@property (nonatomic, strong) IBOutlet UILabel *googleAccessTokenLabel;
@property (nonatomic, strong) IBOutlet UILabel *googleUsernameLabel;
@end

@implementation CHViewController

@synthesize instagramUsernameLabel, instagramAccessTokenLabel;
@synthesize facebookUsernameLabel, facebookAccessTokenLabel;
@synthesize twitterUsernameLabel, twitterAccessTokenLabel;
@synthesize googleUsernameLabel, googleAccessTokenLabel;


- (void)viewDidLoad {
    [super viewDidLoad];
	
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didReceiveAccessToken:) name:CHOAuthReceivedAccessTokenNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self 
											 selector:@selector(didRefreshAccessToken:) name:CHOAuthRefreshedAccessTokenNotification object:nil];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

#pragma mark - Actions
- (void)loginToService:(id<CHOAuthServiceDefinition>)service {
	CHOAuthViewController *oauthController = [[CHOAuthViewController alloc] initWithServiceDefinition:service];
	[self presentViewController:oauthController animated:YES completion:nil];
}

- (IBAction)loginToInstagram {
	[self loginToService:[[CHInstagramDefinition alloc] init]];
}

- (IBAction)loginToFacebook {
//	[self loginToService:CHOAuthServiceFacebook];	
}

- (IBAction)loginToTwitter {
//	[self loginToService:CHOAuthServiceTwitter];
}

- (IBAction)loginToGoogle {
//	[self loginToService:CHOAuthServiceGoogle];
}

#pragma mark - Notifications
- (void)didReceiveAccessToken:(NSNotification *)note {
//	self.accessToken = (LROAuth2AccessToken *)note.object;
	
	[self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didRefreshAccessToken:(NSNotification *)note {
//	self.accessToken = (LROAuth2AccessToken *)note.object;	
}

@end
