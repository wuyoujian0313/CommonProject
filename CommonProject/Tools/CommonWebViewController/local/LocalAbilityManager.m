//
//  LocalAbilityManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "LocalAbilityManager.h"


@implementation LocalAbilityManager

-(void)dealloc {
}

- (void)pickerCameraController:(UIViewController*)picker type:(LocalAbilityType)type finish:(ImagePickerFinishBlock)finishBlock {
    
    if (type == LocalAbilityTypePickerQRCode) {
        //
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        [obj pickerQRCodeController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
        }];
    } else if (type == LocalAbilityTypePickerImage){
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        [obj pickerImageController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
        }];
    } else if (type == LocalAbilityTypePickerPhoto){
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        [obj pickerPhotoController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
        }];
    } else if (type == LocalAbilityTypePickerVideo){
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        [obj pickerVideoController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
        }];
    } else {
        
    }
}

@end
