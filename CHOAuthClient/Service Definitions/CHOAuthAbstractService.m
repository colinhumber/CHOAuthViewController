//
//  CHAbstractService.m
//  CHOAuthViewController
//
//  Created by Sensis on 17/07/12.
//
//

#import "CHOAuthAbstractService.h"

@implementation CHOAuthAbstractService

-(id) initWithClientId:(NSString *)clientId secret:(NSString *)secret {
	self = [super init];
	if (self) {
		_clientId = clientId;
		_secret = secret;
	}
	return self;
}

- (NSString *)clientID {
	return _clientId;
}

- (NSString *)clientSecret {
	return _secret;
}

- (CGFloat)oAuthVersion {
	return OUATH_V2;
}

// Nil defaults.

- (NSString *)serviceName {
	return nil;
}

- (NSString *)authorizeURLPath {
	return nil;
}

- (NSString *)tokenURLPath {
	return nil;
}

- (NSString *)redirectURLPath {
	return nil;
}

@end
