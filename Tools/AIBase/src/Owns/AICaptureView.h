//
//  AICaptureView.h
//  CRMMobile_TJ
//
//  Created by wuyoujian on 16/7/31.
//  Copyright © 2016年 Asiainfo. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AICaptureViewCallback)(UIImage *originImage,UIImage *croppedImage);

@interface AICaptureView : UIView

+ (BOOL)checkAuthority;
- (void)photographWithCallback:(AICaptureViewCallback)callback;
- (void)cropRectForInterest:(CGRect)cropRect;
- (void)startCapture;
@end
