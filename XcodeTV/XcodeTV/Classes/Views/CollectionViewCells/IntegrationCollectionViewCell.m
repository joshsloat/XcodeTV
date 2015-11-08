//
//  IntegrationCollectionViewCell.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/7/15.
//  Copyright © 2015 Articulate. All rights reserved.
//
//  TODO:
//      [ ] Hiding status container views causes constraint issues on refresh
//      [ ] Not currently reporting failed status for cancelled builds
//      [ ] If a cell is focused when a refresh happens, the image flickers - ideally
//           would like a better solution so we can refresh more frequently to check for
//           triggered builds, completed builds, new bots, etc.
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
@property (weak, nonatomic) IBOutlet UIView *badgeView;
@property (weak, nonatomic) IBOutlet UILabel *badgeLabel;
@property (weak, nonatomic) IBOutlet UIStackView *stackView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (weak, nonatomic) IBOutlet UILabel *activityLabel;

@end

@implementation IntegrationCollectionViewCell

#pragma mark - Overrides

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundImageView.clipsToBounds = YES;
    self.backgroundImageView.layer.cornerRadius = 15;
    
    self.badgeView.backgroundColor = [UIColor colorWithRed:1.0 green:59/255.0 blue:48/255.0 alpha:1.0];
    self.badgeView.layer.cornerRadius = self.badgeView.bounds.size.width / 2.0f;
}

#pragma mark - Public Methods

+ (NSString *)reuseIdentifier
{
    static NSString * cellIdentifier = @"DataItemCell";
    
    return cellIdentifier;
}

- (void)updateWithBot:(Bot *)bot
{
    NSString *buildTitle = [bot.name stringByReplacingOccurrencesOfString:@"(Prod)" withString:@""];
    
    buildTitle = [NSString stringWithFormat:@"%@ (%ld)", buildTitle, bot.lastIntegration.number];
    
    self.botNameLabel.text = buildTitle;
    
    [self updateIconWithBot:bot];
    
    [self updateBadgeViewWithBot:bot];

    if (bot.isLastIntegrationComplete)
    {
        [self updateForCompletedIntegrationWithBot:bot];
    }
    else
    {
        // TODO: auto layout is not happy about this
        [self updateForInProgressIntegrationWithBot:bot];
    }
}

#pragma mark - Private Methods

- (void)updateForCompletedIntegrationWithBot:(Bot *)bot
{
    self.botNameLabel.textColor = [UIColor whiteColor];
    self.iconImageView.adjustsImageWhenAncestorFocused = YES;
    
    self.timeLabel.hidden = NO;
    self.stackView.hidden = NO;
    self.activityLabel.hidden = YES;
    
    self.timeLabel.text = [bot.lastIntegration.endedTime relativeDateStringFromNow];
    
    [self updateStatusWithBot:bot];
    
    [self.activityIndicator stopAnimating];
}

- (void)updateForInProgressIntegrationWithBot:(Bot *)bot
{
    self.botNameLabel.textColor = [UIColor colorWithRed:81/255.0 green:250/255.0 blue:0 alpha:1.0];
    
    self.iconImageView.adjustsImageWhenAncestorFocused = NO;
    
    self.stackView.hidden = YES;
    
    self.timeLabel.hidden = YES;
    self.activityLabel.hidden = NO;
    self.activityLabel.text = [NSString stringWithFormat:@"%@...", [bot.lastIntegration.currentStep capitalizedString]];
    
    [self.activityIndicator startAnimating];
}

- (void)updateStatusWithBot:(Bot *)bot
{
    [self updateStatusViewUsingImageView:self.errorStatusImageView
                              imageNamed:@"Status-BuildFailure"
                                   label:self.errorStatusLabel
                                   count:bot.lastIntegration.buildResultSummary.errorCount
                                   color:[UIColor redColor]];
    
    [self updateStatusViewUsingImageView:self.warningStatusImageView
                              imageNamed:@"Status-BuildWarning"
                                   label:self.warningStatusLabel
                                    count:bot.lastIntegration.buildResultSummary.warningCount
                                   color:[UIColor yellowColor]];
    
    [self updateStatusViewUsingImageView:self.staticAnalysisImageView
                              imageNamed:@"Status-StaticAnalysis"
                                   label:self.staticAnalysisLabel
                                    count:bot.lastIntegration.buildResultSummary.analyzerWarningCount
                                   color:[UIColor blueColor]];
    
    if (bot.lastIntegration.buildResultSummary.testFailureCount > 0)
    {
        [self updateStatusViewUsingImageView:self.unitTestImageView
                                  imageNamed:@"Status-TestFailure"
                                       label:self.unitTestLabel
                                       count:bot.lastIntegration.buildResultSummary.testFailureCount
                                       color:[UIColor redColor]];
    }
    else
    {
        [self updateStatusViewUsingImageView:self.unitTestImageView
                                  imageNamed:@"Status-TestSuccess"
                                       label:self.unitTestLabel
                                        count:bot.lastIntegration.buildResultSummary.testsCount
                                       color:[UIColor colorWithRed:81/255.0 green:250/255.0 blue:0 alpha:1.0]];
    }
    
    if ([bot.name containsString:@"Daily"])
    {
        self.staticAnalysisBackgroundView.hidden = YES;
        self.unitTestBackgroundView.hidden = YES;
    }
    else
    {
        self.staticAnalysisBackgroundView.hidden = NO;
        self.unitTestBackgroundView.hidden = NO;
    }
}

- (void)updateBadgeViewWithBot:(Bot *)bot
{
    self.badgeView.hidden = bot.failureCount == 0;
    
    NSString *failureString = [NSString stringWithFormat:@"%lu", bot.failureCount];
    
    self.badgeLabel.text = failureString;
    
    [self.badgeView.superview layoutIfNeeded];
    
    if (failureString.length > 1)
    {
        self.badgeView.layer.cornerRadius = 20;
    }
    else
    {
        self.badgeView.layer.cornerRadius = self.badgeView.bounds.size.width / 2.0f;
    }
}

- (void)updateStatusViewUsingImageView:(UIImageView *)imageView
                            imageNamed:(NSString *)imageName
                                 label:(UILabel *)label
                                  count:(NSInteger)count
                                 color:(UIColor *)color
{
    UIImage *image = [UIImage imageNamed:imageName];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    imageView.image = image;
    imageView.tintColor = color;
    
    label.text = [NSString stringWithFormat:@"%lu", count];
    label.textColor = color;
}

- (void)updateIconWithBot:(Bot *)bot
{
    if ([bot.name hasPrefix:@"ScreenRecorder"])
    {
        [self roundCornersForImageNamed:@"Peek" inImageView:self.iconImageView];
    }
    else if ([bot.name hasPrefix:@"Storyline"])
    {
        self.iconImageView.image = [UIImage imageNamed:@"Storyline"];
    }
    else if ([bot.name hasPrefix:@"Preso"])
    {
        [self roundCornersForImageNamed:@"Preso" inImageView:self.iconImageView];
    }
    else
    {
        self.iconImageView.image = [UIImage imageNamed:@"Bot-HackathonSmall"];
    }
}

- (void)roundCornersForImageNamed:(NSString *)imageNamed inImageView:(UIImageView *)imageView
{
    UIImage *image = [UIImage imageNamed:imageNamed];
    
    // Begin a new image that will be the new image with the rounded corners
    // (here with the size of an UIImageView)
    UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, NO, 1.0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    [[UIBezierPath bezierPathWithRoundedRect:imageView.bounds
                                cornerRadius:10.0] addClip];
    // Draw your image
    [image drawInRect:imageView.bounds];
    
    // Get the image, here setting the UIImageView image
    imageView.image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
}

@end
