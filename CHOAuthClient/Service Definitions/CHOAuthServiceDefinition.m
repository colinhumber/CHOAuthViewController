//
//  CHAbstractService.m
//  CHOAuthViewController
//
//  Created by Sensis on 17/07/12.
//
//

#import "CHOAuthServiceDefinition.h"
#import "CHFacebookDefinition.h"
#import "CHGoogleDefinition.h"
#import "CHInstagramDefinition.h"
#import "CHTwitterDefinition.h"
#import "CHYammerDefinition.h"

@interface CHOAuthServiceDefinition () {
@private
	NSString *_clientId;
	NSString *_secret;
}

@end

@implementation CHOAuthServiceDefinition

+(CHOAuthServiceDefinition *) serviceDefintionForProvider:(CHServiceProvider) serviceProvider
												  clientId:(NSString *) clientId
													 secret:(NSString *) secret {
	
	CHOAuthServiceDefinition *service;
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

// Nil defaults for everything.

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

- (NSString *)requestURLPath {
	return nil;
}

- (NSDictionary *)additionalParameters {
	return nil;
}

-(NSString *) accessTokenKeyPath {
	return @"access_token";
}

@end
