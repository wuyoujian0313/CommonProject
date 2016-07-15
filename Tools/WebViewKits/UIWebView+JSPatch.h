//
//  UIWebView+JSPatch.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^WebViewJSPatchBlock)(NSArray<JSValue*> *arguments);

@interface UIWebView (JSPatch)

- (JSContext *)webViewContext;

/**
 *  向webview中注册js调用Native的api
 *  @param webView 对应的WebView
 *  @param apiName 对应的js的function名称
 *  @param apiBlock 对应的Native的实现block
 */

- (void)registNativeAPIInWebViewApiName:(NSString*)apiName apiBlock:(WebViewJSPatchBlock)apiBlock;


/**
 *  在webView中执行js
 *  @param webView 对应的WebView
 *  @param script 需要执行的js代码
 */
- (JSValue*)evaluateScript:(NSString*)script;

@end
