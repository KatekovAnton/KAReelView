//
//  KATimer.m
//  KAReelView
//
//  Created by Katekov Anton on 9/8/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "KATimer.h"
#import <QuartzCore/QuartzCore.h>



@interface KATimer() {
    NSDate *_dateStart;
    
    NSTimeInterval _timeStart;
    NSTimeInterval _timeDuration;
    
    NSTimer *_timer;
}

@end



@implementation KATimer

- (id)initWithDuration:(NSTimeInterval)duration
{
    if (self = [super init]) {
        _timeDuration = duration;
    }
    return self;
}

- (NSTimeInterval)timeLeft
{
    return MAX(0, _timeDuration - [self timeSpent] + 1);
}

- (NSTimeInterval)timeSpent
{
    return CACurrentMediaTime() - _timeStart;
}

- (void)start
{
    [self stop];
    
    _timeStart = CACurrentMediaTime();
    _dateStart = [NSDate date];
    [self startNextTimer];
}

- (void)startNextTimer
{
    unsigned long secondsSpent = [self timeSpent];
    NSDate *fireDate = [NSDate dateWithTimeInterval:secondsSpent + 1 sinceDate:_dateStart];
    
    _timer = [[NSTimer alloc] initWithFireDate:fireDate
                                      interval:0
                                        target:self
                                      selector:@selector(onTimerTick:)
                                      userInfo:nil
                                       repeats:NO];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

- (void)onTimerTick:(NSTimer*)timer
{
    if (![self finished]) {
        [self startNextTimer];
    }
    else {
        [self stop];
    }
    
    if (self.tickHandler)
        self.tickHandler(self);
}

- (void)stop
{
    [_timer invalidate];
    _timer = nil;
}

- (BOOL)finished
{
    return [self timeSpent] > _timeDuration;
}

- (void)dealloc
{
    if (_timer)
        [self stop];
}

@end
