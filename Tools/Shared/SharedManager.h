//
//  SharedManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SharedDataModel.h"
#import "WXApi.h"

typedef NS_ENUM(NSInteger, AISharedPlatform) {
    AISharedPlatformWechat,
    AISharedPlatformQQ,
};

typedef NS_ENUM(NSInteger, AISharedStatusCode) {
    AISharedStatusCodeDone,         // 调起分享平台的应用成功
    AISharedStatusCodeUnintallApp,  // 未安装对应的分享平台的应用
};

typedef void(^AISharedFinishBlock)(AISharedStatusCode statusCode,BaseResp* wxResp);

@interface SharedPlatformSDKInfo : NSObject
@property (nonatomic, assign) AISharedPlatform platform;
@property (nonatomic, copy) NSString *appId;
@property (nonatomic, copy) NSString *appSecret;

+ (instancetype)platform:(AISharedPlatform)platform
                   appId:(NSString*)appId
                  secret:(NSString*)appSecret;
@end

@interface SharedManager : NSObject<WXApiDelegate>

+ (SharedManager *)sharedSharedManager;
// 注册分享平台
- (void)registerSharedPlatform:(NSArray<SharedPlatformSDKInfo*> *)platforms;
// 分享
- (void)sharedData:(SharedDataModel*)dataModel finish:(AISharedFinishBlock)finishBlock;

@end
