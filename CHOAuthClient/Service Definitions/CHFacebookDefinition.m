//
//  CHFacebookDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHFacebookDefinition.h"

@implementation CHFacebookDefinition

- (NSString *)serviceName {
	return @"Facebook";
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
