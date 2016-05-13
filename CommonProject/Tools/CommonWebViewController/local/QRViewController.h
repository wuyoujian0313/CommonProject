//
//  QRViewController.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QRViewController;
@protocol QRCodeFinishDelegate <NSObject>
- (void)qrCodeFinishWithController:(QRViewController*)viewController result:(NSString*)code error:(NSError*)error;
- (void)qrCodeCancelWithController:(QRViewController*)viewController;
@end


@interface QRViewController : UIViewController

@property (nonatomic, weak) id <QRCodeFinishDelegate> delegate;

@end
