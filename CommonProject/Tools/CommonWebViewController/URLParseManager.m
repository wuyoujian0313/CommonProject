//
//  URLParseManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/17.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "URLParseManager.h"

// 主服务
NSString* const kSharedProtocol=@"SharedTo";
NSString* const kPayProtocol=@"PayTo";
NSString* const kLocalAbilityProtocol=@"LocalAbilityTo";

// 子服务
NSString* const kSharedServer=@"SharedServer";
NSString* const kBaiDuMapServer=@"BaiDuMapServer";
NSString* const kWXPayServer=@"WXPayServer";
NSString* const kAlipayServer=@"AlipayServer";
NSString* const kSelectImageServer=@"SelectImageServer";
NSString* const kPhotographServer=@"PhotographServer";
NSString* const kVideotapeServer=@"VideotapeServer";
NSString* const kScanQRCodeServer=@"ScanQRCodeServer";
NSString* const kGenerateQRCodeServer=@"GenerateQRCodeServer";

@implementation URLParseManager

- (void)urlParseWithURL:(NSURL*)url finish:(URLParseFinishBlock)finishBlock {

    InvokeServerType serverType = InvokeServerTypeNone;
    InvokeServerSubType subType = InvokeServerSubTypeNone;
    
    if ([url.scheme isEqualToString:kSharedServer]) {
        // 分享
        serverType = InvokeServerTypeShared;
        if ([url.host isEqualToString:kSharedServer]) {
            subType = InvokeServerSubTypeShared;
        }
    } else if ([url.scheme isEqualToString:kPayProtocol]) {
        // 支付
        serverType = InvokeServerTypePay;
        if ([url.host isEqualToString:kWXPayServer]) {
            //
            subType = InvokeServerSubTypeWXPay;
        } else if ([url.host isEqualToString:kAlipayServer]) {
            //
            subType = InvokeServerSubTypeAlipay;
        }
        
    } else if ([url.scheme isEqualToString:kLocalAbilityProtocol]) {
        // 本地能力
        serverType = InvokeServerTypeLocalAbility;
        if ([url.host isEqualToString:kSelectImageServer]) {
            //
            subType = InvokeServerSubTypeSelectImage;
        } else if ([url.host isEqualToString:kPhotographServer]) {
            //
            subType = InvokeServerSubTypePhotograph;
        } else if ([url.host isEqualToString:kVideotapeServer]) {
            //
            subType = InvokeServerSubTypeVideotape;
        } else if ([url.host isEqualToString:kScanQRCodeServer]) {
            //
            subType = InvokeServerSubTypeScanQRCode;
        } else if ([url.host isEqualToString:kGenerateQRCodeServer]) {
            //
            subType = InvokeServerSubTypeGenerateQRCode;
        }
    }
    
    NSString *queryString = url.query;
    NSString *paramJson = [queryString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData *jsonData = [paramJson dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSDictionary *param = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    if (finishBlock) {
        finishBlock(serverType,subType,param);
    }
}

@end
