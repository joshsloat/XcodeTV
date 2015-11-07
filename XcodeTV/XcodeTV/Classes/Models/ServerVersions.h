//
//  ServerVersions.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"

@interface ServerVersions : BaseModel

@property (nonatomic, copy) NSString *os;
@property (nonatomic, copy) NSString *server;
@property (nonatomic, copy) NSString *xcodeServer;
@property (nonatomic, copy) NSString *xcode;

@end
