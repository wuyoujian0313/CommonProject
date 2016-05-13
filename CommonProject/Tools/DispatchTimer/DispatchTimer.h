//
//  DispatchTimer.h
//  WYJDemoSets
//
//  Created by wuyj on 16/2/18.
//  Copyright © 2016年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol DispatchTimerDelegate <NSObject>
- (void)timerTask;
@end

typedef void (^timerBlock)(void);

/*
 
 */
@interface DispatchTimer : NSObject

// 采用代理的方式,建议采用这种方式
+ (DispatchTimer *)createDispatchTimerInterval:(NSUInteger)interval delegate:(id <DispatchTimerDelegate>)delegate;

/* 采用block 的方式，一定要注意block retain self的问题
 
 类似这样使用：
 __weak CycleScrollView *wself = self;
 self.timer = [DispatchTimer createDispatchTimerInterval:_interval block:^{
 CycleScrollView *sself = wself;
 
 [sself autoJumpPage];
 }];
 [self.timer startDispatchTimer];
 
 */

+ (DispatchTimer *)createDispatchTimerInterval:(NSUInteger)interval block:(timerBlock)timerBlock;

// 启动定时器
- (void)startDispatchTimer;

// 挂起定时器，暂停
- (void)suspendDispatchTimer;

// 释放定时器
- (void)stopDispatchTimer;

@end
