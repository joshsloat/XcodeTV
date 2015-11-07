//
//  GradientMaskView.m
//  XcodeTV
//
//  Created by Josh Sloat on 11/7/15.
//  Copyright © 2015 Articulate. All rights reserved.
//

#import "GradientMaskView.h"

@interface GradientMaskView ()

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@end

@implementation GradientMaskView

#pragma mark - Init / Dealloc

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self commonInit];
    }
    
    return self;
}

- (void)commonInit
{
    _maskPosition = [MaskPosition new];
    
    [self.layer addSublayer:self.gradientLayer];
    
    [self updateGradientLayer];
}

#pragma mark - Overrides

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateGradientLayer];
}

#pragma mark - Properties

- (void)setMaskPosition:(MaskPosition *)maskPosition
{
    _maskPosition = maskPosition;
    
    [self updateGradientLayer];
}

- (CAGradientLayer *)gradientLayer
{
    if (!_gradientLayer)
    {
        _gradientLayer = [CAGradientLayer new];
        _gradientLayer.colors = @[(id)[UIColor colorWithWhite:0.0 alpha:0.0].CGColor,
                                  (id)[UIColor colorWithWhite:0.0 alpha:1.0].CGColor];
    }
    
    return _gradientLayer;
}

#pragma mark - Private Methods

- (void)updateGradientLayer
{
    self.gradientLayer.frame = CGRectMake(CGPointZero.x, CGPointZero.y, self.bounds.size.width, self.bounds.size.height);
    
    self.gradientLayer.locations = @[@(self.maskPosition.end / self.bounds.size.height),
                                     @(self.maskPosition.start / self.bounds.size.height)];
}

@end
