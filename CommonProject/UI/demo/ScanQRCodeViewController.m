//
//  ScanQRCodeViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ScanQRCodeViewController.h"
#import "LocalAbilityManager.h"
#import "UIImage+ResizeMagick.h"
#import "AIBaseFramework.h"

@interface ScanQRCodeViewController ()

@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;

@end

@implementation ScanQRCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavTitle:@"二维码&条形码"];
    
    UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [scanBtn setFrame:CGRectMake(20, 100, 60, 38)];
    [scanBtn setTag:100];
    [scanBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [scanBtn setTitle:@"扫描" forState:UIControlStateNormal];
    [scanBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:scanBtn];
    
    UIButton *regBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [regBtn setFrame:CGRectMake(120, 100, 60, 38)];
    [regBtn setTag:101];
    [regBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [regBtn setTitle:@"识别" forState:UIControlStateNormal];
    [regBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:regBtn];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 180, 100, 100)];
    imageView.image = [UIImage generateQRCode:@"ai-cs 1234%%%===" width:100 height:100];
    [self.view addSubview:imageView];
    
    
    UIImageView *imageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 300, 200, 100)];
    imageView1.image = [UIImage generateBarCode:@"12345679012345" width:200 height:100];
    [self.view addSubview:imageView1];
}

- (void)buttonAction:(UIButton*)sender {
    if (sender.tag == 100) {
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        self.localAbilityMgr = obj;
        [obj pickerCameraController:self type:LocalAbilityTypePickerScanQRCode finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            [FadePromptView showPromptStatus:data duration:2.0 finishBlock:^{
                //
            }];
        }];
        
    } else if (sender.tag == 101) {
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        self.localAbilityMgr = obj;
        [obj pickerCameraController:self type:LocalAbilityTypePickerImage_ForbidEditing finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (type == ImagePickerTypeImage) {
                UIImage *image = data;
                NSArray *results = [image recognitionQRCodeFromImage];
                
                NSString *msg = nil;
                if (results == nil || [results count] == 0) {
                    msg = @"未识别图片中的二维码，请重试！";
                } else {
                    msg = [results description];
                }
                [FadePromptView showPromptStatus:msg duration:2.0 finishBlock:nil];
            }
        }];
    }
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
