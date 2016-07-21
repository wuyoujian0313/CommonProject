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

@property (nonatomic, copy) PluginCallbackHandler basePluginCallback;

// 加载对应的url web页面
- (void)loadWebViewForURL:(NSURL*)url;

// 注册插件，支持注册多个插件
- (void)registerScriptPlugin:(ScriptPluginBase*)plugin callback:(PluginCallbackHandler)callback;

// 执行js
- (void)evaluateScript:(NSString*)script;


@end
