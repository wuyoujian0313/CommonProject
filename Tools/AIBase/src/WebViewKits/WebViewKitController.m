//
//  WebViewKitController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "WebViewKitController.h"
#import "../NJKWebViewProgress/NJKWebViewProgress.h"
#import "../NJKWebViewProgress/NJKWebViewProgressView.h"
#import "../Category/UIWebView+JSPatch.h"
#import "../Owns/DeviceInfo.h"


@interface WebViewKitController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView                         *contentWebView;
@property (nonatomic, strong) NJKWebViewProgressView            *progressView;
@property (nonatomic, strong) NJKWebViewProgress                *progressProxy;

@property (nonatomic, strong) NSMutableArray                    *extendPlugins;
@property (nonatomic, strong) NSMutableArray<JSManagedValue*>   *extendJSManagedValues;

@end

@implementation WebViewKitController


- (void)dealloc {
    
    for (JSManagedValue* obj in _extendJSManagedValues) {
        [[_contentWebView webViewContext].virtualMachine removeManagedReference:obj withOwner:self];
    }
}

// 加载对应的url web页面
- (void)loadWebViewForURL:(NSURL*)url {
    
    [self layoutWebView];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_contentWebView loadRequest:request];
}

- (void)registerScriptPlugin:(ScriptPluginBase*)plugin callback:(PluginCallbackHandler)callback {
    if (!_contentWebView) {
        assert(@"WebView未加载数据");
    }
    
    if (plugin) {
        
        if (!_extendPlugins) {
            self.extendPlugins = [[NSMutableArray alloc] initWithCapacity:0];
            self.extendJSManagedValues = [[NSMutableArray alloc] initWithCapacity:0];
        } else {
            if ([_extendPlugins containsObject:plugin]) {
                // 已经注册过的插件跳过
                return;
            }
        }
        
        plugin.callbackHandler = callback;
        [_extendPlugins addObject:plugin];
        
        
        JSValue *obj = [_contentWebView webViewContext][NSStringFromClass([plugin class])];
        if (obj == nil || [obj isUndefined]) {
            [_contentWebView webViewContext][NSStringFromClass([plugin class])] = plugin;
            
            // 内存管理
            JSManagedValue* extendJSManagedValue = [JSManagedValue managedValueWithValue:obj];
            [[_contentWebView webViewContext].virtualMachine addManagedReference:extendJSManagedValue withOwner:self];
            [_extendJSManagedValues addObject:extendJSManagedValue];
        }
    }
}

- (void)evaluateScript:(NSString*)script {
    if (_contentWebView) {
        [_contentWebView evaluateScript:script];
    }
}

- (void)evaluateScriptByWebView:(NSString*)script {
    if (_contentWebView) {
        [_contentWebView evaluateScriptByWebView:script];
    }
}

- (void)invokeMethod:(NSString *)method withArguments:(NSArray *)arguments {
    JSValue *methodObj = [_contentWebView webViewContext][method];
    if (![methodObj isUndefined]) {
        [methodObj callWithArguments:arguments];
    } else {
        NSLog(@"JS方法：%@ 不存在",method);
    }
}

- (void)invokeObjectName:(NSString*)objectName method:(NSString *)method withArguments:(NSArray *)arguments {
    
    JSValue *obj = [_contentWebView webViewContext][objectName];
    if (![obj isUndefined]) {
        JSValue *methodObj = obj[method];
        if (![methodObj isUndefined]) {
            [methodObj callWithArguments:arguments];
        } else {
            NSLog(@"JS对象：%@ 的方法%@ 不存在",objectName,method);
        }
    } else {
        NSLog(@"JS对象：%@ 不存在",objectName);
    }
}

- (void)layoutWebView {
    
    if (!_contentWebView) {
        
        CGFloat navHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        if (self.navigationController && ![self.navigationController isNavigationBarHidden]) {
            CGFloat progressBarHeight = 2.f;
            CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
            CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
            self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
            [_progressView setProgress:0.0];
            [self.navigationController.navigationBar addSubview:_progressView];
            
            navHeight = [DeviceInfo navigationBarHeight];
        }
        
        CGFloat tabHeight = 0;
        if (self.navigationController && !self.hidesBottomBarWhenPushed) {
            tabHeight = self.tabBarController.tabBar.frame.size.height;
        }
        
        CGFloat toolHeight = 0;
        if (self.navigationController && ![self.navigationController isToolbarHidden]) {
            toolHeight = self.navigationController.toolbar.frame.size.height;
        }
        
        self.progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight - tabHeight - toolHeight)];
        [_contentWebView setDelegate:_progressProxy];
        [self.view addSubview:_contentWebView];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [_progressView removeFromSuperview];
}

- (void)viewWillLayoutSubviews {
    
    if (!_contentWebView) {
        
        CGFloat navHeight = [UIApplication sharedApplication].statusBarFrame.size.height;
        if (self.navigationController && ![self.navigationController isNavigationBarHidden]) {
            CGFloat progressBarHeight = 2.f;
            CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
            CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
            [_progressView setFrame:barFrame];
            
            navHeight = [DeviceInfo navigationBarHeight];
        }
        
        CGFloat tabHeight = 0;
        if (self.tabBarController) {
            tabHeight = self.tabBarController.tabBar.frame.size.height;
        }
        
        CGFloat toolHeight = 0;
        if (self.navigationController && ![self.navigationController isToolbarHidden]) {
            toolHeight = self.navigationController.toolbar.frame.size.height;
        }
        
        [_contentWebView setFrame:CGRectMake(0, navHeight, self.view.frame.size.width, self.view.frame.size.height - navHeight - tabHeight - toolHeight)];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self layoutWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress {
    if (progress < 0.1) {
        // [_progressView setProgress:0.1 animated:YES];
    } else {
        [_progressView setProgress:progress animated:YES];
    }
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {

    if (_delegate && [_delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        //
       return [_delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [_delegate webViewDidStartLoad:webView];
    }
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressView setProgress:0.0];
    
    for (ScriptPluginBase *plugin in _extendPlugins) {
        
        JSValue *obj = [_contentWebView webViewContext][NSStringFromClass([plugin class])];
        if (obj == nil || [obj isUndefined]) {
            [_contentWebView webViewContext][NSStringFromClass([plugin class])] = plugin;
            
            // 内存管理
            JSManagedValue* extendJSManagedValue = [JSManagedValue managedValueWithValue:obj];
            [[_contentWebView webViewContext].virtualMachine addManagedReference:extendJSManagedValue withOwner:self];
            [_extendJSManagedValues addObject:extendJSManagedValue];
        }
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [_delegate webViewDidFinishLoad:webView];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [_progressView setProgress:0.0];
    
    if (_delegate && [_delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [_delegate webView:webView didFailLoadWithError:error];
    }
}

@end

