//
//  SignatureViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/16.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "SignatureViewController.h"
#import "SignatureView.h"
#import "AIBaseFramework.h"

@implementation SignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"手写签名"];

    SignatureView *signView = [[SignatureView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight])];
    
    [self.view addSubview:signView];
}

@end
