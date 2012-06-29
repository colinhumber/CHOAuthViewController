//
//  CH500PixelsDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/25/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CH500PixelsDefinition.h"

@implementation CH500PixelsDefinition

- (NSString *)serviceName {
	return @"500px";
}

- (CGFloat)oAuthVersion {
	return 1.0;
}

- (NSString *)clientID {
	return @"your client ID";
}

- (NSString *)clientSecret {
	return @"your client secret";
}

- (NSString *)requestURLPath {
	return @"https://api.500px.com/v1/oauth/request_token";
}

- (NSString *)authorizeURLPath {
	return @"https://api.500px.com/v1/oauth/authorize";
}

- (NSString *)tokenURLPath {
	return @"https://api.500px.com/v1/oauth/access_token";
}

- (NSString *)redirectURLPath {
	return @"http://phototest.com/auth";
}

- (NSDictionary *)additionalParameters {
	return nil;
}

@end
