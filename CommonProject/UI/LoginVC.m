//
//  LoginVC.m
//  CommonProject
//
//  Created by wuyoujian on 16/4/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "LoginVC.h"
#import "ImagePickerController.h"
#import "LocalAbilityManager.h"

@interface LoginVC ()
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"登录"];
    
    UIButton *loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginBtn setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHex:0x56b5f5]] forState:UIControlStateNormal];
    [loginBtn.layer setCornerRadius:5.0];
    [loginBtn setTag:101];
    [loginBtn setClipsToBounds:YES];
    [loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [loginBtn.titleLabel setFont:[UIFont systemFontOfSize:18]];
    [loginBtn setFrame:CGRectMake(11, 120, self.view.frame.size.width - 22, 45)];
    [loginBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginBtn];
}

- (void)buttonAction:(UIButton *)sender {
    
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    [obj pickerCameraController:self type:LocalAbilityTypePickerQRCode finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
        //
        if (status == ImagePickerStatusSuccess) {
            [FadePromptView showPromptStatus:data duration:2.0 finishBlock:nil];
        }
    }];
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
