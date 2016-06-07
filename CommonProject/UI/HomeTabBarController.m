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

    CommonWebViewController *webVC = [[CommonWebViewController alloc] init];
    UITabBarItem *itemObj1 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemFavorites tag:0];
    [webVC setTabBarItem:itemObj1];
    
    CommonViewController *commonVC = [[CommonViewController alloc] init];
    UITabBarItem *itemObj2 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemBookmarks tag:1];
    [commonVC setTabBarItem:itemObj2];
    
    DeviceViewController *deviceVC = [[DeviceViewController alloc] init];
    UITabBarItem *itemObj3 = [[UITabBarItem alloc] initWithTabBarSystemItem:UITabBarSystemItemRecents tag:2];
    [deviceVC setTabBarItem:itemObj3];
    
    WYJNavigationController *nav1 = [[WYJNavigationController alloc] initWithRootViewController:webVC];
    WYJNavigationController *nav2 = [[WYJNavigationController alloc] initWithRootViewController:commonVC];
    WYJNavigationController *nav3 = [[WYJNavigationController alloc] initWithRootViewController:deviceVC];

    [self setViewControllers:[[NSArray alloc] initWithObjects:nav1,nav2,nav3,nil]];
    [self setSelectedIndex:0];    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
