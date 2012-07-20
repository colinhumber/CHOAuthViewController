//
//  CHAbstractService.m
//  CHOAuthViewController
//
//  Created by Sensis on 17/07/12.
//
//

#import "CHOAuthAbstractService.h"
#import "CHFacebookDefinition.h"
#import "CHGoogleDefinition.h"
#import "CHInstagramDefinition.h"
#import "CHTwitterDefinition.h"
#import "CHYammerDefinition.h"

@interface CHOAuthService () {
@private
	NSString *_clientId;
	NSString *_secret;
}

@end

@implementation CHOAuthService

+(CHOAuthService *) serviceForProvider:(CHServiceProvider) serviceProvider
												  clientId:(NSString *) clientId
													 secret:(NSString *) secret {
	
	CHOAuthService *service;
	switch (serviceProvider) {
		case CHServiceProviderFacebook:
			service = [[CHFacebookDefinition alloc] initWithClientId:clientId secret:secret];
			break;
		case CHServiceProviderGoogle:
			service = [[CHGoogleDefinition alloc] initWithClientId:clientId secret:secret];
			break;
		case CHServiceProviderInstagram:
			service = [[CHInstagramDefinition alloc] initWithClientId:clientId secret:secret];
			break;
		case CHServiceProviderTwitter:
			service = [[CHTwitterDefinition alloc] initWithClientId:clientId secret:secret];
			break;
		case CHServiceProviderYammer:
			service = [[CHYammerDefinition alloc] initWithClientId:clientId secret:secret];
			break;
			
		default:
			@throw [NSException exceptionWithName:@"CHOAuthUnknownServiceException" reason:[NSString stringWithFormat:@"Unknown service id %i", serviceProvider] userInfo:nil];
			break;
	}
	
	return service;
}


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
