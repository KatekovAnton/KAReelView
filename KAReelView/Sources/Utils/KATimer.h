//
//  KATimer.h
//  KAReelView
//
//  Created by Katekov Anton on 9/8/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import <Foundation/Foundation.h>



@class KATimer;

typedef void (^KATimerTickHandler)(KATimer *sender);



@interface KATimer : NSObject

@property (nonatomic, readonly) NSTimeInterval timeLeft;
@property (nonatomic, readonly) NSTimeInterval timeSpent;
@property (nonatomic, copy) KATimerTickHandler tickHandler;

- (id)initWithDuration:(NSTimeInterval)duration;

- (BOOL)finished;
- (void)start;
- (void)stop;

@end
