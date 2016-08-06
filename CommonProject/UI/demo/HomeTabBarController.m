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
#import "ExtendScriptPlugin.h"
#import "AIBaseFramework.h"
#import "SignatureViewController.h"



@interface HomeTabBarController ()<UIWebViewDelegate>

@property (nonatomic, strong) WebViewKitController *webVC;
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
    webVC.delegate = self;
    self.webVC = webVC;
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
 
#if 1
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"html"];
#else
    NSURL *url = [NSURL URLWithString:@"http://10.143.186.178:8080/ipersonserv/"];
#endif
    [webVC loadWebViewForURL:url];
    [webVC setNavTitle:@"H5能力"];
    
    __weak WebViewKitController *wSelf = webVC;
    [webVC registerScriptPlugin:[[ExtendScriptPlugin alloc] init] callback:^(NSString *apiName, PluginCallbackStatus status, id response, id argument1,id argument2,...) {
        //
        //WebViewKitController *sSelf = wSelf;
        if ([apiName isEqualToString:@"JN_Signature:"]) {
            SignatureViewController *vc = [[SignatureViewController alloc] init];
            vc.orderNo = response;
            vc.hidesBottomBarWhenPushed = YES;
            [wSelf.navigationController pushViewController:vc animated:YES];
        } else {
            [FadePromptView showPromptStatus:apiName duration:1.0 finishBlock:^{
                //
                
            }];
        }
        
    }];
    
    [_webVC registerScriptPlugin:[[ScriptPluginBase alloc] init] callback:^(NSString *apiName, PluginCallbackStatus status, id response, id argument1,id argument2,...) {
        //
        if ([apiName isEqualToString:@"JN_PhotographAllowsEditing:argument:"]) {
            
            [FadePromptView showPromptStatus:apiName duration:1.0 finishBlock:^{
                //
            }];
            
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
