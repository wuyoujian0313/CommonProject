//
//  CycleBannerView.m
//  insurancecomponent
//
//  Created by wuyj on 16/2/27.
//  Copyright © 2016年 wuyj. All rights reserved.
//

#import "CycleBannerView.h"
#import "WYJDispatchTimer.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

@interface CycleBannerView ()<UIScrollViewDelegate,WYJDispatchTimerDelegate>
@property(nonatomic, strong) UIScrollView                   *scrollView;
@property(nonatomic, strong) UIPageControl                  *pageControl;
@property(nonatomic, strong) WYJDispatchTimer               *timer;
@property(nonatomic, assign) NSInteger                      currentPageIndex;

@property(nonatomic, strong) NSMutableArray                 *pageViews;
@property(nonatomic, strong) NSMutableArray                 *imageArray;
@end

@implementation CycleBannerView

- (void)dealloc {
    [self stopScroll];
}

- (void)stopScroll {
    [self.timer releaseDispatchTimer];
    self.timer = nil;
}

- (void)autoScroll {
    
    self.timer = [WYJDispatchTimer createDispatchTimerInterval:_interval delegate:self];
    [self.timer startDispatchTimer];
}

- (void)autoJumpPage {
    NSUInteger number = _pageControl.numberOfPages;
    if (_pageControl.currentPage >= number - 1) {
        _pageControl.currentPage = 0;
    } else {
        _pageControl.currentPage ++ ;
    }
    
    [self scrollToIndex:_pageControl.currentPage animated:YES];
}

- (void)reloadData:(NSArray<NSString*> *)imageURLs {
    
    for (UIImageView *imageView in _pageViews) {
        [imageView removeFromSuperview];
    }
    
    [_scrollView setContentOffset:CGPointZero];
    [_scrollView setContentSize:CGSizeZero];
    [_pageViews removeAllObjects];
    [_imageArray removeAllObjects];
    
    [_imageArray addObjectsFromArray:imageURLs];
    [_imageArray insertObject:[imageURLs lastObject] atIndex:0];
    [_imageArray addObject:[imageURLs firstObject]];
    
    
    NSInteger pageCount = [_imageArray count];
    _pageControl.numberOfPages = pageCount - 2;
    _pageControl.currentPage = 0;
    [self setPageControlPos:_pageControlPos];
    
    
    NSInteger index = 0;
    for (NSString *imageURLString in _imageArray) {
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width*index, 0,self.bounds.size.width, self.bounds.size.height)];
        imageView.tag = index;
        
        imageView.userInteractionEnabled = YES;
        
        //取图片缓存
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        UIImage * cacheimage = [imageCache imageFromDiskCacheForKey:imageURLString];
        
        if (cacheimage == nil) {
            
            __weak UIImageView *wImageView = imageView;
            cacheimage = [UIImage imageFromColor:[UIColor whiteColor]];
            [imageView  sd_setImageWithURL:[NSURL URLWithString:imageURLString] placeholderImage:cacheimage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                
                UIImageView *sImageView = wImageView;
                if (image) {
                    sImageView.image = image;
                    [[SDImageCache sharedImageCache] storeImage:image forKey:imageURLString];
                }
            }];
        } else {
            imageView.image = cacheimage;
        }
        
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imagePressed:)];
        
        [tap setNumberOfTapsRequired:1];
        [tap setNumberOfTouchesRequired:1];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
        
        index ++;
        [_pageViews addObject:imageView];
    }
    
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    [_scrollView setContentSize:CGSizeMake(self.bounds.size.width * pageCount, 0)];
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ((self=[super initWithFrame:frame])) {
        self.pageViews = [[NSMutableArray alloc] init];
        self.imageArray = [[NSMutableArray alloc] init];
        self.pageControlPos = PageControlPositionCenter;
        self.interval = 3.0;
        
        self.scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        
        [self addSubview:_scrollView];
        
        
        self.pageControl = [[UIPageControl alloc] init];
        _pageControl.pageIndicatorTintColor = [UIColor grayColor];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        
        [self addSubview:_pageControl];
    }
    
    return self;
}

- (void)setPageControlPos:(PageControlPosition)pageControlPos {
    
    _pageControlPos = pageControlPos;
    
    CGFloat left = 10;
    CGFloat pageSize = 5*_pageControl.numberOfPages + 10 * _pageControl.numberOfPages;
    if (_pageControlPos == PageControlPositionCenter) {
        left = (self.frame.size.width -  pageSize)/2.0;
    } else if (_pageControlPos == PageControlPositionLeft) {
        left = 10;
    } else if (_pageControlPos == PageControlPositionRight) {
        left = self.frame.size.width - pageSize - 10;
    }
    _pageControl.frame = CGRectMake(left, self.frame.size.height - 15, pageSize, 10);
}


- (void)imagePressed:(UITapGestureRecognizer *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectedBannerIndex:)]) {
        [_delegate didSelectedBannerIndex:sender.view.tag- 1];
    }
}


- (void)scrollToIndex:(NSInteger)index animated:(BOOL)animated {
    _pageControl.currentPage = index;
    [_scrollView setContentOffset:CGPointMake(self.bounds.size.width*(index + 1), 0) animated:animated];
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)sender {
    CGFloat pageWidth = sender.frame.size.width;
    NSInteger page = floor((sender.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    _currentPageIndex = page;
    _pageControl.currentPage = (page-1);
}


- (void)scrollViewDidEndDecelerating:(UIScrollView *)sender {
    if (_currentPageIndex == 0) {
        
        [sender setContentOffset:CGPointMake(([_imageArray count]-2)*self.bounds.size.width, 0)];
    } else if (_currentPageIndex == ([_imageArray count]-1)) {
        
        [sender setContentOffset:CGPointMake(self.bounds.size.width, 0)];
    }
}

#pragma mark - WYJDispatchTimerDelegate
- (void)timerTask {
    [self autoJumpPage];
}


@end
