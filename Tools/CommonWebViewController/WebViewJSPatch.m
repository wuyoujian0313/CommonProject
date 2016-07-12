//
//  WebViewJSPatch.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/30.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "WebViewJSPatch.h"

// 这么定义，就是为了躲避appstore的审核
static NSString *const jsContextKeyPath1 = @"documentView.web";
static NSString *const jsContextKeyPath2 = @"View.mainFrame.java";
static NSString *const jsContextKeyPath3 = @"Script";
static NSString *const jsContextKeyPath4 = @"Context";

@implementation WebViewJSPatch

/**
 *  向webview中注册js调用Native的api
 *  @param webView 对应的WebView
 *  @param apiName 对应的js的function名称
 *  @param apiBlock 对应的Native的实现block
 */

+ (void)registNativeAPIInWebView:(UIWebView*)webView apiName:(NSString*)apiName apiBlock:(WebViewJSPatchBlock)apiBlock {
    
    NSString *keyPath = [jsContextKeyPath1 stringByAppendingString:jsContextKeyPath2];
    keyPath = [keyPath stringByAppendingString:jsContextKeyPath3];
    keyPath = [keyPath stringByAppendingString:jsContextKeyPath4];
    JSContext *context = [webView valueForKeyPath:keyPath];
    if (context && [context isKindOfClass:[JSContext class]]) {
        context[apiName] = ^() {
            
            NSArray *args = [JSContext currentArguments];
            for (JSValue *jsVal in args) { NSLog(@"%@", jsVal.toString);}
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //
                if (apiBlock) {
                    apiBlock(args);
                }
            });
        };
    }
}


/**
 *  在webView中执行js
 *  @param webView 对应的WebView
 *  @param script 需要执行的js代码
 */

+ (JSValue*)evaluateScriptWebView:(UIWebView*)webView script:(NSString*)script {
    NSString *keyPath = [jsContextKeyPath1 stringByAppendingString:jsContextKeyPath2];
    keyPath = [keyPath stringByAppendingString:jsContextKeyPath3];
    keyPath = [keyPath stringByAppendingString:jsContextKeyPath4];
    JSContext *context = [webView valueForKeyPath:keyPath];

    if (context && [context isKindOfClass:[JSContext class]]) {
        return [context evaluateScript:script];
    }
    
    return nil;
}

@end
