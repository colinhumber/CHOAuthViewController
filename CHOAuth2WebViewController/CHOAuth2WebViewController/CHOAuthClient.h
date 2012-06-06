//
//  CHOAuthClient.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CHOAuthClientDelegate.h"

@class LROAuth2AccessToken;

@interface CHOAuthClient : NSObject

@property (nonatomic, strong) NSString *consumerKey;
@property (nonatomic, strong) NSString *consumerSecret;
@property (nonatomic, strong) NSURL *requestURL;
@property (nonatomic, strong) NSURL *authorizeURL;
@property (nonatomic, strong) NSURL *accessURL;
@property (nonatomic, strong) NSURL *callbackURL;
@property (nonatomic, weak) id<CHOAuthClientDelegate> delegate;

//@property (nonatomic, strong) OAToken *accessToken;
@property (nonatomic, strong) LROAuth2AccessToken *accessToken;


- (id)initWithConsumerKey:(NSString *)consumerKey 
		   consumerSecret:(NSString *)consumerSecret
			   requestURL:(NSURL *)requestURL
			 authorizeURL:(NSURL *)authorizeURL
				accessURL:(NSURL *)accessURL
			  callbackURL:(NSURL *)callbackURL;

- (void)tokenRequest;
//- (void)tokenRequestModifyRequest:(OAMutableURLRequest *)oRequest;
//- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
//- (void)tokenRequestTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

- (void)tokenAuthorize;

- (void)tokenAccess;
- (void)tokenAccess:(BOOL)refresh;
//- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFinishWithData:(NSData *)data;
//- (void)tokenAccessTicket:(OAServiceTicket *)ticket didFailWithError:(NSError*)error;

//- (void)storeAccessToken;
//- (BOOL)restoreAccessToken;
//- (void)refreshToken;

- (void)authorizeUsingWebView:(UIWebView *)webView;
- (void)authorizeUsingWebView:(UIWebView *)webView additionalParameters:(NSDictionary *)additionalParameters;

@end
