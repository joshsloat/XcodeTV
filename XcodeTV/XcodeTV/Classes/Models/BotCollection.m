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

- (BOOL)hasActiveBuilds
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"isLastIntegrationComplete == NO"];
    
    BOOL hasActiveBuilds = [self.results filteredArrayUsingPredicate:predicate].count > 0;
    
    return hasActiveBuilds;
}

#pragma mark - Public Methods

- (void)sortByQueuedDate
{    
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:JCValidateKeyPathWithClass(Bot, lastIntegration.queuedDate)
                                                                     ascending:NO];
    
    [self.results sortUsingDescriptors:@[sortDescriptor]];
}

@end
