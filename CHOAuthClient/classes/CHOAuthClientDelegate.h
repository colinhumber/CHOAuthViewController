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
- (void)oAuthLegacyClientDidReceiveAccessToken:(CHOAuthClient *)client;

@optional
- (void)oAuthLegacyClientDidCancel:(CHOAuthClient *)client;

@end
