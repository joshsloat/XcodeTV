//
//  IntegrationCollection.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BaseModel.h"
#import "Integration.h"

@interface IntegrationCollection : BaseModel

@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSArray<Integration> *results;

@end
