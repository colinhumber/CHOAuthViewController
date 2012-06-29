//
//  CHYammerDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.

#import "CHYammerDefinition.h"

@implementation CHYammerDefinition
- (NSString *)serviceName {
	return @"Yammer";
}

- (CGFloat)oAuthVersion {
	return 2.0;
}

- (NSString *)clientID {
	return @"your client ID";
}

- (NSString *)clientSecret {
	return @"your client secret";
}

- (NSString *)requestURLPath {
	return nil;
}

- (NSString *)authorizeURLPath {
	return @"https://www.yammer.com/dialog/oauth";
}

- (NSString *)tokenURLPath {
	return @"https://www.yammer.com/oauth2/access_token";
}

- (NSString *)redirectURLPath {
	return @"http://example.com";
}

- (NSString *)redirectURLPath {
	return @"https://www.yammer.com/authorize";
}

- (NSString *) accessTokenKeyPath {
	return @"access_token.token";
}

- (NSDictionary *)additionalParameters {
	return nil;
}


@end
