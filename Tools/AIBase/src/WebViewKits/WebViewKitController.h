//
//  WebViewKitController.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "../Owns/BaseVC.h"
#import "ScriptPluginBase.h"


@interface WebViewKitController : BaseVC
@property (nonatomic, weak) id <UIWebViewDelegate> delegate;
@property (nonatomic, readonly, strong) UIWebView *contentWebView;

// 加载对应的url web页面
- (void)loadWebViewForURL:(NSURL*)url;

// 注册插件，支持注册多个插件
- (void)registerScriptPlugin:(ScriptPluginBase*)plugin callback:(PluginCallbackHandler)callback;

// 执行js
- (void)evaluateScript:(NSString*)script;

- (void)evaluateScriptByWebView:(NSString*)script;

// 调用js function
// 调用全局js方法
- (void)invokeMethod:(NSString *)method withArguments:(NSArray *)arguments;
// 调用对象上的@pramw method的方法
- (void)invokeObjectName:(NSString*)objectName method:(NSString *)method withArguments:(NSArray *)arguments;

@end
