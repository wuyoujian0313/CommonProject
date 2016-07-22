//
//  HomeTabBarController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/7.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "HomeTabBarController.h"
#import "CommonWebViewController.h"
#import "CommonViewController.h"
#import "DeviceViewController.h"
#import "WebViewKitController.h"
#import "ExtendScriptPlugin.h"
#import "AIBaseFramework.h"



@interface HomeTabBarController ()

@end

@implementation HomeTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configViewControllers];
}

- (void)configViewControllers {
    

    [self.tabBar setBarTintColor:[UIColor lightTextColor]];
    [self.tabBar setTintColor:[UIColor colorWithHex:0x12b8f6]];

    WebViewKitController *webVC = [[WebViewKitController alloc] init];
    UITabBarItem *itemObj1 = [[UITabBarItem alloc] initWithTitle:@"H5能力"
                                                           image:[UIImage imageNamed:@"tabbar_circle"]
                                                   selectedImage:nil];
    itemObj1.tag = 0;
    [webVC setTabBarItem:itemObj1];
    
    CommonViewController *commonVC = [[CommonViewController alloc] init];
    UITabBarItem *itemObj2 = [[UITabBarItem alloc] initWithTitle:@"本地能力"
                                                           image:[UIImage imageNamed:@"tabbar_home"]
                                                   selectedImage:nil];
    itemObj2.tag = 1;
    [commonVC setTabBarItem:itemObj2];
    
    DeviceViewController *deviceVC = [[DeviceViewController alloc] init];
    UITabBarItem *itemObj3 = [[UITabBarItem alloc] initWithTitle:@"设备能力"
                                                           image:[UIImage imageNamed:@"tabbar_question"]
                                                   selectedImage:nil];
    itemObj3.tag = 2;
    [deviceVC setTabBarItem:itemObj3];
    
    AINavigationController *nav1 = [[AINavigationController alloc] initWithRootViewController:webVC];
    AINavigationController *nav2 = [[AINavigationController alloc] initWithRootViewController:commonVC];
    AINavigationController *nav3 = [[AINavigationController alloc] initWithRootViewController:deviceVC];

    [self setViewControllers:[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nil]];
    [self setSelectedIndex:0];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"html"];
    [webVC loadWebViewForURL:url];
    [webVC setNavTitle:@"H5能力"];
    [webVC registerScriptPlugin:[[ExtendScriptPlugin alloc] init] callback:^(NSString *apiName, PluginCallbackStatus status, id response) {
        //
        [FadePromptView showPromptStatus:apiName duration:1.0 finishBlock:^{
            //
        }];
    }];
    
    webVC.basePluginCallback = ^(NSString *apiName, PluginCallbackStatus status, id response) {
        [FadePromptView showPromptStatus:apiName duration:1.0 finishBlock:^{
            //
        }];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
