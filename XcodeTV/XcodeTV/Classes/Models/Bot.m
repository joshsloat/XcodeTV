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

#pragma mark - Overrides

+ (NSDictionary *)JSONtoModelMapOverrides
{
    return @{ kRequestIdentifierPropertyName : NSStringFromSelector(@selector(identifier)) };
}

@end
