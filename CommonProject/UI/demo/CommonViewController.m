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
#import "CycleBannerView.h"
#import "SignatureViewController.h"
#import "AIBaseFramework.h"
#import "AppDelegate.h"
#import "GridViewController.h"
#import "GetPhoneCodeViewController.h"
#import "CaptureViewController.h"

#import "AIActionSheet.h"

@interface CommonViewController ()<UITableViewDataSource,UITableViewDelegate,UIActionSheetDelegate,AIActionSheetDelegate>
@property (nonatomic, strong) UITableView           *abilityTableView;
@property (nonatomic, strong) NSArray               *abilitys;
@end

@implementation CommonViewController

- (void)dealloc {
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavTitle:self.tabBarItem.title];
    [self configAbilitys];
    
    //
    UITableView * tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo  navigationBarHeight] - 49) style:UITableViewStylePlain];
    [self setAbilityTableView:tableView];
    [tableView setDelegate:self];
    [tableView setDataSource:self];
    [tableView setBackgroundColor:[UIColor colorWithHex:0xebeef0]];
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [self.view addSubview:tableView];
    
    [self setTableViewHeaderView:80];
    [self setTableViewFooterView:0];
}

-(void)setTableViewHeaderView:(NSInteger)height {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _abilityTableView.frame.size.width, height)];
    view.backgroundColor = [UIColor clearColor];
    
    CycleBannerView *banner = [[CycleBannerView alloc] initWithFrame:view.bounds];
    [view addSubview:banner];
    
    
    NSArray *images = @[@"http://pic22.nipic.com/20120717/9774499_115645635000_2.jpg",
                        @"http://pic4.nipic.com/20090919/3372381_123043464790_2.jpg",
                        @"http://www.9doo.net/__demo/jd0024/upload/b1.jpg",
                        @"http://pic.58pic.com/58pic/13/18/50/23K58PIC38v_1024.jpg",
                        @"http://pic2.ooopic.com/10/57/50/93b1OOOPIC4d.jpg"];
    [banner reloadData:images];
    [banner setPageControlPos:PageControlPositionRight];
    [banner autoScroll];
    
    
    [_abilityTableView setTableHeaderView:view];
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
                      @{@"name":@"手写签名",@"type":@"JumpToPage",@"Class":@"SignatureViewController"},
                      @{@"name":@"九宫格",@"type":@"JumpToPage",@"Class":@"GridViewController"},
                      @{@"name":@"验证码",@"type":@"JumpToPage",@"Class":@"GetPhoneCodeViewController"},
                      @{@"name":@"自定义拍照",@"type":@"JumpToPage",@"Class":@"CaptureViewController"},
                      @{@"name":@"自定义SheetView",@"type":@"sheetView"},
                      @{@"name":@"注销",@"type":@"relogin"},
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
    } else if ([type isEqualToString:@"relogin"]) {
        
        
        UIActionSheet *sheet=[[UIActionSheet alloc] initWithTitle:@"确认退出登录？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"退出登录" otherButtonTitles:nil];
        [sheet showInView:self.view];
    } else if ([type isEqualToString:@"sheetView"]) {
        
        AIActionSheet *sheet = [[AIActionSheet alloc] initInParentView:self.tabBarController.view delegate:self];
        for (int i = 0; i < 1; i ++) {
            AISheetItem * item = [[AISheetItem alloc] init];
            item.icon = @"capture.png";
            item.title = [NSString stringWithFormat:@"测试测-%d",i];
            [sheet addActionItem:item];
        }
        [sheet show];
    }
}

#pragma mark - 
- (void)didSelectedActionSheet:(AIActionSheet*)actionSheet buttonIndex:(NSInteger)buttonIndex {
    [FadePromptView showPromptStatus:[NSString stringWithFormat:@"选择菜单：%ld",(long)(buttonIndex)] duration:1.5 finishBlock:^{
        //
    }];
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

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == actionSheet.destructiveButtonIndex) {
        
        AppDelegate *app = [AppDelegate shareMyApplication];
        [app.mainVC switchToLoginVC];
    }
}


@end
