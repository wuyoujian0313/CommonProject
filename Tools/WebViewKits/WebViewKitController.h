//
//  WebViewKitController.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "BaseVC.h"
#import "ScriptPluginBase.h"

@interface WebViewKitController : BaseVC

// 加载对应的url web页面
- (void)loadWebViewForURL:(NSString*)urlString;

- (void)registerScriptPlugin:(ScriptPluginBase*)plugin;

@end
