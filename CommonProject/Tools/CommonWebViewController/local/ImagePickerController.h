//
//  ImagePickerController.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ImagePickerStatus) {
    
    ImagePickerStatusSuccess,
    ImagePickerStatusFail,
    ImagePickerTypeQRCancel,
};

typedef NS_ENUM(NSInteger, ImagePickerType) {
    
    ImagePickerTypeImage,
    ImagePickerTypeVideo,
    ImagePickerTypeQRCode,
};

typedef void(^ImagePickerFinishBlock)(ImagePickerType type, ImagePickerStatus status, id data);

@interface ImagePickerController : NSObject

/**
 *  照片选择
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerImageController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

/**
 *  调用摄像头
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerVideoController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

/**
 *  二维码识别
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerQRCodeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

@end
