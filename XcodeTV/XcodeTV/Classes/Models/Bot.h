//
//  Bot.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"
#import "Integration.h"

@protocol Bot @end

@interface Bot : BaseModel

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) NSInteger integrationCounter;

@property (nonatomic, strong) Integration *lastIntegration;

@property (nonatomic, readonly) NSInteger failureCount;

@end
