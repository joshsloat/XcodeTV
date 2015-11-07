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
@property (nonatomic, strong) NSArray<Bot> *results;

@end
