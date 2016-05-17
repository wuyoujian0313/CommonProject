//
//  ImagePickerController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ImagePickerController.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "QRViewController.h"
#import "UIImage+ResizeMagick.h"


@interface ImagePickerController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (nonatomic, copy) ImagePickerFinishBlock finishBlock;
@end

@implementation ImagePickerController

+ (ImagePickerController *)sharedImagePickerController {
    
    static ImagePickerController *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void)dealloc {
    self.finishBlock = nil;
}


/**
 *  照片选择
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerImageController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    //
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.allowsEditing = YES;
    imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
    imagePicker.delegate = self;
    imagePicker.navigationBar.barTintColor = [UIColor whiteColor];
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          [UIColor blackColor],NSForegroundColorAttributeName,
                          [UIFont systemFontOfSize:18],NSFontAttributeName,nil];
    imagePicker.navigationBar.titleTextAttributes = dict;
    [picker presentViewController:imagePicker animated:YES completion:^{
    }];
}


- (void)pickerCameraController:(UIViewController*)picker isPhoto:(BOOL)isPhoto {
    
    // 拍照
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied ) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"无法使用相机" message:@"请在iPhone的“设置-隐私-相机”中允许访问相机" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alertView show];
        return;
    }
    
    
    if ([UIImagePickerController isSourceTypeAvailable:
         UIImagePickerControllerSourceTypeCamera]) {
        
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        if (isPhoto) {
            
            imagePicker.allowsEditing = YES;
            imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeImage];
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        } else {
            
            imagePicker.mediaTypes = [NSArray arrayWithObject:(NSString *)kUTTypeMovie];//kUTTypeImage
            imagePicker.videoQuality = UIImagePickerControllerQualityTypeMedium;
            imagePicker.videoMaximumDuration = 8.0;
            imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
        }
        
        
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIColor blackColor],NSForegroundColorAttributeName,
                              [UIFont systemFontOfSize:18],NSFontAttributeName,nil];
        imagePicker.navigationBar.titleTextAttributes = dict;
        imagePicker.navigationBar.barTintColor = [UIColor whiteColor];
        [picker presentViewController:imagePicker animated:YES completion:^{
        }];
    }
}

/**
 *  调用摄像头拍照
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerPhotographController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    //
    [self pickerCameraController:picker isPhoto:YES];
}

/**
 *  调用摄像头录像
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerVideotapeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    //
    [self pickerCameraController:picker isPhoto:NO];
}

/**
 *  二维码识别
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerQRCodeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    
    self.finishBlock = finishBlock;
    ImagePickerController *wSelf = self;
    
    QRViewController *qrController = [[QRViewController alloc] init];
    [picker presentViewController:qrController animated:YES completion:^{
        //
        [qrController startScanQRCodeWithFinish:^(NSString *result, QRCodeScanStatus status) {
            //
            [picker dismissViewControllerAnimated:YES completion:^{}];
            
            ImagePickerController *sSelf = wSelf;
            if (sSelf.finishBlock) {
                sSelf.finishBlock(ImagePickerTypeQRCode,ImagePickerStatusSuccess,result);
            }
        }];
    }];
}

#pragma mark - imagepicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        //选择照片
        ImagePickerController *wSelf = self;
        dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
            UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
            CGSize scaleSize = [[UIScreen mainScreen] bounds].size;
            UIImage *imageScale = [image resizedImageByMagick:[NSString stringWithFormat:@"%ldx%ld",(long)scaleSize.width,(long)scaleSize.height]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                [picker dismissViewControllerAnimated:YES completion:^{
                    //
                    ImagePickerController *sSelf = wSelf;
                    if (sSelf.finishBlock) {
                        sSelf.finishBlock(ImagePickerTypeImage,ImagePickerStatusSuccess,imageScale);
                    }
                }];
            });
        });
    } else if (picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
        
        NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
        if ([mediaType isEqualToString:(NSString *)kUTTypeImage]) {
            //
            ImagePickerController *wSelf = self;
            dispatch_async(dispatch_get_global_queue(0, 0), ^(void) {
                UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
                CGSize scaleSize = [[UIScreen mainScreen] bounds].size;
                UIImage *imageScale = [image resizedImageByMagick:[NSString stringWithFormat:@"%ldx%ld",(long)scaleSize.width,(long)scaleSize.height]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //
                    [picker dismissViewControllerAnimated:YES completion:^{
                        //
                        ImagePickerController *sSelf = wSelf;
                        if (sSelf.finishBlock) {
                            sSelf.finishBlock(ImagePickerTypePhoto,ImagePickerStatusSuccess,imageScale);
                        }
                    }];
                });
            });
            
        } else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
            
            NSURL *url = [info objectForKey:UIImagePickerControllerMediaURL];
            //保存视频到相册
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
            [library writeVideoAtPathToSavedPhotosAlbum:url completionBlock:nil];
            
            ImagePickerController *wSelf = self;
            [picker dismissViewControllerAnimated:YES completion:^{
                //
                ImagePickerController *sSelf = wSelf;
                if (sSelf.finishBlock) {
                    sSelf.finishBlock(ImagePickerTypeVideo,ImagePickerStatusSuccess,url);
                }
            }];
        }
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{}];
}


@end
