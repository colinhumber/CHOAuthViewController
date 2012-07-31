//
//  CHInstagramDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHInstagramDefinition.h"

@implementation CHInstagramDefinition

- (NSString *)serviceName {
	return @"Instagram";
}

- (CHOAuthVersion)oAuthVersion {
	return CHOAuthVersion2;
}

- (NSString *)clientID {
	return @"";
}

- (NSString *)clientSecret {
	return @"";
}

- (NSString *)requestURLPath {
	return nil;
}

- (NSString *)authorizeURLPath {
	return @"https://api.instagram.com/oauth/authorize";
}

- (NSString *)tokenURLPath {
	return @"https://api.instagram.com/oauth/access_token";
}

- (NSString *)redirectURLPath {
	return @"phototest://auth";
}

- (NSDictionary *)additionalParameters {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"code", @"response_type",
			nil];
}

@end
