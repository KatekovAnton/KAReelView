//
//  ViewController.h
//  KAReelView
//
//  Created by Katekov Anton on 9/21/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <UIKit/UIKit.h>



@class KATimer;
@class KAReelNumberView;
@class KATimeIntervalView;



@interface ViewController : UIViewController {
    
    IBOutlet KAReelNumberView *_viewNumber;
    
    IBOutlet KATimeIntervalView *_viewCountdown;
    IBOutlet KATimeIntervalView *_viewStopwatch;
    
    KATimer *_timerCountdown;
    KATimer *_timerStopwatch;
    
}

@end

