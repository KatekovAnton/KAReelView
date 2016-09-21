//
//  KATimeIntervalView.h
//  KAReelView
//
//  Created by Katekov Anton on 9/8/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KAReelNumberView;



/** A view for presenting timeinterval. **/

IB_DESIGNABLE
@interface KATimeIntervalView : UIView {
    KAReelNumberView *_viewMinutes;
    KAReelNumberView *_viewSeconds;
    UILabel *_labelDot;
    
    NSTimeInterval _timeInterval;
}

@property (nonatomic) IBInspectable UIFont *font; // IBInspectable doesn't support UIFont type
@property (nonatomic) IBInspectable UIColor *textColor;

- (void)setTimeInterval:(NSTimeInterval)timeInterval animated:(BOOL)animated;

@end
