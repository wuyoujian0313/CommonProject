//
//  URLProtocolParameters.m
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/8.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import "URLProtocolParameters.h"



@implementation URLProtocolParameters

+ (instancetype) sharedURLProtocolParameter {
    static URLProtocolParameters *_sParameters = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sParameters = [[URLProtocolParameters alloc] init];
    });
    return _sParameters;
}

- (void)clearParameters {
    [self setAuthConfig:nil];
    [self setProxyConfig:nil];
    [self setPassword:nil];
}



@end
