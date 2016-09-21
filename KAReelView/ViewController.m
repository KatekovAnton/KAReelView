//
//  ViewController.m
//  KAReelView
//
//  Created by Katekov Anton on 9/21/16.
//  Copyright © 2016 katekovanton. All rights reserved.
//

#import "ViewController.h"
#import "KATimeIntervalView.h"
#import "KAReelNumeralView.h"
#import "KAReelNumberView.h"
#import "KATimer.h"



@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _viewNumber.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _viewCountdown.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    _viewStopwatch.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:16];
    
    __weak typeof (self) weakself = self;
    _timerCountdown = [[KATimer alloc] initWithDuration:600];
    _timerCountdown.tickHandler = ^void(KATimer* sender) {
        [weakself onCountdownTick];
    };
    [_timerCountdown start];
    
    _timerStopwatch = [[KATimer alloc] initWithDuration:600];
    _timerStopwatch.tickHandler = ^void(KATimer* sender) {
        [weakself onStopwatchTick];
    };
    [_timerStopwatch start];
    
    [_viewCountdown setTimeInterval:_timerCountdown.timeLeft animated:NO];
    [_viewStopwatch setTimeInterval:_timerStopwatch.timeSpent animated:NO];
}

- (void)onCountdownTick
{
    [_viewCountdown setTimeInterval:_timerCountdown.timeLeft animated:YES];
}

- (void)onStopwatchTick
{
    [_viewStopwatch setTimeInterval:_timerStopwatch.timeSpent animated:YES];
}

- (int)randomNumberWithMaximum:(int)maximum
{
    return rand() % maximum;
}

- (IBAction)onSetRndomNumber:(id)sender
{
    [_viewNumber setNumber:[self randomNumberWithMaximum:(int)_viewNumber.maximum] animated:YES];
}

@end
