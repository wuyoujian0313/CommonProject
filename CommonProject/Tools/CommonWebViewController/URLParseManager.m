//
//  URLParseManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/17.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "URLParseManager.h"

// 主服务
NSString* const kSharedProtocol=@"sharedto";
NSString* const kPayProtocol=@"payto";
NSString* const kLocalAbilityProtocol=@"localabilityto";

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

+ (BOOL)isCustomURL:(NSURL*)url {
    if ([url.scheme compare:kSharedProtocol options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame ||
        [url.scheme compare:kPayProtocol options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame ||
        [url.scheme compare:kLocalAbilityProtocol options:NSCaseInsensitiveSearch | NSNumericSearch] == NSOrderedSame ) {
        
        return YES;
    }
    
    return NO;
}

+ (void)urlParseWithURL:(NSURL*)url finish:(URLParseFinishBlock)finishBlock {

    InvokeServerType serverType = InvokeServerTypeNone;
    InvokeServerSubType subType = InvokeServerSubTypeNone;
    
    if ([url.scheme isEqualToString:kSharedProtocol]) {
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


    NSString* queryString = [url.query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSArray *queryArray = [queryString componentsSeparatedByString:@"&"];
    if (queryArray) {
        for (NSString *temp in queryArray) {
            NSArray *keyValue = [temp componentsSeparatedByString:@"="];
            if (keyValue && [keyValue count] == 2) {
                [param setObject:[keyValue lastObject] forKey:[keyValue firstObject]];
            }
        }
    }
    
    if (finishBlock) {
        finishBlock(serverType,subType,param);
    }
}

@end
