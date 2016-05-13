//
//  QRViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "QRViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "DispatchTimer.h"

@interface QRViewController ()<AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureSession              *session;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer    *preview;
@property (nonatomic, strong) UIImageView                   *lineImageView;

@property (nonatomic ,strong) DispatchTimer                 *timer;
@end

@implementation QRViewController

-(void)dealloc {
    [_timer stopDispatchTimer];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self layoutCaptureView];
}

- (void)initCaptureDevice {
    CGRect previewFrame = CGRectMake(0, 0, self.view.width, self.view.height);
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    
    if (error) {
        if ([_delegate respondsToSelector:@selector(qrCodeFinishWithController:result:error:)]) {
            [_delegate qrCodeFinishWithController:self result:nil error:error];
        }
        return;
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
    
    output.metadataObjectTypes = @[AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code, AVMetadataObjectTypeQRCode];
    
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.preview.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    self.preview.frame = previewFrame;
    
    [self.view.layer addSublayer:self.preview];
    
    if ([UIScreen mainScreen].bounds.size.height == 480) {
        [self.session setSessionPreset:AVCaptureSessionPreset640x480];
    } else {
        [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    }
    
    [self.session startRunning];
}


- (void)layoutCaptureView {
    
    [self initCaptureDevice];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pick_bg.png"]];
    imageView.frame = CGRectMake(self.view.bounds.size.width * 0.5 - 140, self.view.bounds.size.height * 0.5 - 140, 280, 280);
    [self.view addSubview:imageView];
    
    
    self.lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 220, 2)];
    _lineImageView.image = [UIImage imageNamed:@"line.png"];
    [imageView addSubview:_lineImageView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelBtnClick:)];
    
    
    __weak QRViewController *wself = self;
    self.timer = [DispatchTimer createDispatchTimerInterval:3.0 block:^{
        QRViewController *sself = wself;
        
        [sself scanAnimation];
    }];
    [self.timer startDispatchTimer];
}



- (void)scanAnimation {
    [UIView animateWithDuration:2.8 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        _lineImageView.frame = CGRectMake(30, 260, 220, 2);
        
    } completion:^(BOOL finished) {
        _lineImageView.frame = CGRectMake(30, 10, 220, 2);
    }];
}

- (void)cancelBtnClick:(id)sender {
    if ([_delegate respondsToSelector:@selector(qrCodeCancelWithController:)]) {
        [_delegate qrCodeCancelWithController:self];
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
        
        if ([_delegate respondsToSelector:@selector(qrCodeFinishWithController:result:error:)]) {
            [_delegate qrCodeFinishWithController:self result:val error:nil];
        }
    }
}


@end
