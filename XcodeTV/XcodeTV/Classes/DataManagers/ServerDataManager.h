//
//  ServerDataManager.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Server.h"

@interface ServerDataManager : NSObject

+ (BOOL)isServerConfigured;

+ (void)saveServerConfiguration:(Server *)server;

+ (Server *)defaultServerConfiguration;

@end
