//
//  WebViewKitController.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#ifdef AIBASEFRAMEWORK_INDEVELOPING
#import "AIBaseFramework.h"

#else
#import <AIBaseFramework/AIBaseFramework.h>
#endif

#import "ScriptPluginBase.h"

@interface WebViewKitController : BaseVC

// 加载对应的url web页面
- (void)loadWebViewForURL:(NSString*)urlString;

// 注册插件，支持注册多个插件
- (void)registerScriptPlugin:(ScriptPluginBase*)plugin callback:(NativeCallbackHandler)callback;

// 执行js
- (void)evaluateScript:(NSString*)script;


@end
