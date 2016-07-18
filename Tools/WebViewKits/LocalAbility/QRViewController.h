//
//  QRViewController.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QRCodeScanStatus) {
    QRCodeScanStatusSuccess,
    QRCodeScanStatusFail,
    QRCodeScanStatusCancel,
};

typedef void(^QRCodeFinishBlock)(NSString *result, QRCodeScanStatus status);

@interface QRViewController : UIViewController

@property (nonatomic, copy) QRCodeFinishBlock finishBlock;

- (void)startScanQRCode;
- (void)startScanQRCodeWithFinish:(QRCodeFinishBlock)finishBlock;

@end
