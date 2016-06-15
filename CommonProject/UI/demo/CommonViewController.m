//
//  CommonViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/7.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "CommonViewController.h"
#import "WebCacheViewController.h"
#import "SecurityViewController.h"
#import "Reachability.h"
#import "DataManageViewController.h"

@interface CommonViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView           *abilityTableView;
@property (nonatomic, strong) NSArray               *abilitys;
@end

@implementation CommonViewController

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
    self.abilitys = @[@{@"name":@"安全相关",@"type":@"JumpToPage",@"Class":@"SecurityViewController"},
                      @{@"name":@"数据处理",@"type":@"JumpToPage",@"Class":@"DataManageViewController"},
                      @{@"name":@"设备信息",@"type":@"AlertView"},
                      @{@"name":@"WebView缓存",@"type":@"JumpToPage",@"Class":@"WebCacheViewController"},
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
    if ([type isEqualToString:@"JumpToPage"]) {
        NSString *className = config[@"Class"];
        Class pageClass = NSClassFromString(className);
        BaseVC *obj = [[pageClass alloc] init];
        
        obj.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:obj animated:YES];
        
    } else if ([type isEqualToString:@"AlertView"]) {
        
        NSMutableString *msg = [[NSMutableString alloc] initWithCapacity:0];
        
        [msg appendFormat:@"设备版本名称：%@\n",[DeviceInfo platform]];
        [msg appendFormat:@"设备名称：%@\n",[DeviceInfo returnDeviceName]];
        [msg appendFormat:@"是否越狱：%@\n",[DeviceInfo isJailBreak]?@"YES":@"NO"];
        [msg appendFormat:@"设备IP：%@\n",[DeviceInfo getIPAddress:YES]];
        [msg appendFormat:@"设备是否连网：%@\n",[[Reachability reachabilityForInternetConnection] isReachable]? @"YES":@"NO"];
        [msg appendFormat:@"系统版本号：%@\n",[DeviceInfo getSystemVersion]];
        [msg appendFormat:@"系统日期：%ld\n",[DeviceInfo getSystemTime]];
        [msg appendFormat:@"屏幕尺寸：%ldx%ld\n",(NSInteger)[DeviceInfo getDeviceScreenSize].width,(NSInteger)[DeviceInfo getDeviceScreenSize].height];
        [msg appendFormat:@"APP版本号：%@\n",[DeviceInfo getSoftVersion]];
        
        UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        //
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"设备信息" message:msg preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:aAction];
        [self presentViewController:alertController animated:YES completion:nil];
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
