//
//  CHAbstractService.h
//  CHOAuthViewController
//
//  Created by Sensis on 17/07/12.
//
//

#import <Foundation/Foundation.h>
#import "CHOAuthServiceDefinition.h"

@interface CHOAuthAbstractService : NSObject<CHOAuthServiceDefinition> {
	@private
	NSString *_clientId;
	NSString *_secret;
}


@end
