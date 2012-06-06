//
//  CHConfiguration.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHConfiguration.h"

@implementation CHConfiguration

- (NSString *)instagramClientId {
	return @"d2eb5be8b572404383d6a3ac94f654c4";
}

- (NSString *)instagramClientSecret {
	return @"3849d8323799403580eb80beda7b152f";
}

- (NSURL *)instagramRedirectURL {
	return [NSURL URLWithString:@"phototest://auth"];
}


#pragma mark - Facebook
- (NSString *)facebookClientId {
	return @"175666859124998";
}

- (NSString *)facebookClientSecret {
	return @"bf72778ae068d0d71f9a01a93cdedb51";
}

- (NSURL *)facebookRedirectURL {
	return [NSURL URLWithString:@"https://apps.facebook.com/chumbertest"];
}

#pragma mark - Twitter
- (NSString *)twitterClientId {
	return @"TAPAn1TuOoPSWG7nziiA";
}

- (NSString *)twitterClientSecret {
	return @"sz6Ewds6nfpc32CMG1YSWWPH0hUtc24jStLD5CIqmT0";
}

- (NSURL *)twitterRedirectURL {
	return [NSURL URLWithString:@"http://example.com"];
}

#pragma mark - Google
- (NSString *)googleClientId {
	return @"807033624458.apps.googleusercontent.com";
}

- (NSString *)googleClientSecret {
	return @"o_BG5A-krWXae_mki9OXGROd";
}

- (NSURL *)googleRedirectURL {
	return [NSURL URLWithString:@"http://localhost"];
}

@end
