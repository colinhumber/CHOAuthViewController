//
//  CHServiceConfiguration.h
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DefaultCHOAuth2Configuration;

@interface CHServiceConfiguration : NSObject

+ (CHServiceConfiguration *)sharedInstance;
+ (CHServiceConfiguration *)sharedInstanceWithServiceConfiguration:(DefaultCHOAuth2Configuration*)config;
- (id)valueForSetting:(NSString *)settingName;

@end
