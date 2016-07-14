//
//  GridMenuCell.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/11.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>


extern NSString *const kGridMenuCellIdentifier;

@interface GridMenuItem : NSObject

@property (nonatomic, copy) NSString        *title;
@property (nonatomic, strong) UIColor       *titleColor;
@property (nonatomic, strong) UIFont        *titleFont;

// 本地ICON & 远程ICON, 注意！！！
// 1、若是远程ICON，icon是icon的url，以http或者https开头的字符串
// 2、若是本地ICON，icon是icon的name
@property (nonatomic, copy) NSString        *icon;
@property (nonatomic, assign) CGSize        iconSize;
@end

@interface GridMenuCell : UICollectionViewCell

@property(nonatomic,copy) NSIndexPath               *indexPath;

- (void)setGridMenu:(GridMenuItem*)menu;

@end
