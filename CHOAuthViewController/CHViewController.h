//
//  CHViewController.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CHViewController : UIViewController

- (IBAction)loginToInstagram;
- (IBAction)loginToFacebook;
- (IBAction)loginToTwitter;
- (IBAction)loginToGoogle;
- (IBAction)loginToYammer;

- (IBAction)refreshCurrentToken;

@end
