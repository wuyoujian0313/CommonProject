//
//  DeviceViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/7.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "DeviceViewController.h"
#import "BluetoothEngine.h"
#import "ScanQRCodeViewController.h"
#import "LocalAbilityManager.h"
#import "AIBaseFramework.h"

@interface DeviceViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView           *abilityTableView;
@property (nonatomic, strong) NSArray               *abilitys;

@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@end

@implementation DeviceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavTitle:self.tabBarItem.title];
    [self configAbilitys];
    
    //
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo  navigationBarHeight]) style:UITableViewStylePlain];
    [self setAbilityTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor colorWithHex:0xebeef0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:tableView];
    
    [self setTableViewFooterView:0];
}

-(void)setTableViewFooterView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _abilityTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    [_abilityTableView setTableFooterView:view];
}

- (void)configAbilitys {
    self.abilitys = @[
                      @{@"name":@"指纹",@"type":@"TouchID"},
                      @{@"name":@"拍照",@"type":@"Photograph"},
                      @{@"name":@"录像",@"type":@"Videotape"},
                      @{@"name":@"二维码&条形码",@"type":@"QRCode"},
                      @{@"name":@"蓝牙通信",@"type":@""},
                      @{@"name":@"iBeacon",@"type":@""},
                      ];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_abilitys count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSDictionary *config = [_abilitys objectAtIndex:indexPath.row];
    NSString *type = config[@"type"];
    if ([type isEqualToString:@"QRCode"]) {
        ScanQRCodeViewController *vc = [[ScanQRCodeViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([type isEqualToString:@"Photograph"]) {
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        self.localAbilityMgr = obj;
        [obj pickerCameraController:self type:LocalAbilityTypePickerPhotograph_AllowsEditing finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
        }];
    
    } else if ([type isEqualToString:@"Videotape"]) {
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        self.localAbilityMgr = obj;
        [obj pickerCameraController:self type:LocalAbilityTypePickerVideotape finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
        }];
    } else if ([type isEqualToString:@"TouchID"]) {
        
        [LocalAbilityManager touchIDPolicy:^(NSError *error) {
            //
            if (!error) {
                [FadePromptView showPromptStatus:@"指纹验证通过" duration:2.0 finishBlock:^{
                    //
                }];
            }
        }];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"CommonTableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        UIView *selBGView = [[UIView alloc] initWithFrame:cell.bounds];
        [selBGView setBackgroundColor:[UIColor colorWithHex:0xeeeeee]];
        cell.selectedBackgroundView = selBGView;
    }
    
    NSDictionary *config = [_abilitys objectAtIndex:indexPath.row];
    cell.textLabel.text = config[@"name"];
    
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
