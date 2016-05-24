//
//  URLProtocolParameters.h
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/8.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URLProtocolParameters : NSObject

+ (instancetype) sharedURLProtocolParameter;

/*!
 设置代理信息
 
 例如:
 @{
 
 @"HTTPEnable"  : [NSNumber numberWithInt:1],
 (__bridge NSString *)kCFStreamPropertyHTTPProxyHost  : proxyHost,
 (__bridge NSString *)kCFStreamPropertyHTTPProxyPort  : proxyPort,
 
 @"HTTPSEnable" : [NSNumber numberWithInt:1],
 (__bridge NSString *)kCFStreamPropertyHTTPSProxyHost : proxyHost,
 (__bridge NSString *)kCFStreamPropertyHTTPSProxyPort : proxyPort,
 }
 */
@property(nonatomic, copy) NSDictionary     *proxyConfig;



/*!
 
 设置认证信息&内网令牌
 
 例如:
 NSString *at = @"***";
 NSString *userName = @"****";
 NSString *pwd = @"****";
 NSString *upString = [NSString stringWithFormat:@"%@:%@",userName,pwd];
 NSString *base64Str = [GTMBase64 stringByEncodingData:[upString dataUsingEncoding:NSUTF8StringEncoding]];
 NSString *authString = [NSString stringWithFormat:@"Basic %@",base64Str];
 if (authString && [authString length] > 0 && at && [at length] > 0 ) {
 self.authDict = @{  @"Proxy-Authorization"  : authString,
 @"client"               : @"IOS",
 @"X-MOP-AT"             : at};
 [CustomHTTPProtocol setAuthConfig:self.authDict];
 }
 
 */
@property(nonatomic, copy) NSDictionary     *authConfig;


/*!
 设置内容加密密码
 */
@property(nonatomic, copy) NSString         *password;

- (void)clearParameters;

@end
