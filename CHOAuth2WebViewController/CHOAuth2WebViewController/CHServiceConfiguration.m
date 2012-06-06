//
//  CHServiceConfiguration.m
//  CHOAuth2WebViewController
//
//  Created by Colin Humber on 6/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CHServiceConfiguration.h"
#import "DefaultCHOAuth2Configuration.h"

static CHServiceConfiguration *_sharedInstance = nil;


@interface CHServiceConfiguration ()
@property (nonatomic, strong) DefaultCHOAuth2Configuration *configuration;
- (id)initWithConfiguration:(DefaultCHOAuth2Configuration *)config;
@end


@implementation CHServiceConfiguration

@synthesize configuration = _configuration;

+ (CHServiceConfiguration *)sharedInstance {
	return _sharedInstance;
}

+ (CHServiceConfiguration *)sharedInstanceWithServiceConfiguration:(DefaultCHOAuth2Configuration*)config {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_sharedInstance = [[CHServiceConfiguration alloc] initWithConfiguration:config];
	});
	
	return _sharedInstance;
}

- (id)initWithConfiguration:(DefaultCHOAuth2Configuration *)config {
	self = [super init];
	
	if (self) {
		self.configuration = config;
	}
	
	return self;
}

- (id)valueForSetting:(NSString *)settingName {
	NSAssert(settingName != nil, @"A valid setting name must be provided.");
	
	SEL selector = NSSelectorFromString(settingName);
	
	id settingValue = nil;
	if ([self.configuration respondsToSelector:selector]) {
		#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
		settingValue = [self.configuration performSelector:selector];
	}

	return settingValue;
}

@end
