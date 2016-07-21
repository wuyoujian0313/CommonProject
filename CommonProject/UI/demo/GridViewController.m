//
//  GridViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/21.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "GridViewController.h"
#import "GridMenuView.h"
#import "DeviceInfo.h"
#import "FadePromptView.h"

@interface GridViewController ()<GridMenuViewDelegate>

@property (nonatomic, strong) GridMenuView *gridView;

@end

@implementation GridViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"九宫格"];
    
    self.gridView = [[GridMenuView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight])];
    [_gridView setDelegate:self];
    [_gridView setColumnCount:3];
    [_gridView setRowHeight:120];
    
    [self.view addSubview:_gridView];
    
    [_gridView appendingMenusData:[self gridData]];
}

- (NSArray *)gridData {
    
    GridMenuItem *item1 = [[GridMenuItem alloc] init];
    item1.icon = @"http://ico.58pic.com/iconset01/Doraemon-icons/gif/79802.gif";
    item1.title = @"菜单1";
    item1.iconSize = CGSizeMake(60, 60);
    item1.titleFont = [UIFont systemFontOfSize:14];
    item1.titleColor = [UIColor grayColor];
    
    GridMenuItem *item2 = [[GridMenuItem alloc] init];
    item2.icon = @"http://ico.58pic.com/iconset02/fast_icon_users/gif/13406.gif";
    item2.title = @"菜单2";
    item2.iconSize = CGSizeMake(60, 60);
    item2.titleFont = [UIFont systemFontOfSize:14];
    item2.titleColor = [UIColor grayColor];
    
    GridMenuItem *item3 = [[GridMenuItem alloc] init];
    item3.icon = @"http://ico.58pic.com/iconset01/Doraemon-icons/gif/79792.gif";
    item3.title = @"菜单3";
    item3.iconSize = CGSizeMake(60, 60);
    item3.titleFont = [UIFont systemFontOfSize:14];
    item3.titleColor = [UIColor grayColor];
    
    
    GridMenuItem *item4 = [[GridMenuItem alloc] init];
    item4.icon = @"http://ico.58pic.com/iconset01/valentine-love/gif/79055.gif";
    item4.title = @"菜单4";
    item4.iconSize = CGSizeMake(60, 60);
    item4.titleFont = [UIFont systemFontOfSize:14];
    item4.titleColor = [UIColor grayColor];
    
    GridMenuItem *item5 = [[GridMenuItem alloc] init];
    item5.icon = @"http://ico.58pic.com/iconset01/spring-icons/gif/135478.gif";
    item5.title = @"菜单5";
    item5.iconSize = CGSizeMake(60, 60);
    item5.titleFont = [UIFont systemFontOfSize:14];
    item5.titleColor = [UIColor grayColor];
    
    GridMenuItem *item6 = [[GridMenuItem alloc] init];
    item6.icon = @"http://ico.58pic.com/iconset01/the-noun-project-icons/gif/140597.gif";
    item6.title = @"菜单6";
    item6.iconSize = CGSizeMake(60, 60);
    item6.titleFont = [UIFont systemFontOfSize:14];
    item6.titleColor = [UIColor grayColor];
    
    GridMenuItem *item7 = [[GridMenuItem alloc] init];
    item7.icon = @"http://ico.58pic.com/iconset01/spring-icons/gif/135479.gif";
    item7.title = @"菜单7";
    item7.iconSize = CGSizeMake(60, 60);
    item7.titleFont = [UIFont systemFontOfSize:14];
    item7.titleColor = [UIColor grayColor];
    
    
    NSArray *menus = @[item1,item2,item3,item4,item5,item6,item7];
    return menus;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - GridMenuViewDelegate
- (void)didSelectGridMenuIndex:(NSInteger)index {
    [FadePromptView showPromptStatus:[NSString stringWithFormat:@"选择菜单：%ld",(long)(index+1)] duration:1.5 finishBlock:^{
        //
    }];
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
