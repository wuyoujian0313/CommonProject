//
//  CaptureViewController.m
//  ultracrm-ios
//
//  Created by wuyoujian on 16/7/31.
//  Copyright © 2016年 Asiainfo. All rights reserved.
//

#import "CaptureViewController.h"
#import "AICaptureView.h"
#import "UIImage+ResizeMagick.h"
#import "DeviceInfo.h"


@interface CaptureViewController ()
@property (nonatomic,strong)AICaptureView *captureView;
@end

@implementation CaptureViewController

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
    [_captureView startCapture];
}

-(void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self setContentViewBackgroundColor:[UIColor blackColor]];
    
    //243px          高:153px
    CGFloat width = 200 * 243 / 153;
    CGRect markFrame = CGRectMake((self.view.frame.size.width - width)/2.0, 180, width, 200);
    AICaptureView *captureView = [[AICaptureView alloc] initWithFrame:self.view.bounds];
    self.captureView = captureView;
    [_captureView cropRectForInterest:markFrame];
    [self.view addSubview:captureView];
    
    UIView *markView = [[UIView alloc] initWithFrame:markFrame];
    [markView setBackgroundColor:[UIColor clearColor]];
    [markView.layer setBorderColor:[UIColor greenColor].CGColor];
    [markView.layer setBorderWidth:1.0];
    [self.view addSubview:markView];

    CGFloat alpha = 0.7;
    UIView *markView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width,markFrame.origin.y)];
    [markView1 setBackgroundColor:[UIColor blackColor]];
    [markView1 setAlpha:alpha];
    [self.view addSubview:markView1];
    
    UIView *markView2 = [[UIView alloc] initWithFrame:CGRectMake(0, markFrame.origin.y, markFrame.origin.x, markFrame.size.height)];
    [markView2 setBackgroundColor:[UIColor blackColor]];
    [markView2 setAlpha:alpha];
    [self.view addSubview:markView2];
    
    UIView *markView3 = [[UIView alloc] initWithFrame:CGRectMake(markFrame.origin.x + markFrame.size.width, markFrame.origin.y, self.view.frame.size.width - markFrame.origin.x - markFrame.size.width, markFrame.size.height)];
    [markView3 setBackgroundColor:[UIColor blackColor]];
    [markView3 setAlpha:alpha];
    [self.view addSubview:markView3];
    
    UIView *markView4 = [[UIView alloc] initWithFrame:CGRectMake(0, markFrame.origin.y + markFrame.size.height, self.view.frame.size.width, self.view.frame.size.height - markFrame.size.height- markFrame.origin.y)];
    [markView4 setBackgroundColor:[UIColor blackColor]];
    [markView4 setAlpha:alpha];
    [self.view addSubview:markView4];
    
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [cancelBtn setFrame:CGRectMake(10, 30, 40, 30)];
    [cancelBtn setTag:100];
    [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    
    UIButton *captureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [captureBtn setFrame:CGRectMake((self.view.frame.size.width - 66) / 2, self.view.frame.size.height - 80 , 66, 66)];
    [captureBtn setTag:101];
    [captureBtn setImage:[UIImage imageNamed:@"capture"] forState:UIControlStateNormal];
    [captureBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:captureBtn];
    
}

- (void)buttonAction:(UIButton *)sender {
    if (sender.tag == 100) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if(sender.tag == 101) {
        
        __weak typeof(self) weakSelf = self;
        [self.captureView photographWithCallback:^(UIImage *originImage, UIImage *croppedImage) {
            CGFloat w = croppedImage.size.width;
            CGFloat h = croppedImage.size.height;
            NSInteger ww = (NSInteger)(600 * w / h);
            
            NSString* sizeString = [NSString stringWithFormat:@"%ldx%d",(long)ww,600];
            
            UIImage *image = [croppedImage resizedImageByMagick:sizeString];
            NSData *d = UIImagePNGRepresentation(image);
            
            NSString *docPath = [DeviceInfo getDocumentsPath];
            NSString *filePath = [docPath stringByAppendingFormat:@"/%@.png",_fileId];
            [d writeToFile:filePath atomically:YES];
            
            UIImageView *captureImageView = [[UIImageView alloc] initWithImage:image];
            captureImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.8];
            captureImageView.frame = CGRectOffset(weakSelf.view.bounds, 0, -weakSelf.view.bounds.size.height);
            captureImageView.alpha = 1.0;
            captureImageView.contentMode = UIViewContentModeScaleAspectFit;
            captureImageView.userInteractionEnabled = YES;
            [weakSelf.view addSubview:captureImageView];
            
    
            UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [okBtn setFrame:CGRectZero];
            [okBtn setTag:102];
            [okBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [okBtn setTitle:@"完成" forState:UIControlStateNormal];
            [okBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [captureImageView addSubview:okBtn];
            
            
            UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissPreview:)];
            [captureImageView addGestureRecognizer:dismissTap];
            
            UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
            [cancelBtn setFrame:CGRectZero];
            [cancelBtn setTag:103];
            [cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:16]];
            [cancelBtn setTitle:@"重拍" forState:UIControlStateNormal];
            [cancelBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
            [captureImageView addSubview:cancelBtn];
            
            [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
                
                captureImageView.frame = weakSelf.view.bounds;
                
                [cancelBtn setFrame:CGRectMake(20, captureImageView.frame.size.height - 60, 40, 30)];
                
                [okBtn setFrame:CGRectMake(captureImageView.frame.size.width - 60, captureImageView.frame.size.height - 60, 40, 30)];
                
            } completion:nil];

          }];
    } else if (sender.tag == 102) {
        [self.navigationController popViewControllerAnimated:YES];
        [sender.superview removeFromSuperview];
        
    } else if (sender.tag == 103) {
        [self dismissView:sender.superview];
    }
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap {
    [self dismissView:dismissTap.view];
}

- (void)dismissView:(UIView *)view {
    
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
        NSString *docPath = [DeviceInfo getDocumentsPath];
        NSString *filePath = [docPath stringByAppendingFormat:@"/%@.png",_fileId];
        NSFileManager *fMgr = [NSFileManager defaultManager];
        [fMgr removeItemAtPath:filePath error:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
