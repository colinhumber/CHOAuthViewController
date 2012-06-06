//
//  CHOAuth2WebViewController.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LROAuth2Client;
@class LROAuth2AccessToken;

extern NSString *const CHOAuthReceivedAccessTokenNotification;
extern NSString *const CHOAuthRefreshedAccessTokenNotification;


typedef enum {
	CHOAuthServiceInstagram,
	CHOAuthServiceFacebook,
	CHOAuthServiceTwitter,
	CHOAuthServiceGoogle
} CHOAuthService;

@interface CHOAuth2WebViewController : UIViewController

- (id)initWithService:(CHOAuthService)serviceType;
- (void)refreshAccessToken:(LROAuth2AccessToken *)accessToken;

@end
