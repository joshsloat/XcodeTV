//
//  Integration.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"

@protocol Integration @end

@interface Integration : BaseModel

@property (nonatomic) double duration;
@property (nonatomic, strong) NSDate *endedTime;
@property (nonatomic, copy) NSString *result;

@end
