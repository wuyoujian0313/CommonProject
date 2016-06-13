//
//  SecurityViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "SecurityViewController.h"
#import "NSData+Crypto.h"
#import "ZipArchiveEx.h"

@interface SecurityViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView           *abilityTableView;
@property (nonatomic, strong) NSArray               *abilitys;
@end

@implementation SecurityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"安全相关"];
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
    self.abilitys = @[@{@"name":@"DES加密\"长沙亚信\"",@"type":@"ShowAlert"},
                      @{@"name":@"AES加密\"长沙亚信\"",@"type":@"ShowAlert"},
                      @{@"name":@"Zip文件",@"type":@"ShowAlert"},
                      @{@"name":@"unZip文件",@"type":@"ShowAlert"},
                      @{@"name":@"Sqlite加密",@"type":@"ShowAlert"},
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
    if ([type isEqualToString:@"ShowAlert"]) {
        NSString *name = config[@"name"];
        
        if ([name hasPrefix:@"DES"] || [name hasPrefix:@"AES"]) {
            
            //
            NSString *srcString = @"长沙亚信";
            NSData *d = [srcString dataUsingEncoding:NSUTF8StringEncoding];
            NSData *desData = nil;
            NSData *decData = nil;
            if ([name hasPrefix:@"DES"]) {

                desData = [d DESEncryptedDataWithKey:@"ai" error:nil];
                decData = [desData decryptedDESDataWithKey:@"ai" error:nil];
            } else {
                desData = [d AES128EncryptedDataWithKey:@"ai" error:nil];
                decData = [desData decryptedAES128DataWithKey:@"ai" error:nil];
            }
           
            NSString *base64 = [desData base64EncodeString];
            
            
            UIAlertAction *aAction = [UIAlertAction actionWithTitle:@"解密" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //
                }];
                //
                
                NSString *decString = [[NSString alloc] initWithData:decData encoding:NSUTF8StringEncoding];
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"解密结果" message:decString preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:aAction2];
                [self presentViewController:alertController animated:YES completion:nil];
            }];
            
            UIAlertAction *aAction1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                //
            }];
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"加密结果" message:base64 preferredStyle:UIAlertControllerStyleAlert];
            [alertController addAction:aAction1];
            [alertController addAction:aAction];
            [self presentViewController:alertController animated:YES completion:nil];

        } else if ([name hasPrefix:@"Zip"]) {
            
        } else if ([name hasPrefix:@"unZip"]) {
            
        } else if ([name hasPrefix:@"Sqlite"]) {
            
        }
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
