//
//  GetPhoneCodeViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/23.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "GetPhoneCodeViewController.h"
#import "CaptchaControl.h"

@interface GetPhoneCodeViewController ()

@end

@implementation GetPhoneCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    CaptchaControl *codeCtrl = [[CaptchaControl alloc] initWithFrame:CGRectMake(40, 100, 80, 30) interval:10];
    
    [codeCtrl addTarget:self action:@selector(getCode:) forControlEvents:UIControlEventTouchUpInside];
    
    [codeCtrl setBackgroundColor:[UIColor lightGrayColor]];
    [self.view addSubview:codeCtrl];
}

- (void)getCode:(CaptchaControl*)sender {
    [sender start];
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
