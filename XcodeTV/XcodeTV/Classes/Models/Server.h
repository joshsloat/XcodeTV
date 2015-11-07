//
//  Server.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"

@interface Server : BaseModel

@property (nonatomic, copy) NSString *hostAddress;
@property (nonatomic, copy) NSString *hostDescription;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;

@end
