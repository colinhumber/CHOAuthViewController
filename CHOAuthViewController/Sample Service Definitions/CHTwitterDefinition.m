//
//  CHTwitterDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHTwitterDefinition.h"

@implementation CHTwitterDefinition

- (NSString *)serviceName {
	return @"Twitter";
}

- (CGFloat)oAuthVersion {
	return 1.0;
}

- (NSString *)clientID {
	return @"izjw1JYePlsOzgv2EhLOyg";
}

- (NSString *)clientSecret {
	return @"7VYIAYTLCpLPmNpW2tXqfadBas01OAf6hLvQQvhbg";
}

- (NSString *)requestURLPath {
	return @"https://api.twitter.com/oauth/request_token";
}

- (NSString *)authorizeURLPath {
	return @"https://api.twitter.com/oauth/authorize";
}

- (NSString *)tokenURLPath {
	return @"https://api.twitter.com/oauth/access_token";
}

- (NSString *)redirectURLPath {
	return @"http://example.com";
}

- (NSDictionary *)additionalParameters {
	return nil;
}

@end
