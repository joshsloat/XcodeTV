//
//  Bot.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "Bot.h"

@implementation Bot

NSString * const kRequestIdentifierPropertyName = @"_id";
NSString * const kIntegrationCounterPropertyName = @"integration_counter";

#pragma mark - Properties

- (NSInteger)failureCount
{
    return self.lastIntegration.buildResultSummary.errorCount +
           self.lastIntegration.buildResultSummary.testFailureCount;
}

#pragma mark - Overrides

+ (NSDictionary *)JSONtoModelMapOverrides
{
    return @{ kRequestIdentifierPropertyName : NSStringFromSelector(@selector(identifier)),
              kIntegrationCounterPropertyName : NSStringFromSelector(@selector(integrationCounter))};
}

@end
