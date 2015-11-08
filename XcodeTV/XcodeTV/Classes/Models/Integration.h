//
//  Integration.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"
#import "BuildResultSummary.h"

@protocol Integration @end

@interface Integration : BaseModel

@property (nonatomic) double duration;
@property (nonatomic, strong) NSDate *queuedDate;
@property (nonatomic, strong) NSDate *endedTime;
@property (nonatomic, copy) NSString *result;
@property (nonatomic, copy) NSString *currentStep;
@property (nonatomic, strong) BuildResultSummary *buildResultSummary;
@property (nonatomic) NSInteger number;

@end
