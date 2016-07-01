//
//  WebViewJSPatch.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/30.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "WebViewJSPatch.h"

static NSString *const jsContextKeyPath = @"documentView.webView.mainFrame.javaScriptContext";

@implementation WebViewJSPatch

/**
 *  向webview中注册js调用Native的api
 *  @param webView 对应的WebView
 *  @param apiName 对应的js的function名称
 *  @param apiBlock 对应的Native的实现block
 */

+ (void)registNativeAPIInWebView:(UIWebView*)webView apiName:(NSString*)apiName apiBlock:(WebViewJSPatchBlock)apiBlock {
    
    JSContext *context = [webView valueForKeyPath:jsContextKeyPath];
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
    JSContext *context = [webView valueForKeyPath:jsContextKeyPath];

    if (context && [context isKindOfClass:[JSContext class]]) {
        return [context evaluateScript:script];
    }
    
    return nil;
}

@end
