//
//  ServerDataManager.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"
#import "ServerVersions.h"

typedef void(^ServerDataManagerSuccessBlock)(NSDictionary *infoDictionary, id payload);
typedef void(^ServerDataManagerFailureBlock)(NSDictionary *infoDictionary, NSError *error);

@interface ServerDataManager : NSObject

+ (BOOL)isServerConfigured;

+ (void)saveServerConfiguration:(Server *)server;

+ (Server *)defaultServerConfiguration;

+ (void)getServerVersionsForServer:(Server *)server
                       withSuccess:(ServerDataManagerSuccessBlock)success
                           failure:(ServerDataManagerFailureBlock)failure;

@end
