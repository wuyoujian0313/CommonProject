//
//  QRViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "../Owns/DispatchTimer.h"
#import "../Category/UIView+SizeUtility.h"
#import "LineImageByteData.h"
#import "PickBGImageByteData.h"

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession              *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *preview;
@property (nonatomic, strong) UIImageView                   *lineImageView;

@property (nonatomic, strong) DispatchTimer                 *timer;

@end

@implementation QRViewController


- (BOOL)prefersStatusBarHidden {
    return YES;
}

-(void)dealloc {
    [_timer invalidate];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor blackColor]];
    
    [self layoutCaptureView];
}

- (void)initCaptureDevice {
    CGRect previewFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (_finishBlock) {
        _finishBlock(nil,QRCodeScanStatusFail);
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    
    self.session = [[AVCaptureSession alloc]init];
    
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeCode128Code,AVMetadataObjectTypeEAN8Code,AVMetadataObjectTypeUPCECode,AVMetadataObjectTypeCode39Code,AVMetadataObjectTypePDF417Code,AVMetadataObjectTypeAztecCode,AVMetadataObjectTypeCode93Code,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeCode39Mod43Code];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResize;
    self.preview.frame = previewFrame;
    
    [self.view.layer addSublayer:self.preview];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    } else {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake(10, 20, 40, 30)];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
}

- (void)startScanQRCode {
    [self.session startRunning];
}

- (void)startScanQRCodeWithFinish:(QRCodeFinishBlock)finishBlock {
    self.finishBlock = finishBlock;
    
    [self startScanQRCode];
}

- (void)layoutCaptureView {
    
    [self initCaptureDevice];
    
    NSData *data = [PickBGImageByteData byteData];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:data]];
    imageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 140, self.view.bounds.size.height * 0.5 - 140, 280, 280);
    [self.view addSubview:imageView];
    
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    
    NSData *data1 = [LineImageByteData byteData];
    _lineImageView.image = [UIImage imageWithData:data1];
    [imageView addSubview:_lineImageView];
    
    
    __weak QRViewController *wself = self;
    [[DispatchTimer sharedDispatchTimer] createDispatchTimerInterval:3.0 block:^{
        QRViewController *sself = wself;
        
        [sself scanAnimation];
    } repeats:YES];
}



- (void)scanAnimation {
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
    }];
}

- (void)cancelBtnClick:(id)sender {
    if (_finishBlock) {
        _finishBlock(nil,QRCodeScanStatusCancel);
    }
}

#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    [self.session stopRunning];
    [self.preview removeFromSuperlayer];
    
    NSString *val = nil;
    if (metadataObjects.count > 0) {
        AVMetadataMachineReadableCodeObject *obj = metadataObjects[0];
        val = obj.stringValue;
        
        if (_finishBlock) {
            _finishBlock(val,QRCodeScanStatusSuccess);
        }
    }
}


@end
