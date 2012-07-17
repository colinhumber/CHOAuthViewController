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

- (CGFloat)oAuthVersion {
	return 2.0;
}

- (NSString *)clientID {
	return @"175666859124998";
}

- (NSString *)clientSecret {
	return @"bf72778ae068d0d71f9a01a93cdedb51";
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
