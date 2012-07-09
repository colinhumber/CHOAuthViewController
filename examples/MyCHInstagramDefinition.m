//
//  CHInstagramDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyCHInstagramDefinition.h"

@implementation MyCHInstagramDefinition

- (NSString *)serviceName {
	return @"Instagram";
}

- (CGFloat)oAuthVersion {
	return 2.0;
}

- (NSString *)clientID {
	return @"d2eb5be8b572404383d6a3ac94f654c4";
}

- (NSString *)clientSecret {
	return @"3849d8323799403580eb80beda7b152f";
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
