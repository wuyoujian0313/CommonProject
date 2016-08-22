//
//  SharedManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedDataModel.h"


typedef NS_ENUM(NSInteger, AISharedPlatform) {
    AISharedPlatformWechat,
    AISharedPlatformQQ,
};

typedef NS_ENUM(NSInteger, AISharedStatusCode) {
    AISharedStatusCodeDone = 1000,          // 调起分享平台的应用成功
    AISharedStatusCodeUnintallApp,          // 未安装对应的分享平台的应用
};

// @param resp 是微信或者qq的回调对象
// @param statusCode可以是AISharedStatusCode，也兼容QQ的QQApiSendResultCode
typedef void(^AISharedFinishBlock)(NSInteger statusCode,id resp);

@protocol WXApiDelegate;
@interface WXSDKCallback : NSObject<WXApiDelegate>
@end

@protocol QQApiInterfaceDelegate;
@interface QQSDKCallback : NSObject<QQApiInterfaceDelegate>

@end


@interface SharedPlatformSDKInfo : NSObject
@property (nonatomic, assign) AISharedPlatform platform;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appSecret;

+ (instancetype)platform:(AISharedPlatform)platform
                   appId:(NSString*)appId
                  secret:(NSString*)appSecret;
@end


@interface SharedManager : NSObject

@property (nonatomic, strong) WXSDKCallback *wxCallback;
@property (nonatomic, strong) QQSDKCallback *qqCallback;

+ (SharedManager *)sharedSharedManager;
// 注册分享平台
- (void)registerSharedPlatform:(NSArray<SharedPlatformSDKInfo*> *)platforms;
// 分享
- (void)sharedData:(SharedDataModel*)dataModel finish:(AISharedFinishBlock)finishBlock;

@end
