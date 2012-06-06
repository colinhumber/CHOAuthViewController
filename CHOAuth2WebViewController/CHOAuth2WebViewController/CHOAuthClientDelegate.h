//
//  CHOAuthClientDelegate.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CHOAuthClient;

@protocol CHOAuthClientDelegate <NSObject>

@required
- (void)oAuthClientDidReceiveAccessToken:(CHOAuthClient *)client;
- (void)oAuthClientDidRefreshAccessToken:(CHOAuthClient *)client;

@optional
- (void)oAuthClientDidReceiveAccessCode:(CHOAuthClient *)client;
- (void)oAuthClientDidCancel:(CHOAuthClient *)client;

@end
