//
//  CHAbstractService.h
//  CHOAuthViewController
//
//  Created by Sensis on 17/07/12.
//
//

#import <Foundation/Foundation.h>

#define OUATH_V1 1.0
#define OUATH_V2 2.0

// Service keys for some methods.
typedef enum {
	CHServiceProviderFacebook,
	CHServiceProviderGoogle,
	CHServiceProviderInstagram,
	CHServiceProviderTwitter,
	CHServiceProviderYammer
} CHServiceProvider;

@interface CHOAuthServiceDefinition : NSObject

// Service factory method.
+(CHOAuthServiceDefinition *) serviceDefintionForProvider:(CHServiceProvider) serviceProvider
												  clientId:(NSString *) clientId
													 secret:(NSString *) secret;

// Default initialiser that sets the client id and secret.
-(id) initWithClientId:(NSString *) clientId secret:(NSString *) secret;

// name of the service being defined. Used to generate the save path for the access token
- (NSString *)serviceName;

// oAuth version supported by the service. Must be either 1.0 or 2.0.
- (CGFloat)oAuthVersion;

// client ID for the application. Sometimes called client key or consumer key
- (NSString *)clientID;

// client secret for the application. Sometimes called consumer secret
- (NSString *)clientSecret;

// authorization URL defined for the service. Used in both oAuth 1.0 and 2.0
- (NSString *)authorizeURLPath;

// token URL defined for the service. Used in both oAuth 1.0 and 2.0
- (NSString *)tokenURLPath;

// redirect URL defined for the service. Sometimes called callback URL. Used in both oAuth 1.0 and 2.0
- (NSString *)redirectURLPath;

// request URL defined for the service. Only used for oAuth 1.0 services
- (NSString *)requestURLPath;

// dictionary of parameters used during the authentication process. Generally used to define scope permissions, but may include any arbitrary
// values as required by the service being defined
- (NSDictionary *)additionalParameters;

// If the access token cannot be retrieved from the "access_token" property then this can be specified to define a different path in the response.
// See Yammer for an instance where the access token is actually a json object and the actual access token is deeper in.
-(NSString *) accessTokenKeyPath;

@end
