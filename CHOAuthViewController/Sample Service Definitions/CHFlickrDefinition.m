//
//  CHFlickrDefinition.m
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHFlickrDefinition.h"

@implementation CHFlickrDefinition

- (NSString *)serviceName {
	return @"Flickr";
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
	return @"http://www.flickr.com/services/oauth/request_token";
}

- (NSString *)authorizeURLPath {
	return @"http://www.flickr.com/services/oauth/authorize";
}

- (NSString *)tokenURLPath {
	return @"http://www.flickr.com/services/oauth/access_token";
}

- (NSString *)redirectURLPath {
	return @"http://example.com";
}

- (NSDictionary *)additionalParameters {
	return [NSDictionary dictionaryWithObjectsAndKeys:
			@"read", @"perms", 
			nil];
}

@end
