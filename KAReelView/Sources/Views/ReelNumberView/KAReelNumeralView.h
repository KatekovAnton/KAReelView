//
//  KAReelNumeralView.h
//  KAReelView
//
//  Created by Katekov Anton on 9/7/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KAReelDirection.h"



/** A view with single reeling numeral. **/

/*
 TODO:
 possible improvement here:
 1. add IB_DESIGNABLE and IBInspectable to allow to setup
 its properties directly from Interface Builder
 2. add animation time as parameter or as view property
 3. add animation curve as parameter or as view property
 */

@interface KAReelNumeralView : UIView

@property (nonatomic) UIFont *font;
@property (nonatomic) UIColor *textColor;
@property (nonatomic) int amountOfNumbers;
@property (nonatomic) int number;


- (void)setNumber:(int)number direction:(KAReelDirection)direction;
- (void)abortAnimation;

@end
