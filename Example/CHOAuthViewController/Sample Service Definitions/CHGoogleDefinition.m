//
//  CHGoogleDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/8/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHGoogleDefinition.h"

@implementation CHGoogleDefinition
- (NSString *)serviceName {
	return @"Google";
}

- (CGFloat)oAuthVersion {
	return 2.0;
}

- (NSString *)clientID {
	return @"807033624458.apps.googleusercontent.com";
}

- (NSString *)clientSecret {
	return @"o_BG5A-krWXae_mki9OXGROd";
}

- (NSString *)requestURLPath {
	return nil;
}

- (NSString *)authorizeURLPath {
	return @"https://accounts.google.com/o/oauth2/auth";
}

- (NSString *)tokenURLPath {
	return @"https://accounts.google.com/o/oauth2/token";
}

- (NSString *)redirectURLPath {
	return @"http://localhost";
}

- (NSDictionary *)additionalParameters {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"offline", @"access_type",
			@"code", @"response_type",
			@"https://picasaweb.google.com/data/", @"scope",
			nil];
}
@end
