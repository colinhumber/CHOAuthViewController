//
//  CHInstagramDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHInstagramDefinition.h"

@implementation CHInstagramDefinition

- (NSString *)serviceName {
	return @"Instagram";
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
