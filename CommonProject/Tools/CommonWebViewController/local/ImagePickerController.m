//
//  ImagePickerController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ImagePickerController.h"
#import <AVFoundation/AVFoundation.h>


@interface ImagePickerController ()

@property (nonatomic, copy) ImagePickerFinishBlock finishBlock;

@end

@implementation ImagePickerController

/**
 *  照片选择
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerImageController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    
}

/**
 *  调用摄像头
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerVideoController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    
}

/**
 *  二维码识别
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 */
- (void)pickerQRCodeController:(UIViewController*)picker finish:(ImagePickerFinishBlock)finishBlock {
    
}

- (UIImage *)generateQRCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *qrcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    qrcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / qrcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / qrcodeImage.extent.size.height;
    CIImage *transformedImage = [qrcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

- (UIImage *)generateBarCode:(NSString *)code width:(CGFloat)width height:(CGFloat)height {
    
    // 生成二维码图片
    CIImage *barcodeImage;
    NSData *data = [code dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:false];
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
    
    [filter setValue:data forKey:@"inputMessage"];
    barcodeImage = [filter outputImage];
    
    // 消除模糊
    CGFloat scaleX = width / barcodeImage.extent.size.width; // extent 返回图片的frame
    CGFloat scaleY = height / barcodeImage.extent.size.height;
    CIImage *transformedImage = [barcodeImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];
    
    return [UIImage imageWithCIImage:transformedImage];
}

@end
