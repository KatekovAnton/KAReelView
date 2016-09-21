//
//  KAReelNumberView.m
//  KAReelView
//
//  Created by Katekov Anton on 9/7/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "KAReelNumberView.h"
#import "KAReelNumeralView.h"



@interface KAReelNumberView () {
    NSMutableArray *_numeralViews;
}

@end



@implementation KAReelNumberView

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
  
    if (_numberOfDigits == 0)
        _numberOfDigits = 4;
    
    [self setupSubviews];
}

- (void)setupSubviews
{
    // TODO:
    // possible optimization here:
    // remove only required amount of numeral views
    // to avoid its re-creation
    
    for (KAReelNumeralView *view in _numeralViews) {
        [view abortAnimation];
        [view removeFromSuperview];
    }
    
    _numeralViews = [NSMutableArray arrayWithCapacity:_numberOfDigits];
    
    for (int i = 0; i < _numberOfDigits; i++) {
        KAReelNumeralView *numeralView = [[KAReelNumeralView alloc] init];
        numeralView.textColor = self.textColor;
        numeralView.font = self.font;
        [self addSubview:numeralView];
        [_numeralViews addObject:numeralView];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat width = self.frame.size.width / _numberOfDigits;
    CGRect digitFrame = CGRectMake(0, 0, width, self.frame.size.height);
    for (int i = 0; i < _numberOfDigits; i++) {
        KAReelNumeralView *numeralView = _numeralViews[i];
        [numeralView setFrame:digitFrame];
        digitFrame.origin.x += width;
        [numeralView layoutIfNeeded];
    }
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    for (KAReelNumeralView *numeralView in _numeralViews) {
        numeralView.textColor = _textColor;
    }
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    for (KAReelNumeralView *numeralView in _numeralViews) {
        numeralView.font = _font;
    }
}

- (void)setNumberOfDigits:(NSUInteger)numberOfDigits
{
    if (_numberOfDigits == numberOfDigits) {
        return;
    }
    if (_numberOfDigits < 1) {
        _numberOfDigits = 1;
    }
    
    _numberOfDigits = numberOfDigits;
    [self setupSubviews];
    [self layoutIfNeeded];
    [self setNumber:_number];
}

- (void)setNumber:(NSUInteger)number
{
    [self setNumber:number animated:NO];
}

- (void)setNumber:(NSUInteger)number animated:(BOOL)animated
{
    KAReelDirection direction = KAReelDirectionNone;
    if (animated) {
        direction = number > _number? KAReelDirectionIncreasing : KAReelDirectionDecreasing;
    }
    [self setNumber:number direction:direction];
}

- (void)setNumber:(NSUInteger)number direction:(KAReelDirection)direction
{
    {
        // TODO:
        // possible improvement here:
        // increase number of digits in view
        
        NSUInteger maximum = [self maximum];
        if (number > maximum) {
            number = maximum;
        }
    }
    
    _number = number;
    
    // TODO:
    // possible optimization here:
    // pre-calculate format string
    
    NSString *format = [NSString stringWithFormat:@"%%0%lud", (unsigned long)_numberOfDigits];
    NSString *numberAsString = [NSString stringWithFormat:format, _number];
    
    BOOL startAnimate = NO;
    for (int i = 0; i < numberAsString.length; i++) {
        NSString *numeralString = [numberAsString substringWithRange:NSMakeRange(i, 1)];
        KAReelNumeralView *numeralView = _numeralViews[i];
        int number = [numeralString intValue];
        if (direction != KAReelDirectionNone &&
            number == numeralView.number &&
            !startAnimate) {
            // dont animate digits that are already in right position
            // if all its higher digits stays the same
            continue;
        }
        startAnimate = YES;
        
        // TODO:
        // possible improvement here:
        // pass circle sign to force drum to reel full circle if highter digit has changed
        // to make effect of full counting
        
        [numeralView setNumber:number direction:direction];
    }
    
}

- (KAReelNumeralView*)numeralViewAtIndex:(NSUInteger)index
{
    return _numeralViews[index];
}

- (NSUInteger)maximum
{
    NSUInteger result = 1;
    for (int i = 0; i < _numberOfDigits; i++) {
        result *= [self numeralViewAtIndex:i].amountOfNumbers;
    }
    return result - 1;
}

@end
