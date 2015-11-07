//
//  IntegrationCollectionViewCell.h
//  XcodeTV
//
//  Created by Josh Sloat on 11/7/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Bot.h"

@interface IntegrationCollectionViewCell : UICollectionViewCell

+ (NSString *)reuseIdentifier;

- (void)updateWithBot:(Bot *)bot;

@end
