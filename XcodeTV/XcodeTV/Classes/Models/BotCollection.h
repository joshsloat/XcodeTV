//
//  BotCollection.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/6/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "JSONModel.h"
#import "Bot.h"

@interface BotCollection : JSONModel

@property (nonatomic) NSInteger count;
@property (nonatomic, strong) NSMutableArray<Bot> *results;
@property (nonatomic, readonly) NSInteger totalFailureCount;

- (BOOL)hasActiveBuilds;
- (void)sortByQueuedDate;

@end
