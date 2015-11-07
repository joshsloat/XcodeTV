//
//  XcodeServerSessionManager.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface XcodeServerSessionManager : AFHTTPSessionManager

+ (XcodeServerSessionManager *)sharedManager;

@end
