//
//  LocalAbilityManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LocalAbilityModel.h"
#import "ImagePickerController.h"
#import "MailSMSController.h"

typedef NS_ENUM(NSInteger, LocalAbilityType) {
    LocalAbilityTypeMail = 0,
    LocalAbilityTypeSMS,
    LocalAbilityTypeDail,
    LocalAbilityTypePickerImage_AllowsEditing,
    LocalAbilityTypePickerPhotograph_AllowsEditing,
    LocalAbilityTypePickerImage_ForbidEditing,
    LocalAbilityTypePickerPhotograph_ForbidEditing,
    LocalAbilityTypePickerScanQRCode,
    LocalAbilityTypePickerGenerateQRCode,
    LocalAbilityTypePickerVideotape,
};

typedef void(^touchIDFinish)(NSError *error);

@interface LocalAbilityManager : NSObject

// 建议不用单例，建议把LocalAbilityManager作为类一个strong成员变量
// 可以跟随使用的页面对象释放而释放
+ (LocalAbilityManager *)sharedLocalAbilityManager;

- (void)pickerCameraController:(UIViewController*)picker type:(LocalAbilityType)type finish:(ImagePickerFinishBlock)finishBlock;

- (void)pickerMailSMSController:(UIViewController*)picker type:(LocalAbilityType)type andSubject:(NSString*)subject andContent:(NSString*)content finish:(SendFinishBlock)finishBlock;

// 生成二维码
+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;

// 生成条形码
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height;


+ (NSArray *)recognitionQRCodeFromImage:(UIImage*)image;

// 拨打电话可以返回当前页面
+ (void)telephoneToNumber:(NSString*)phoneNumber;

// 指纹验证
+ (void)touchIDPolicy:(touchIDFinish)finish;

@end
