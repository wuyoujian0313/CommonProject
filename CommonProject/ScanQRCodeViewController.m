//
//  ScanQRCodeViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "LocalAbilityManager.h"

@interface ScanQRCodeViewController ()

@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"二维码&条形码"];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake((self.view.frame.size.width - 60)/2.0, 100, 60, 38)];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [cancelBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(scanAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 180, 100, 100)];
    imageView.image = [UIImage generateQRCode:@"北京！！1234%%%===" width:100 height:100];
    [self.view addSubview:imageView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 200, 100)];
    imageView1.image = [UIImage generateBarCode:@"12345679012345" width:200 height:100];
    [self.view addSubview:imageView1];
}

- (void)scanAction:(UIButton*)sender {
    
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    [obj pickerCameraController:self type:LocalAbilityTypePickerScanQRCode finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
        //
        [FadePromptView showPromptStatus:data duration:2.0 finishBlock:^{
            //
        }];
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
