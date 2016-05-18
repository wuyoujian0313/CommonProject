//
//  LocalAbilityManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "LocalAbilityManager.h"
#import "UIImage+Utility.h"

@interface LocalAbilityManager ()

@property (nonatomic, strong) MailSMSController *mailSMSCtrl;
@property (nonatomic, strong) ImagePickerController *cameraPickerCtrl;
@end


@implementation LocalAbilityManager

// 生成二维码
+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    return [UIImage generateQRCode:code width:width height:height];
}
// 生成条形码
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    return [UIImage generateBarCode:code width:width height:height];
}

+ (LocalAbilityManager *)sharedLocalAbilityManager {
    static LocalAbilityManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

-(void)dealloc {
    
    self.mailSMSCtrl = nil;
    self.cameraPickerCtrl = nil;
}

- (void)pickerMailSMSController:(UIViewController*)picker type:(LocalAbilityType)type andSubject:(NSString*)subject andContent:(NSString*)content finish:(SendFinishBlock)finishBlock {
    
    if (type == LocalAbilityTypeMail) {
        MailSMSController *obj = [[MailSMSController alloc] init];
        self.mailSMSCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerMailComposeViewController:picker andSubject:subject andContent:content finish:^(SendType type, SendStatus status) {
            //
            //
            
            if (finishBlock) {
                finishBlock(type,status);
            }
            
            LocalAbilityManager *sSelf = wSelf;
            sSelf.mailSMSCtrl = nil;
        }];
    } else if (type == LocalAbilityTypeSMS) {
        MailSMSController *obj = [[MailSMSController alloc] init];
        self.mailSMSCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerMessageComposeViewController:picker andContent:content finish:^(SendType type, SendStatus status) {
            
            if (finishBlock) {
                finishBlock(type,status);
            }
            
            LocalAbilityManager *sSelf = wSelf;
            sSelf.mailSMSCtrl = nil;
        }];
    } else {
        //
    }
}

- (void)pickerCameraController:(UIViewController*)picker type:(LocalAbilityType)type finish:(ImagePickerFinishBlock)finishBlock {
    
    if (type == LocalAbilityTypePickerScanQRCode) {
        //
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        self.cameraPickerCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerQRCodeController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
            
            LocalAbilityManager *sSelf = wSelf;
            sSelf.cameraPickerCtrl = nil;
        }];
    } else if (type == LocalAbilityTypePickerImage) {
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        self.cameraPickerCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerImageController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (finishBlock) {
                
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
            
            LocalAbilityManager *sSelf = wSelf;
            sSelf.cameraPickerCtrl = nil;
        }];
    } else if (type == LocalAbilityTypePickerPhotograph) {
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        self.cameraPickerCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerPhotographController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
            LocalAbilityManager *sSelf = wSelf;
            sSelf.cameraPickerCtrl = nil;
        }];
    } else if (type == LocalAbilityTypePickerVideotape) {
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        self.cameraPickerCtrl = obj;
        __weak LocalAbilityManager *wSelf = self;
        [obj pickerVideotapeController:picker finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (finishBlock) {
                finishBlock(type,ImagePickerStatusSuccess,data);
            }
            LocalAbilityManager *sSelf = wSelf;
            sSelf.cameraPickerCtrl = nil;
        }];
    } else {
        
    }
}

@end
