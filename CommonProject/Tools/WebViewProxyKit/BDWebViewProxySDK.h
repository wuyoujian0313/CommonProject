//
//  BDWebViewProxySDK.h
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/6.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM (NSInteger, BDWebViewProxySDKEnvironment) {
    BDWebViewProxySDK_TEST,             // 测试环境
    BDWebViewProxySDK_ONLINE            // 正式环境,默认
};

typedef void (^startHTTTPProxyFinish)(void);


@interface BDWebViewProxySDK : NSObject

// 默认正式环境
- (instancetype)init;

// 可以设置连接的环境
- (instancetype)initWithEnviroment:(BDWebViewProxySDKEnvironment)environment;

// 停止代理
- (void)stopHTTPProxy;

// 启动代理
- (void)startHTTTPProxyWithAT:(NSString*)at mopKey:(NSString*)mopKey userName:(NSString*)userName finish:(startHTTTPProxyFinish)block;

// 增加过滤的url
- (void)addIgnoreURLList:(NSArray*)urls;

@end
