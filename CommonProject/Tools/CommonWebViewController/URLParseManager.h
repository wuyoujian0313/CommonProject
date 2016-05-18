//
//  URLParseManager.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/17.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, InvokeServerType) {
    InvokeServerTypeNone,
    InvokeServerTypeLocalAbility,
    InvokeServerTypePay,
    InvokeServerTypeShared,
};

typedef NS_ENUM(NSInteger, InvokeServerSubType) {
    InvokeServerSubTypeNone,
    InvokeServerSubTypeShared,
    InvokeServerSubTypeWXPay,
    InvokeServerSubTypeAlipay,
    InvokeServerSubTypeBaiduMap,
    InvokeServerSubTypeSelectImage,
    InvokeServerSubTypePhotograph,
    InvokeServerSubTypeVideotape,
    InvokeServerSubTypeScanQRCode,
    InvokeServerSubTypeGenerateQRCode,
};

// 主服务
extern NSString* const kSharedProtocol;
extern NSString* const kPayProtocol;
extern NSString* const kLocalAbilityProtocol;

// 子服务
extern NSString* const kSharedServer;
extern NSString* const kBaiDuMapServer;
extern NSString* const kWXPayServer;
extern NSString* const kAlipayServer;
extern NSString* const kSelectImageServer;
extern NSString* const kPhotographServer;
extern NSString* const kVideotapeServer;
extern NSString* const kScanQRCodeServer;
extern NSString* const kGenerateQRCodeServer;

typedef void(^URLParseFinishBlock)(InvokeServerType serverType,InvokeServerSubType subType,NSDictionary* param);

@interface URLParseManager : NSObject

+ (BOOL)isCustomURL:(NSURL*)url;
+ (void)urlParseWithURL:(NSURL*)url finish:(URLParseFinishBlock)finishBlock ;

@end
