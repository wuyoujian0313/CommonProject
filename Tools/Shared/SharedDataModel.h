//
//  SharedDataModel.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,SharedDataType) {
    SharedDataTypeText,     // 文字分享
    SharedDataTypeImage,    // 图片分享
    SharedDataTypeURL,      // 网页分享
    SharedDataTypeMusic,    // 音乐分享
    SharedDataTypeVideo,    // 视频分享
};

@interface SharedDataModel : NSObject

@property (nonatomic, assign) SharedDataType dataType;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;//描述&文字内容
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *lowBandUrl;
@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) UIImage *thumbImage;


@end
