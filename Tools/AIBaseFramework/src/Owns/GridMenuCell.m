//
//  GridMenuCell.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/11.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "GridMenuCell.h"
#import "../SDWebImage/SDImageCache.h"
#import "../SDWebImage/UIImageView+WebCache.h"
#import "../Owns/LineView.h"


NSString *const kGridMenuCellIdentifier = @"kGridMenuCellIdentifier";

@implementation GridMenuItem
@end


@interface GridMenuCell ()

@property(nonatomic,strong) UIImageView         *iconImageView;
@property(nonatomic,strong) UILabel             *titleLabel;

@property(nonatomic,strong) LineView            *lineH;
@property(nonatomic,strong) LineView            *lineV;

@end

@implementation GridMenuCell


- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //
        self.iconImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _iconImageView.userInteractionEnabled = YES;
        _iconImageView.clipsToBounds = YES;
        [self.contentView addSubview:_iconImageView];
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        [_titleLabel setBackgroundColor:[UIColor clearColor]];
        [_titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_titleLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_titleLabel];
        
        
        self.lineH = [[LineView alloc] initWithFrame:CGRectMake(0, self.bounds.size.height - kLineHeight1px, self.bounds.size.width, kLineHeight1px)];
        [self.contentView addSubview:_lineH];
        
        self.lineV = [[LineView alloc] initWithFrame:CGRectMake(self.bounds.size.width - kLineHeight1px, 0, kLineHeight1px, self.bounds.size.height)];
        [self.contentView addSubview:_lineV];
    }
    return self;
}

- (void)setGridMenu:(GridMenuItem*)menu {
    
    [_titleLabel setText:menu.title];
    [_titleLabel setFont:menu.titleFont];
    [_titleLabel setTextColor:menu.titleColor];
    
    NSString *icon = menu.icon;
    if ([icon hasPrefix:@"http"]) {
        // 远程icon
        SDImageCache * imageCache = [SDImageCache sharedImageCache];
        NSString *imageUrl = menu.icon;
        UIImage *image = [imageCache imageFromDiskCacheForKey:imageUrl];
        
        if (image == nil) {
            image = [UIImage imageNamed:@"defaultMeHead"];
            
            [_iconImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]
                              placeholderImage:image
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                         if (image) {
                                             _iconImageView.image = image;
                                             [[SDImageCache sharedImageCache] storeImage:image forKey:imageUrl];
                                         }
                                     }
             ];
        } else {
            _iconImageView.image = image;
        }
    } else {
        // 本地icon
        [_iconImageView setImage:[UIImage imageNamed:menu.icon]];
    }
    
    CGSize size = menu.iconSize;
    CGFloat textHeight = menu.titleFont.pointSize;
    CGFloat h = size.height;
    h += 10;
    h += textHeight;
    
    CGFloat top = (self.bounds.size.height - h) / 2.0;
    CGFloat left = (self.bounds.size.width - size.width) / 2.0;
    [_iconImageView setFrame:CGRectMake(left, top, size.width, size.height)];
    
    [_titleLabel setFrame:CGRectMake(0, self.bounds.size.height - top - textHeight, self.bounds.size.width, textHeight)];
}

@end
