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
#import "SharedManager.h"
#import "SharedDataModel.h"
#import "MailSMSController.h"

#import "CommonWebViewController.h"

@interface LoginVC ()
@property (nonatomic, strong)LocalAbilityManager *obj;
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
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
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 180, 100, 100)];
    imageView.image = [UIImage generateQRCode:@"北京！！1234%%%===" width:100 height:100];
    [self.view addSubview:imageView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 200, 100)];
    imageView1.image = [UIImage generateBarCode:@"12345679012345" width:200 height:100];
    [self.view addSubview:imageView1];
    
}

- (void)buttonAction:(UIButton *)sender {
    
    AppDelegate *app = [AppDelegate shareMyApplication];
    [app.mainVC switchToHomeVC];
    
//    CommonWebViewController *vc = [[CommonWebViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
    
//    LocalAbilityManager *obj =  [[LocalAbilityManager alloc] init];
//    self.obj = obj;
//    [LocalAbilityManager telephoneToNumber:@"18600746313"];
    
//    SharedManager *obj = [[SharedManager alloc] init];
//    
//    SharedDataModel *mObj = [[SharedDataModel alloc] init];
//    mObj.title = @"title";
//    mObj.content = @"content";
//    mObj.data = @"www.baidu.com";
//
//    [obj sharedDataFromViewController:self withData:mObj finish:^(SharedStatusCode statusCode) {
//        //
//        [FadePromptView showPromptStatus:@"success" duration:2.0 finishBlock:nil];
//    }];
 
//    // 建议这么使用
//    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
//    self.obj = obj;
//    [obj pickerCameraController:self type:LocalAbilityTypePickerImage finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
//        //
//        if (status == ImagePickerStatusSuccess) {
//            [FadePromptView showPromptStatus:@"success" duration:2.0 finishBlock:nil];
//        }
//        
//    }];
    
//    LocalAbilityManager *sharedObj = [LocalAbilityManager sharedLocalAbilityManager];
//    [sharedObj pickerMailSMSController:self type:LocalAbilityTypeSMS andSubject:nil andContent:@"wuyoujian测试" finish:^(SendType type, SendStatus status) {
//        //
//        [FadePromptView showPromptStatus:@"success" duration:2.0 finishBlock:nil];
//    }];
    
//    MailSMSController *obj = [MailSMSController  sharedMailSMSController];
//    [obj pickerMessageComposeViewController:self andContent:@"wuyoujian" finish:^(SendType type, SendStatus status){
//        //
//        [FadePromptView showPromptStatus:@"success" duration:2.0 finishBlock:nil];
//    }];
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
