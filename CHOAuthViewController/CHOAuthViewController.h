//
//  CHOAuthViewController.h
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CHOAuthServiceDefinition;

// the following notifications have a user info key "CHServiceDefinition" with an object conforming to the CHOAuthServiceDefinition protocol
// defining the service associated with the access token.
#define CHServiceDefinitionKey @"CHServiceDefinition"
extern NSString *const CHOAuthDidReceiveAccessTokenNotification;
extern NSString *const CHOAuthDidRefreshAccessTokenNotification;

@interface CHOAuthViewController : UIViewController

// if a custom UIWebView is not specified this refers to the internal navigation bar created for the internal UIWebView. If a custom UIWebView has been specified
// this is nil.
@property (nonatomic, readonly) UINavigationBar *navigationBar;

// if a webView already exists that should be used to load the login screens it can be specified here. If nil, a UIWebView will be created alongside a UINavigationBar
// and a Cancel button.
@property (nonatomic, strong) UIWebView *webView;

- (id)initWithServiceDefinition:(id<CHOAuthServiceDefinition>)serviceDefinition;

// If the service has provided a refresh_token as part of the access token, this will request a new access token.
// Only supported for OAuth 2.0 services. NOTE: not every service supports refresh_tokens. Please consult the service's documentation to confirm.
- (void)refreshAccessToken:(id)accessToken;	

@end

