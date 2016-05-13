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

typedef NS_ENUM(NSInteger, SharedWayType) {
    SharedWayTypeMail,
    SharedWayTypeSMS,
    SharedWayTypeWeixin,
    SharedWayTypeQQ,
};

typedef void(^SharedFinishBlock)(SharedWayType wayType,SharedStatusCode statusCode);

// 不提供单例模式，需要及时回收内存
@interface SharedManager : NSObject


/**
 *  分享
 *
 *  @param viewController 弹出
 */
- (void)sharedDataFromViewController:(UIViewController*)viewController withData:(SharedDataModel*)dataModel sharedWay:(SharedWayType)wayType finish:(SharedFinishBlock)finishBlock;

@end
