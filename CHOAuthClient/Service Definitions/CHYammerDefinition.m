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

- (NSString *)authorizeURLPath {
	return @"https://www.yammer.com/dialog/oauth";
}

- (NSString *)tokenURLPath {
	return @"https://www.yammer.com/oauth2/access_token.json";
}

- (NSString *)redirectURLPath {
	return @"https://www.yammer.com/authorize";
}

-(NSString *) accessTokenKeyPath {
	return @"access_token.token";
}

@end
