//
//  KAReelNumeralView.m
//  KAReelView
//
//  Created by Katekov Anton on 9/7/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "KAReelNumeralView.h"



CGRect CGRectMoveVertically(CGRect rect, CGFloat offset)
{
    rect.origin.y += offset;
    return rect;
}



@interface KAReelNumeralLayer : CALayer

@property (nonatomic) CGFloat offset;

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;

@property (nonatomic) int amountOfNumbers;

@end



@implementation KAReelNumeralLayer

+ (BOOL)needsDisplayForKey:(NSString *)key
{
    if ([key isEqualToString:@"offset"]) {
        return YES;
    }
    if ([key isEqualToString:@"font"]) {
        return YES;
    }
    if ([key isEqualToString:@"textColor"]) {
        return YES;
    }
    return [super needsDisplayForKey:key];
}

- (BOOL)needsDisplayOnBoundsChange
{
    return YES;
}

- (id)init
{
    if (self = [super init]) {
        self.contentsScale = [[UIScreen mainScreen] scale];
        self.offset = 0;
        self.font = [UIFont systemFontOfSize:10];
        self.textColor = [UIColor clearColor];
        self.amountOfNumbers = 10;
    }
    
    return self;
}

- (id)initWithLayer:(id)layer
{
    if (self = [super initWithLayer:layer])  {
        KAReelNumeralLayer *numeralLayer = (KAReelNumeralLayer*)layer;
        self.contentsScale = numeralLayer.contentsScale;
        self.offset = numeralLayer.offset;
        self.font = numeralLayer.font;
        self.textColor = numeralLayer.textColor;
        self.amountOfNumbers = numeralLayer.amountOfNumbers;
    }
    
    return self;
}

- (void)drawInContext:(CGContextRef)ctx
{
    [super drawInContext:ctx];
    
    // TODO:
    // possible optimization here:
    // pre-calculate attributes
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    NSDictionary *attributes = @{ NSFontAttributeName: _font,
                                  NSForegroundColorAttributeName : _textColor,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGFloat realOffset = [self normalizedOffset:_offset];
    CGFloat rowHeight = self.bounds.size.height;
    CGRect rectToDraw = self.bounds;
    rectToDraw.origin.y = rectToDraw.size.height / 2 - _font.lineHeight / 2 + realOffset;
    
    UIGraphicsPushContext(ctx);
    
    // TODO:
    // possible optimization here:
    // to draw only numerals that are in visible range
    
    for (int i = 0; i < _amountOfNumbers; i++) {
        [@(i).description drawInRect:rectToDraw withAttributes:attributes];
        rectToDraw = CGRectMoveVertically(rectToDraw, rowHeight);
    }
    [@"0" drawInRect:rectToDraw withAttributes:attributes];
    
    UIGraphicsPopContext();
}

- (CGFloat)normalizedOffset:(CGFloat)offset
{
    CGFloat rowHeight = self.bounds.size.height;
    CGFloat circleHeight = rowHeight * _amountOfNumbers; // 0 1 2 ... amountOfNumbers - 1 without ending 0
    
    CGFloat result = offset + circleHeight;
    // pure offset is from -circleHeight to 0
    // result is from 0 to circleHeight
    // for easier normalization
    
    NSInteger times = 0;
    if (offset < 0)
        times = offset / circleHeight;
    else
        times = result / circleHeight;
    result = result - times * circleHeight;
    result -= circleHeight;
    
    return result;
}

- (CGFloat)offsetForNumber:(int)number
{
    CGFloat rowHeight = self.bounds.size.height;
    return - number * rowHeight;
}

- (CGFloat)offsetForFullCircle
{
    CGFloat rowHeight = self.bounds.size.height;
    return _amountOfNumbers * rowHeight;
}

- (CGFloat)offsetForNewNumber:(int)newNumber circle:(int)circle
{
    CGFloat circleHeight = [self offsetForFullCircle];
    int circlesInCurrentOffset = _offset / circleHeight;
    
    CGFloat newOffset = [self offsetForNumber:newNumber];
    newOffset += (circlesInCurrentOffset + circle) * circleHeight;
    
    return newOffset;
}

@end



@implementation KAReelNumeralView

+ (Class)layerClass
{
    return [KAReelNumeralLayer class];
}

- (void)setContentScaleFactor:(CGFloat)contentScaleFactor
{
    [super setContentScaleFactor:contentScaleFactor];
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    layer.contentsScale = [UIScreen mainScreen].scale;
}

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
    self.backgroundColor = [UIColor clearColor];
    self.amountOfNumbers = 10;
    
    if (!self.font)
        self.font = [UIFont fontWithName:@"Courier" size:20];
    
    if (!self.textColor)
        self.textColor = [UIColor whiteColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.bounds = self.bounds;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    self.layer.bounds = self.bounds;
}

- (void)setNumber:(int)number direction:(KAReelDirection)direction
{
    [self abortAnimation];
    
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    
    int oldNumber = _number;
    _number = number;
    
    if (direction == KAReelDirectionNone) {
        [layer setOffset:[layer offsetForNumber:number]];
        [layer setNeedsDisplay];
    }
    else {
        
        CGFloat currentOffset = [layer offset];
        CGFloat newOffset = [layer offsetForNumber:number];
        
        // TODO:
        // possible improvement here:
        // pass number of circles to jump few circles
        // instead of just one
        
        if (_number <= oldNumber &&
            direction == KAReelDirectionIncreasing) {
            // jump to next cirle
            newOffset = [layer offsetForNewNumber:number circle:-1];
        }
        else if (_number >= oldNumber &&
                 direction == KAReelDirectionDecreasing) {
            // jump to previous circle
            newOffset = [layer offsetForNewNumber:number circle:1];
        }
        
        [layer setOffset:[layer normalizedOffset:newOffset]];
        CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"offset"];
        anim.fromValue = @(currentOffset);
        anim.toValue = @(newOffset);
        anim.duration = 0.8;
        anim.repeatCount = 0;
        anim.autoreverses = NO;
        anim.removedOnCompletion = YES;
        anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        [layer addAnimation:anim forKey:@"offset"];
    }
}

- (void)abortAnimation
{
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    KAReelNumeralLayer* presentationLayer = (KAReelNumeralLayer*) self.layer.presentationLayer;
    [layer removeAnimationForKey:@"offset"];
    if (presentationLayer)
        [layer setOffset:presentationLayer.offset];
}

- (void)setFont:(UIFont *)font
{
    _font = font;
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    layer.font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    layer.textColor = textColor;
    [layer setNeedsDisplay];
}

- (void)setAmountOfNumbers:(int)amountOfNumbers
{
    _amountOfNumbers = amountOfNumbers;
    KAReelNumeralLayer* layer = (KAReelNumeralLayer*) self.layer;
    layer.amountOfNumbers = amountOfNumbers;
    [layer setNeedsDisplay];
}

@end
