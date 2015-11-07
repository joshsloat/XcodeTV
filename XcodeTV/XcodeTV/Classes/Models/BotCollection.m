//
//  BotCollection.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "BotCollection.h"
#import "JCKeyPathValidator.h"

@implementation BotCollection

#pragma mark - Properties

- (NSInteger)totalFailureCount
{
    NSString *path = JCValidateKeyPathWithClass(Bot, failureCount);
    
    NSString *keyPath = [NSString stringWithFormat:@"@sum.%@", path];
    
    NSNumber *sum = [self.results valueForKeyPath:keyPath];
    
    return sum.integerValue;
}

#pragma mark - Public Methods

- (void)sortByEndTime
{    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:JCValidateKeyPathWithClass(Bot, lastIntegration.endedTime)
                                                                     ascending:NO];
    
    [self.results sortUsingDescriptors:@[sortDescriptor]];
}

@end
