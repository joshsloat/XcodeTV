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
@property (weak, nonatomic) IBOutlet UIView *errorStatusBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *errorStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *errorStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *warningStatusBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *warningStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *warningStatusLabel;
@property (weak, nonatomic) IBOutlet UIView *staticAnalysisBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *staticAnalysisImageView;
@property (weak, nonatomic) IBOutlet UILabel *staticAnalysisLabel;
@property (weak, nonatomic) IBOutlet UIView *unitTestBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *unitTestImageView;
@property (weak, nonatomic) IBOutlet UILabel *unitTestLabel;

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
    
    [self updateStatusWithBot:bot];
    
}

#pragma mark - Private Methods


- (void)updateStatusWithBot:(Bot *)bot
{
    [self updateStatusViewUsingImageView:self.errorStatusImageView
                              imageNamed:@"Status-BuildFailure"
                                   label:self.errorStatusLabel
                                    text:@"2"
                                   color:[UIColor redColor]];
    
    [self updateStatusViewUsingImageView:self.warningStatusImageView
                              imageNamed:@"Status-BuildWarning"
                                   label:self.warningStatusLabel
                                    text:@"2"
                                   color:[UIColor yellowColor]];
    
    [self updateStatusViewUsingImageView:self.staticAnalysisImageView
                              imageNamed:@"Status-StaticAnalysis"
                                   label:self.staticAnalysisLabel
                                    text:@"2"
                                   color:[UIColor blueColor]];
    
    [self updateStatusViewUsingImageView:self.unitTestImageView
                              imageNamed:@"Status-TestSuccess"
                                   label:self.unitTestLabel
                                    text:@"2"
                                   color:[UIColor colorWithRed:81/255.0 green:250/255.0 blue:0 alpha:1.0]];
}

- (void)updateStatusViewUsingImageView:(UIImageView *)imageView
                            imageNamed:(NSString *)imageName
                                 label:(UILabel *)label
                                  text:(NSString *)text
                                 color:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    imageView.image = image;
    imageView.tintColor = color;
    
    label.text = @"2";
    label.textColor = color;
}

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
