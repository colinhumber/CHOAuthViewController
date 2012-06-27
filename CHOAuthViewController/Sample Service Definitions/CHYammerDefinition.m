//
//  CHYammerDefinition.m
//  CHOAuthViewController
//
//  Created by Derek Clarkson on 26/06/12.
//  Copyright (c) 2012 Sensis. All rights reserved.
//

#import "CHYammerDefinition.h"

@implementation CHYammerDefinition
- (NSString *)serviceName {
	return @"Yammer";
}

- (CGFloat)oAuthVersion {
	return 2.0;
}

- (NSString *)clientID {
	return @"hgcfOES0jojCR1rrYqdtQ";
}

- (NSString *)clientSecret {
	return @"UaTdF5ww5GbQ2OxuakiMQwVDrH6ThVkl37Dokp38gY";
}

- (NSString *)requestURLPath {
	return nil;
}

- (NSString *)authorizeURLPath {
	return @"https://www.yammer.com/dialog/oauth";
}

- (NSString *)tokenURLPath {
	return @"https://www.yammer.com/oauth2/access_token.json";
}

- (NSString *)redirectURLPath {
	return @"https://www.yammer.com/authorize";
}

- (NSDictionary *)additionalParameters {
    return nil;
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"token", @"response_type",
			nil];
}
@end
