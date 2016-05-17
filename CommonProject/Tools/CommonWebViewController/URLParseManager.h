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

typedef void(^URLParseFinishBlock)(InvokeServerType serverType,InvokeServerSubType subType,NSDictionary* param);


@interface URLParseManager : NSObject

- (void)urlParseWithURL:(NSURL*)url finish:(URLParseFinishBlock)finishBlock ;

@end
