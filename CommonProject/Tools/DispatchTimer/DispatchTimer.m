//
//  DispatchTimer.m
//  WYJDemoSets
//
//  Created by wuyj on 16/2/18.
//  Copyright © 2016年 wuyj. All rights reserved.
//

#import "DispatchTimer.h"

@interface DispatchTimer ()
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, weak) id<DispatchTimerDelegate> delegate;

@end

@implementation DispatchTimer

- (void)dealloc {
    [self stopDispatchTimer];
}

+ (DispatchTimer *)createDispatchTimerInterval:(NSUInteger)interval delegate:(id <DispatchTimerDelegate>)delegate {
    DispatchTimer *wyjTimer = [[[self class] alloc] init];
    wyjTimer.delegate = delegate;
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    wyjTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
    uint64_t dur = (uint64_t)(interval * NSEC_PER_SEC);
    dispatch_source_set_timer(wyjTimer.timer, start, dur, 0);
    
    // 设置回调
    __weak DispatchTimer *wTimer = wyjTimer;
    dispatch_source_set_event_handler(wyjTimer.timer,^{
    
        DispatchTimer *sTimer = wTimer;
        [sTimer.delegate timerTask];
    });
    
    return wyjTimer;
}


+ (DispatchTimer *)createDispatchTimerInterval:(NSUInteger)interval block:(timerBlock)timerBlock {
    
    DispatchTimer *wyjTimer = [[[self class] alloc] init];
    
    // 获得队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    wyjTimer.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
    uint64_t dur = (uint64_t)(interval * NSEC_PER_SEC);
    dispatch_source_set_timer(wyjTimer.timer, start, dur, 0);
    
    // 设置回调
    dispatch_source_set_event_handler(wyjTimer.timer, timerBlock);
    
    return wyjTimer;
}


- (void)startDispatchTimer {
    // 启动定时器
    dispatch_resume(self.timer);
}

- (void)suspendDispatchTimer {
    // 挂起定时器
    dispatch_suspend(self.timer);
}

- (void)stopDispatchTimer {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

@end
