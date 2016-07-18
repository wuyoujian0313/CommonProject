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
    ImagePickerStatusCancel,
};

typedef NS_ENUM(NSInteger, ImagePickerType) {
    ImagePickerTypeImage,
    ImagePickerTypePhotograph,
    ImagePickerTypeVideotape,
    ImagePickerTypeScanQRCode,
};

// 注意！！！！！
// type==ImagePickerTypeVideotape,data是video的URL
typedef void(^ImagePickerFinishBlock)(ImagePickerType type, ImagePickerStatus status, id data);

@interface ImagePickerController : NSObject

// 建议不用单例，建议把ImagePickerController作为类一个strong成员变量
// 可以跟随使用的页面对象释放而释放
+ (ImagePickerController *)sharedImagePickerController;

// 拍照和选择图片是否支持编辑
@property (nonatomic, assign) BOOL allowsEditing;

/**
 *  照片选择
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerImageController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

/**
 *  调用摄像头拍照
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerPhotographController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

/**
 *  调用摄像头录像
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerVideotapeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

/**
 *  二维码识别
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerQRCodeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock;

@end
