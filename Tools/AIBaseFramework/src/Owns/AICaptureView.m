//
//  AICaptureView.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/31.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "AICaptureView.h"
#import <AVFoundation/AVFoundation.h>
#import "../Category/Category.h"

@interface AICaptureView ()
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureDeviceInput *inputDevice;
@property (nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, assign) CGRect cropRect;
@end

@implementation AICaptureView


+ (BOOL)checkAuthority {
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
        return NO;
    }
    return YES;
}

- (void)dealloc {
    if ([self.session isRunning]) {
        [self.session stopRunning];
        self.session = nil;
    }
}

- (void)setupCameraView {
    
    self.session = [[AVCaptureSession alloc] init];
    [_session beginConfiguration];
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if (!device) return;
    
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!error) {
        if ([_session canAddInput:deviceInput]) {
            [_session addInput:deviceInput];
            self.inputDevice = deviceInput;
        }
    } else{
        NSLog(@"你的设备没有照相机");
    }
    
    AVCaptureStillImageOutput *imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];//输出jpeg
    imageOutput.outputSettings = outputSettings;
    [_session addOutput:imageOutput];
    self.stillImageOutput = imageOutput;
    
    AVCaptureConnection *connection = [imageOutput.connections firstObject];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    
    if (device.isFlashAvailable) {
        [device lockForConfiguration:nil];
        [device setFlashMode:AVCaptureFlashModeOff];
        [device unlockForConfiguration];
        
        if ([device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
            [device lockForConfiguration:nil];
            [device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
            [device unlockForConfiguration];
        }
    }
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    _previewLayer.frame = self.bounds;
    [_previewLayer.connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
    [self.layer addSublayer:_previewLayer];
    
    [_session commitConfiguration];
}

- (void)startCapture {
    [_session startRunning];
}

- (void)cropRectForInterest:(CGRect)cropRect {
    self.cropRect = cropRect;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
        [self setupCameraView];
        self.cropRect = self.bounds;
    }
    return self;
}

- (void)photographWithCallback:(AICaptureViewCallback)callback {
    
    AVCaptureConnection *connection = [_stillImageOutput.connections firstObject];
    if (!connection) {
        NSLog(@"你的设备没有照相机");
        return;
    }
    __weak typeof(self)wSelf = self;
    [_stillImageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        
        if (!CMSampleBufferIsValid(imageDataSampleBuffer)) return;
        
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        UIImage *originImage = [[UIImage alloc] initWithData:imageData];
        UIImage *fixOriginImage = [originImage fixOrientation];
        
        CGFloat scanW = fixOriginImage.size.width/ self.bounds.size.width;
        CGFloat scanH = fixOriginImage.size.height/ self.bounds.size.height;
        CGFloat cropX = wSelf.cropRect.origin.x * scanW;
        CGFloat cropY = wSelf.cropRect.origin.y * scanH;
        CGFloat cropWidth = wSelf.cropRect.size.width * scanW;
        CGFloat cropHeight = wSelf.cropRect.size.height * scanH;
        
        CGRect rectCrop = CGRectMake(cropX,cropY, cropWidth, cropHeight);
        UIImage *croppedImage = [fixOriginImage croppedImage:rectCrop];
        
        if (callback) {
            callback(fixOriginImage,croppedImage);
        }
    }];
}



@end
