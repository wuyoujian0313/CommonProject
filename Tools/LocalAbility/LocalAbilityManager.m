//
//  LocalAbilityManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "LocalAbilityManager.h"
#import "UIImage+Utility.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface LocalAbilityManager ()

@property (nonatomic, strong) MailSMSController *mailSMSCtrl;
@property (nonatomic, strong) ImagePickerController *cameraPickerCtrl;
@end


@implementation LocalAbilityManager

+ (void)telephoneToNumber:(NSString*)phoneNumber {
    
    NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",phoneNumber]];
    UIWebView *phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    phoneCallWebView.tag = 9999;
    [[UIApplication sharedApplication].keyWindow addSubview:phoneCallWebView];
    [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(telephone:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
}

+ (void)telephone:(NSNotification*)notification {
    
    UIWebView *phoneCallWebView = (UIWebView*)[[UIApplication sharedApplication].keyWindow viewWithTag:9999];
    if ([phoneCallWebView isKindOfClass:[UIWebView class]]) {
        [phoneCallWebView removeFromSuperview];
    }
    
    static BOOL isFirst = YES;
    if (isFirst) {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(telephone:) name:UIApplicationDidBecomeActiveNotification object:nil];
        
        isFirst = NO;
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self];
        isFirst = YES;
    }
}

// 生成二维码
+ (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    return [UIImage generateQRCode:code width:width height:height];
}
// 生成条形码
+ (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    return [UIImage generateBarCode:code width:width height:height];
}

+ (NSArray *)recognitionQRCodeFromImage:(UIImage*)image {

    return [image recognitionQRCodeFromImage];
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
        obj.allowsEditing = NO;
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
    } else if (type == LocalAbilityTypePickerImage_AllowsEditing ||
               type == LocalAbilityTypePickerImage_ForbidEditing) {
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        obj.allowsEditing = (type == LocalAbilityTypePickerImage_AllowsEditing);
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
    } else if (type == LocalAbilityTypePickerPhotograph_AllowsEditing ||
               type == LocalAbilityTypePickerPhotograph_ForbidEditing) {
        ImagePickerController *obj = [[ImagePickerController alloc] init];
        obj.allowsEditing = (type == LocalAbilityTypePickerPhotograph_AllowsEditing);
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

+ (void)touchIDPolicy:(touchIDFinish)finish {
    
    LAContext *context = [[LAContext alloc] init];
    NSError *error = nil;
    BOOL success = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    if (success) {
        
        // 有指纹设备且设置了指纹
        context.localizedFallbackTitle = @"";
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"通过验证指纹解锁" reply:^(BOOL success, NSError* error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (error) {
                    
                    switch (error.code) {
                        case LAErrorAuthenticationFailed:
                        case LAErrorUserCancel:
                        case LAErrorSystemCancel:
                        case LAErrorUserFallback:
                        case LAErrorPasscodeNotSet:
                        case LAErrorTouchIDNotAvailable:
                        case LAErrorTouchIDNotEnrolled:
                            break;
                        default:
                            break;
                    }
                } else {
                    // 验证成功
                }
                
                if (finish) {
                    finish(error);
                }
            });
        }];
    } else {
        //
        if (error.code == kLAErrorPasscodeNotSet || error.code == kLAErrorTouchIDNotEnrolled) {
            // 有指纹设备，但未设置
            
            if ([DeviceInfo isOS9]) {
                
                UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    //
                }];
                //
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"指纹提示" message:@"请先在系统\"设置 > Touch ID与密码\"开启" preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:aAction2];
                
                AppDelegate *app =  [AppDelegate shareMyApplication];
                
                [app.window.rootViewController presentViewController:alertController animated:YES completion:nil];
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"指纹提示" message:@"请先在系统\"设置 > Touch ID与密码\"开启" delegate:self cancelButtonTitle:@"知道了"otherButtonTitles:nil];
                [alert show];
            }
            
            if (finish) {
                finish(error);
            }
        }
    }
}

@end
