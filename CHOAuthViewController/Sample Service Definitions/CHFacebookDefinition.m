//
//  CHFacebookDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 Colin Humber. All rights reserved.
//

#import "CHFacebookDefinition.h"

@implementation CHFacebookDefinition

- (NSString *)serviceName {
	return @"Facebook";
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
	return @"https://graph.facebook.com/oauth/authorize";
}

- (NSString *)tokenURLPath {
	return @"https://graph.facebook.com/oauth/access_token";
}

- (NSString *)redirectURLPath {
	return @"https://apps.facebook.com/chumbertest";
}

- (NSDictionary *)additionalParameters {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"touch", @"display",
			@"publish_stream", @"scope",
			nil];
}

@end
