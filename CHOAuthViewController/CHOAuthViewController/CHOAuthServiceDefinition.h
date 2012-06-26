//
//  CHOAuthServiceDefinition.h
//  CHOAuthViewController
//
//  Created by Colin Humber on 6/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol CHOAuthServiceDefinition <NSObject>

// name of the service being defined. Used to generate the save path for the access token and is displayed on the popup's navigation bar
- (NSString *)serviceName;

// oAuth version supported by the service. Must be either 1.0 or 2.0.
- (CGFloat)oAuthVersion;

// client ID for the application. Sometimes called client key or consumer key
- (NSString *)clientID;

// client secret for the application. Sometimes called consumer secret
- (NSString *)clientSecret;

// request URL defined for the service. Only used for oAuth 1.0 services
- (NSString *)requestURLPath;

// authorization URL defined for the service. Used in both oAuth 1.0 and 2.0
- (NSString *)authorizeURLPath;

// token URL defined for the service. Used in both oAuth 1.0 and 2.0
- (NSString *)tokenURLPath;

// redirect URL defined for the service. Sometimes called callback URL. Used in both oAuth 1.0 and 2.0
- (NSString *)redirectURLPath;

@optional
// dictionary of parameters used during the authentication process. Generally used to define scope permissions, but may include any arbitrary
// values as required by the defined service
- (NSDictionary *)additionalParameters;

@end
