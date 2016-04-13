//
//  AppDelegate.h
//  CommonProject
//
//  Created by wuyoujian on 16/4/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainControllerManager.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) MainControllerManager    *mainVC;

+ (AppDelegate*)shareMyApplication;


@end

