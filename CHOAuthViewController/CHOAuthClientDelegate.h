//
//  CHOAuthClientDelegate.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/6/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHOAuthClient;

@protocol CHOAuthClientDelegate <UIWebViewDelegate>

@required
- (void)oAuthLegacyClientDidReceiveAccessToken:(CHOAuthClient *)client;

@optional
- (void)oAuthLegacyClientDidCancel:(CHOAuthClient *)client;

@end
