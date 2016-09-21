//
//  KAReelNumberView.h
//  KAReelView
//
//  Created by Katekov Anton on 9/7/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAReelDirection.h"



@class KAReelNumeralView;



/** A view with multiple reeling digits. **/

IB_DESIGNABLE
@interface KAReelNumberView : UIView

@property (nonatomic) IBInspectable UIFont *font; // IBInspectable doesn't support UIFont type
@property (nonatomic) IBInspectable UIColor *textColor;
@property (nonatomic) IBInspectable NSUInteger numberOfDigits;
@property (nonatomic) IBInspectable NSUInteger number;

- (void)setNumber:(NSUInteger)number animated:(BOOL)animated;
- (void)setNumber:(NSUInteger)number direction:(KAReelDirection)direction;

- (KAReelNumeralView*)numeralViewAtIndex:(NSUInteger)index;
- (NSUInteger)maximum;

@end
