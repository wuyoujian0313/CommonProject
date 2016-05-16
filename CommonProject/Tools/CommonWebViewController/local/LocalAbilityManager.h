//
//  LocalAbilityManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImagePickerController.h"

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

- (void)pickerCameraController:(UIViewController*)picker type:(LocalAbilityType)type finish:(ImagePickerFinishBlock)finishBlock;


@end
