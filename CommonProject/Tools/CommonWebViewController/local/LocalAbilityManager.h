//
//  LocalAbilityManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerController.h"
#import "MailSMSController.h"

typedef NS_ENUM(NSInteger, LocalAbilityType) {
    LocalAbilityTypeMail,
    LocalAbilityTypeSMS,
    LocalAbilityTypeDail,
    LocalAbilityTypePickerImage,
    LocalAbilityTypePickerPhoto,
    LocalAbilityTypePickerQRCode,
    LocalAbilityTypePickerVideo,
};

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


@end
