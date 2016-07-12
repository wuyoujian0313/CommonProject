//
//  GridMenuView.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/11.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol GridMenuViewDelegate <NSObject>
- (void)didSelectGridMenuIndex:(NSInteger)index;
@end

@class GridMenuItem;
@interface GridMenuView : UIView

@property (nonatomic, weak) id <GridMenuViewDelegate> delegate;

- (void)appendingMenusData:(NSArray<GridMenuItem*> *)menus;
- (void)reloadGridView;

// 设置一行count列，列宽为:屏幕宽度/count。默认count为3;
- (void)setColumnCount:(NSUInteger)count;



@end



@interface GridMenuItem : NSObject

@property (nonatomic, copy) NSString        *title;
@property (nonatomic, strong) UIColor       *titleColor;
@property (nonatomic, strong) NSString      *titleFont;

// 本地ICON & 远程ICON, 注意！！！
// 1、若是远程ICON，icon是icon的url，以http或者https开头的字符串
// 2、若是本地ICON，icon是icon的name
@property (nonatomic, copy) NSString        *icon;
@property (nonatomic, assign) CGSize        *iconSize;
@end