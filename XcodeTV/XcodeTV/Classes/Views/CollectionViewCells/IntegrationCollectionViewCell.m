//
//  IntegrationCollectionViewCell.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/7/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "IntegrationCollectionViewCell.h"
#import "NSDate+RelativeDateString.h"

@interface IntegrationCollectionViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *botNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;

@end

@implementation IntegrationCollectionViewCell

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 15;
}

#pragma mark - Public Methods

+ (NSString *)reuseIdentifier
{
    static NSString * cellIdentifier = @"DataItemCell";
    
    return cellIdentifier;
}

- (void)updateWithBot:(Bot *)bot
{
    self.botNameLabel.text = [bot.name stringByReplacingOccurrencesOfString:@"(Prod)" withString:@""];
    
#warning - ends up being negative if build is in progress
    self.timeLabel.text = [bot.lastIntegration.endedTime relativeDateStringFromNow];
    
    [self updateIconWithBot:bot];
    
}

#pragma mark - Private Methods

- (void)updateIconWithBot:(Bot *)bot
{
    if ([bot.name hasPrefix:@"ScreenRecorder"])
    {
        self.iconImageView.image = [UIImage imageNamed:@"Peek"];
    }
    else if ([bot.name hasPrefix:@"Storyline"])
    {
        self.iconImageView.image = [UIImage imageNamed:@"Storyline"];
    }
    else if ([bot.name hasPrefix:@"Preso"])
    {
        self.iconImageView.image = [UIImage imageNamed:@"Preso"];
    }
    else
    {
        self.iconImageView.image = [UIImage imageNamed:@"Bot-HackathonSmall"];
    }
}

@end
