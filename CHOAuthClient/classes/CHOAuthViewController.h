//
//  CHOAuthViewController.h
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CHOAuthServiceDefinition.h"

// the following notifications have a user info key "CHServiceDefinition" with an object conforming to the CHOAuthServiceDefinition protocol
// defining the service associated with the access token
#define CHServiceDefinitionKey @"CHServiceDefinition"
extern NSString *const CHOAuthDidReceiveAccessTokenNotification;
extern NSString *const CHOAuthDidRefreshAccessTokenNotification;

@interface CHOAuthViewController : UIViewController<UIWebViewDelegate>

@property (nonatomic, strong) UINavigationBar *navigationBar;

- (id)initWithServiceDefinition:(CHOAuthServiceDefinition *)serviceDefinition;

// If the service has provided a refresh_token as part of the access token, this will request a new access token.
// Only supported for OAuth 2.0 services. NOTE: not every service supports refresh_tokens. Please consult the service's documentation to confirm.
- (void)refreshAccessToken:(id)accessToken;	

@end

