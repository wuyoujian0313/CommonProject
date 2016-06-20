//
//  MainControllerManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/4/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "MainControllerManager.h"
#import "LoginVC.h"
//#import "HomeVC.h"
#import "HomeTabBarController.h"

@interface MainControllerManager ()
@property (nonatomic, strong) UIViewController              *rootVC;
@property (nonatomic, strong) UIViewController              *currentController;
@end

@implementation MainControllerManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupRootVC];
    [self switchToLoginVCFrom:_rootVC];
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return _currentController;
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return _currentController;
}

- (void)switchToHomeVC {
    [self switchToHomeVCFrom:_currentController];
}

- (void)switchToLoginVC {
    [self switchToLoginVCFrom:_currentController];
}

// 创建一个空白的rootVC用于页面切换
- (void)setupRootVC {
    UIViewController *rootVC = [[UIViewController alloc] init];
    rootVC.view.backgroundColor = [UIColor whiteColor];
    self.rootVC = rootVC;
    [self addChildViewController:_rootVC];
    [_rootVC didMoveToParentViewController:self];
}


- (void)switchToHomeVCFrom:(UIViewController*)fromVC {
    
    UIViewController *homeVC = [self setupHomeController];
    [self transitionFromViewController:fromVC toViewController:homeVC duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        //
        [fromVC removeFromParentViewController];
        self.currentController = homeVC;
        
        [_currentController didMoveToParentViewController:self];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)switchToLoginVCFrom:(UIViewController*)fromVC {
    UIViewController *loginVC =  [self setupLoginVC];
    
    [self transitionFromViewController:fromVC toViewController:loginVC duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        //
        [fromVC removeFromParentViewController];
        self.currentController = loginVC;
        
        [_currentController didMoveToParentViewController:self];
    } completion:^(BOOL finished) {
        //
    }];
}

- (UIViewController *)setupLoginVC {
    LoginVC *controller = [[LoginVC alloc] init];
    WYJNavigationController *loginNav = [[WYJNavigationController alloc] initWithRootViewController:controller];
    [self addChildViewController:loginNav];
    [self.view addSubview:loginNav.view];
    
    return loginNav;
}

- (UIViewController *)setupHomeController {
    
    HomeTabBarController *controller = [[HomeTabBarController alloc] init];
    [self addChildViewController:controller];
    [self.view addSubview:controller.view];
    
    return controller;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
