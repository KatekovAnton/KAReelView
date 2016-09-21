//
//  KATimeIntervalView.m
//  KAReelView
//
//  Created by Katekov Anton on 9/8/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "KATimeIntervalView.h"
#import "KAReelNumberView.h"
#import "KAReelNumeralView.h"



@implementation KATimeIntervalView

- (id)init
{
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    if (!self.font)
        self.font = [UIFont fontWithName:@"Courier" size:20];
    
    if (!self.textColor)
        self.textColor = [UIColor whiteColor];
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    _viewMinutes = [[KAReelNumberView alloc] init];
    _viewMinutes.textColor = self.textColor;
    _viewMinutes.font = self.font;
    _viewMinutes.numberOfDigits = 2;
//    [_viewMinutes numeralViewAtIndex:0].amountOfNumbers = 6;
    [self addSubview:_viewMinutes];
    
    _viewSeconds = [[KAReelNumberView alloc] init];
    _viewSeconds.textColor = self.textColor;
    _viewSeconds.font = self.font;
    _viewSeconds.numberOfDigits = 2;
    [_viewSeconds numeralViewAtIndex:0].amountOfNumbers = 6;
    [self addSubview:_viewSeconds];
    
    _labelDot = [[UILabel alloc] init];
    _labelDot.text = @".";
    _labelDot.textColor = self.textColor;
    _labelDot.font = self.font;
    [self addSubview:_labelDot];
    
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / 2;
    CGRect frame = CGRectMake(0, 0, width, self.frame.size.height);
    _viewMinutes.frame = frame;
    frame.origin.x += width;
    _viewSeconds.frame = frame;
    
    frame.origin.x -= frame.size.width/5;
    _labelDot.frame = frame;
    
    [_viewMinutes layoutIfNeeded];
    [_viewSeconds layoutIfNeeded];
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _viewMinutes.textColor = self.textColor;
    _viewSeconds.textColor = self.textColor;
    _labelDot.textColor = self.textColor;
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    _viewMinutes.font = self.font;
    _viewSeconds.font = self.font;
    _labelDot.font = self.font;
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated
{
    KAReelDirection direction = KAReelDirectionNone;
    if (animated) {
        direction = timeInterval > _timeInterval? KAReelDirectionIncreasing : KAReelDirectionDecreasing;
    }
    
    _timeInterval = timeInterval;
    int minutes = (int)_timeInterval / 60;
    int seconds = (int)_timeInterval % 60;
    [_viewMinutes setNumber:minutes direction:direction];
    [_viewSeconds setNumber:seconds direction:direction];
}

@end
