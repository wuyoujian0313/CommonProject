//
//  GridMenuView.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/11.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "GridMenuView.h"
#import "GridMenuCell.h"

@interface GridMenuView ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView          *mainMenuView;
@property (nonatomic, strong) NSMutableArray            *menuDatas;
@end

@implementation GridMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        
    }
    return self;
}

- (void)reloadGridView {
    
    [_mainMenuView reloadData];
}

- (void)appendingMenusData:(NSArray<GridMenuItem*> *)menus {
    
    if (!_menuDatas) {
        self.menuDatas = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    [_menuDatas addObjectsFromArray:menus];
    [_mainMenuView reloadData];
}

// 设置一行count列，列宽为:屏幕宽度/count。默认count为3;
- (void)setColumnCount:(NSUInteger)count {
    
}


#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 33;
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return nil;
}

//
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets top = {0,0,0,0};
    return top;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake([DeviceInfo screenWidth]/3.0,100);
}


//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

@end
