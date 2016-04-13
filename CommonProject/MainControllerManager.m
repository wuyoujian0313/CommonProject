//
//  MainControllerManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/4/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "MainControllerManager.h"
#import "LoginVC.h"
#import "HomeVC.h"

@interface MainControllerManager ()
@property (nonatomic, strong) UIViewController              *rootVC;
@property (nonatomic, strong) WYJNavigationController       *loginNav;
@property (nonatomic, strong) WYJNavigationController       *homeNav;

@property (nonatomic, strong) WYJNavigationController       *currentNav;
@end

@implementation MainControllerManager

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupRootVC];
    [self switchToLoginVCFrom:_rootVC];
}

- (nullable UIViewController *)childViewControllerForStatusBarHidden {
    return [_currentNav topViewController];
}

- (nullable UIViewController *)childViewControllerForStatusBarStyle {
    return [_currentNav topViewController];;
}

- (void)switchToHomeVC {
    [self switchToHomeVCFrom:_loginNav];
}

- (void)switchToLoginVC {
    [self switchToLoginVCFrom:_homeNav];
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
    [self setupHomeController];
    
    [self transitionFromViewController:fromVC toViewController:_homeNav duration:1.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        //
        [_currentNav removeFromParentViewController];
        self.currentNav = _homeNav;
        
        [_currentNav didMoveToParentViewController:self];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)switchToLoginVCFrom:(UIViewController*)fromVC {
    [self setupLoginVC];
    
    [self transitionFromViewController:fromVC toViewController:_loginNav duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight animations:^{
        //
        [_currentNav removeFromParentViewController];
        self.currentNav = _loginNav;
        
        [_currentNav didMoveToParentViewController:self];
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)setupLoginVC {
    LoginVC *controller = [[LoginVC alloc] init];
    WYJNavigationController *loginNav = [[WYJNavigationController alloc] initWithRootViewController:controller];
    self.loginNav = loginNav;
    [self addChildViewController:_loginNav];
    [self.view addSubview:_loginNav.view];
}

- (void)setupHomeController {
    
    HomeVC *controller = [[HomeVC alloc] init];
    WYJNavigationController *homeNav = [[WYJNavigationController alloc] initWithRootViewController:controller];
    self.homeNav = homeNav;
    [self addChildViewController:_homeNav];
    [self.view addSubview:_homeNav.view];
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
