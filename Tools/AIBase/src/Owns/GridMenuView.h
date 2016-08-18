//
//  GridMenuView.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/11.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GridMenuCell.h"


@protocol GridMenuViewDelegate <NSObject>
- (void)didSelectGridMenuIndex:(NSInteger)index;
@end

@interface GridMenuView : UIView

@property (nonatomic, weak) id <GridMenuViewDelegate> delegate;

- (void)appendingMenusData:(NSArray<GridMenuItem*> *)menus;
- (void)reloadGridView;

// 设置一行count列，列宽为:self.bounds.size.width/count
- (void)setColumnCount:(NSUInteger)count;
// 设置九宫格的行高
- (void)setRowHeight:(CGFloat)height;

@end
