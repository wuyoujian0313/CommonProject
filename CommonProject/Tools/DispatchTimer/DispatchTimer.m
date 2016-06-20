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

+ (DispatchTimer *)sharedDispatchTimer {
    
    static DispatchTimer *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void)dealloc {
    [self invalidate];
}

- (void)createDispatchTimerInterval:(NSUInteger)interval delegate:(id <DispatchTimerDelegate>)delegate repeats:(BOOL)yesOrNo {
    
    self.delegate = delegate;
    
    if (yesOrNo) {
        // 获得队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(interval * NSEC_PER_SEC));
        uint64_t dur = (uint64_t)(interval * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, dur, 0);
        
        // 设置回调
        __weak DispatchTimer *wTimer = self;
        dispatch_source_set_event_handler(self.timer,^{
            
            //执行事件
            DispatchTimer *sTimer = wTimer;
            if (sTimer.delegate && [sTimer.delegate respondsToSelector:@selector(dispatchTimerTask)]) {
                [sTimer.delegate dispatchTimerTask];
            }
            
        });
        
        // 启动定时器
        dispatch_resume(self.timer);
    } else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC);
        
        // 设置回调
        __weak DispatchTimer *wTimer = self;
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            
            //执行事件
            DispatchTimer *sTimer = wTimer;
            if (sTimer.delegate && [sTimer.delegate respondsToSelector:@selector(dispatchTimerTask)]) {
                [sTimer.delegate dispatchTimerTask];
            }
            
        });
    }
}


- (void)createDispatchTimerInterval:(NSUInteger)interval block:(DispatchTimerBlock)timerBlock repeats:(BOOL)yesOrNo {
    
    if (yesOrNo) {
        // 获得队列
        dispatch_queue_t queue = dispatch_get_main_queue();
        self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC));
        uint64_t dur = (uint64_t)(interval * NSEC_PER_SEC);
        dispatch_source_set_timer(self.timer, start, dur, 0);
        
        // 设置回调
        dispatch_source_set_event_handler(self.timer, timerBlock);
        
        // 启动定时器
        dispatch_resume(self.timer);
    } else {
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, interval * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), timerBlock);
    }
}

- (void)invalidate {
    if (self.timer) {
        dispatch_cancel(self.timer);
        self.timer = nil;
    }
}

@end
