//
//  BuildResultSummary.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/7/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"

@interface BuildResultSummary : BaseModel

@property (nonatomic) NSInteger analyzerWarningChange;
@property (nonatomic) NSInteger analyzerWarningCount;
@property (nonatomic) NSInteger codeCoveragePercentage;
@property (nonatomic) NSInteger codeCoveragePercentageDelta;
@property (nonatomic) NSInteger errorChange;
@property (nonatomic) NSInteger errorCount;
@property (nonatomic) NSInteger improvedPerfTestCount;
@property (nonatomic) NSInteger regressedPerfTestCount;
@property (nonatomic) NSInteger testFailureChange;
@property (nonatomic) NSInteger testFailureCount;
@property (nonatomic) NSInteger testsChange;
@property (nonatomic) NSInteger testsCount;
@property (nonatomic) NSInteger warningChange;
@property (nonatomic) NSInteger warningCount;

@end
