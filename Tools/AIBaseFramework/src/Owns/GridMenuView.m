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

@property (nonatomic, assign) NSUInteger                menuWidth;
@property (nonatomic, assign) NSUInteger                menuHeight;


@end

@implementation GridMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        //初始化
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        flowLayout.minimumInteritemSpacing = 0 ;
        flowLayout.minimumLineSpacing = 0;
        flowLayout.headerReferenceSize = CGSizeZero;
        flowLayout.footerReferenceSize = CGSizeZero;
        
        self.mainMenuView = [[UICollectionView alloc] initWithFrame:self.bounds     collectionViewLayout:flowLayout];
        // 注册
        [_mainMenuView registerClass:[GridMenuCell class] forCellWithReuseIdentifier:kGridMenuCellIdentifier];
        _mainMenuView.backgroundColor = [UIColor whiteColor];
        _mainMenuView.showsVerticalScrollIndicator = NO;
        _mainMenuView.showsHorizontalScrollIndicator = NO;
        _mainMenuView.delegate = self;
        _mainMenuView.dataSource = self;
        _mainMenuView.bounces = YES;
        _mainMenuView.scrollEnabled = NO;
        [self addSubview:_mainMenuView];
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

// 设置一行count列，列宽为:self.bounds.size.width/count
- (void)setColumnCount:(NSUInteger)count {

    self.menuWidth = (NSUInteger)self.bounds.size.width / count;
    [_mainMenuView reloadData];
}

// 设置九宫格的行高
- (void)setRowHeight:(CGFloat)height {
    
    self.menuHeight = height;
    [_mainMenuView reloadData];
}


#pragma mark - collectionView delegate
//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

//每个分区上的元素个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [_menuDatas count];
}

//设置元素内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    GridMenuCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kGridMenuCellIdentifier forIndexPath:indexPath];
    
    [cell sizeToFit];
    cell.indexPath = indexPath;
    [cell setGridMenu:[_menuDatas objectAtIndex:indexPath.row]];

    return cell;
}

//
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets top = {0,0,0,0};
    return top;
}

//设置元素大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(_menuWidth,_menuHeight);
}


//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectGridMenuIndex:)]) {
        [_delegate didSelectGridMenuIndex:indexPath.row];
    }
}

@end
