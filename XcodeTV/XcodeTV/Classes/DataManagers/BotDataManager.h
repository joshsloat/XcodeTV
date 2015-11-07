//
//  BotDataManager.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BotCollection.h"

typedef void(^BotDataManagerSuccessBlock)(NSDictionary *infoDictionary, id payload);
typedef void(^BotDataManagerFailureBlock)(NSDictionary *infoDictionary, NSError *error);

@interface BotDataManager : NSObject

- (void)getBotsWithSuccess:(BotDataManagerSuccessBlock)success
                   failure:(BotDataManagerFailureBlock)failure;

@end
