//
//  DefaultCHOAuth2Configuration.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DefaultCHOAuth2Configuration : NSObject

- (NSString *)instagramClientId;		// default: nil. Intended to be overwritten by subclass
- (NSString *)instagramClientSecret;	// default: nil. Intended to be overwritten by subclass
- (NSURL *)instagramRedirectURL;		// default: nil. 
- (NSURL *)instagramAuthorizeURL;		// default: https://api.instagram.com/oauth/authorize
- (NSURL *)instagramTokenURL;			// default https://api.instagram.com/oauth/access_token

- (NSString *)facebookClientId;			// default: nil. Intended to be overwritten by subclass
- (NSString *)facebookClientSecret;		// default: nil. Intended to be overwritten by subclass
- (NSURL *)facebookRedirectURL;			// default: nil. 
- (NSURL *)facebookAuthorizeURL;		// default: https://graph.facebook.com/oauth/authorize
- (NSURL *)facebookTokenURL;			// default: https://graph.facebook.com/oauth/access_token

- (NSString *)twitterClientId;			// default: nil. Intended to be overwritten by subclass
- (NSString *)twitterClientSecret;		// default: nil. Intended to be overwritten by subclass
- (NSURL *)twitterRedirectURL;			// default: nil. 
- (NSURL *)twitterAuthorizeURL;			// default: https://api.twitter.com/oauth/authorize
- (NSURL *)twitterTokenURL;				// default: https://api.twitter.com/oauth/access_token

- (NSString *)twitterClientId;			// default: nil. Intended to be overwritten by subclass
- (NSString *)twitterClientSecret;		// default: nil. Intended to be overwritten by subclass
- (NSURL *)twitterRedirectURL;			// default: nil. 
- (NSURL *)twitterAuthorizeURL;			// default: https://api.twitter.com/oauth/authorize
- (NSURL *)twitterTokenURL;				// default: https://api.twitter.com/oauth/access_token

- (NSString *)googleClientId;			// default: nil. Intended to be overwritten by subclass
- (NSString *)googleClientSecret;		// default: nil. Intended to be overwritten by subclass
- (NSURL *)googleRedirectURL;			// default: nil. 
- (NSURL *)googleAuthorizeURL;			// default: https://api.twitter.com/oauth/authorize
- (NSURL *)googleTokenURL;				// default: https://api.twitter.com/oauth/access_token


@end
