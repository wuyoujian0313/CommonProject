//
//  SharedManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedDataModel.h"

typedef NS_ENUM(NSInteger, SharedStatusCode) {
    SharedStatusCodeSuccess,
    SharedStatusCodeFail,
    SharedStatusCodeCancel,
};

typedef void(^SharedFinishBlock)(SharedStatusCode statusCode);

@interface SharedManager : NSObject

// 建议不用单例，可以只用局部变量或者作为类的一个strong成员变量
+ (SharedManager *)sharedSharedManager;

/**
 *  分享
 *
 *  @param viewController 弹出
 */
- (void)sharedDataFromViewController:(UIViewController*)viewController withData:(SharedDataModel*)dataModel finish:(SharedFinishBlock)finishBlock;

@end
