//
//  DefaultCHOAuth2Configuration.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DefaultCHOAuth2Configuration.h"

@implementation DefaultCHOAuth2Configuration

#pragma mark - Instagram
- (NSString *)instagramClientId {
	return nil;
}
- (NSString *)instagramClientSecret {
	return nil;
}

- (NSURL *)instagramRedirectURL {
	return nil;
}

- (NSURL *)instagramAuthorizeURL {
	return [NSURL URLWithString:@"https://api.instagram.com/oauth/authorize"];
}

- (NSURL *)instagramTokenURL {
	return [NSURL URLWithString:@"https://api.instagram.com/oauth/access_token"];
}


#pragma mark - Facebook
- (NSString *)facebookClientId {
	return nil;
}

- (NSString *)facebookClientSecret {
	return nil;
}

- (NSURL *)facebookRedirectURL {
	return nil;
}

- (NSURL *)facebookAuthorizeURL {
	return [NSURL URLWithString:@"https://graph.facebook.com/oauth/authorize"];
}

- (NSURL *)facebookTokenURL {
	return [NSURL URLWithString:@"https://graph.facebook.com/oauth/access_token"];
}

#pragma mark - Twitter
- (NSString *)twitterClientId {
	return nil;
}

- (NSString *)twitterClientSecret {
	return nil;
}

- (NSURL *)twitterRedirectURL {
	return nil;
}

- (NSURL *)twitterAuthorizeURL {
	return [NSURL URLWithString:@"https://api.twitter.com/oauth/authorize"];
}

- (NSURL *)twitterTokenURL  {
	return [NSURL URLWithString:@"https://api.twitter.com/oauth/access_token"];
}

#pragma mark - Google
/*
 Register at https://code.google.com/apis/console#access
 Scopes at https://code.google.com/oauthplayground/
 */
- (NSString *)googleClientId {
	return nil;
}

- (NSString *)googleClientSecret {
	return nil;
}

- (NSURL *)googleRedirectURL {
	return nil;
}

- (NSURL *)googleAuthorizeURL {
	return [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/auth"];
}

- (NSURL *)googleTokenURL  {
	return [NSURL URLWithString:@"https://accounts.google.com/o/oauth2/token"];
}

@end
