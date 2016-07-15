//
//  WebViewKitController.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "WebViewKitController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "CacheURLProtocol.h"
#import "UIWebView+JSPatch.h"
#import "ScriptPluginBase.h"


@interface WebViewKitController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView                 *contentWebView;
@property (nonatomic, strong) NJKWebViewProgressView    *progressView;
@property (nonatomic, strong) NJKWebViewProgress        *progressProxy;

@property (nonatomic, strong) ScriptPluginBase          *basePlugin;
@property (nonatomic, strong) ScriptPluginBase          *extendPlugin;



@end

@implementation WebViewKitController


// 加载对应的url web页面
- (void)loadWebViewForURL:(NSString*)urlString {
    
    [self layoutWebView];
    
#if 0
    NSURL *url = [NSURL URLWithString:urlString];
#else
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"html"];
#endif
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_contentWebView loadRequest:request];
    
    ScriptPluginBase *basePlugin = [[ScriptPluginBase alloc] init];
    self.basePlugin = basePlugin;
    
    [_contentWebView webViewContext][NSStringFromClass([basePlugin class])] = _basePlugin;
    _basePlugin.callbackHandler = ^(NSString *apiName, id response) {
        
        if ([apiName isEqualToString:@"JN_SharedTitle:content:data:"]) {
            
        } else if ([apiName isEqualToString:@"JN_SharedTitle:content:data:"]) {
            
        } else if ([apiName isEqualToString:@"JN_EmailSubject:content:"]) {
            
        } else if ([apiName isEqualToString:@"JN_SMSContent:"]) {
            
        } else if ([apiName isEqualToString:@"JN_DailPhoneNumber:"]) {
            
        } else if ([apiName isEqualToString:@"JN_SelectImageAllowsEditing:"]) {
            
        } else if ([apiName isEqualToString:@"JN_PhotographAllowsEditing:"]) {
            
        } else if ([apiName isEqualToString:@"JN_ScanQRCode:"]) {
            
        } else if ([apiName isEqualToString:@"JN_Videotape:"]) {
            
        }
    };
}

- (void)registerScriptPlugin:(ScriptPluginBase*)plugin callback:(NativeCallbackHandler)callback {
    if (!_contentWebView) {
        assert(@"WebView未加载数据");
    }
    
    if (plugin) {
        self.extendPlugin = plugin;
        _extendPlugin.callbackHandler = callback;
        [_contentWebView webViewContext][NSStringFromClass([_extendPlugin class])] = _extendPlugin;
    }
}

- (void)evaluateScript:(NSString*)script {
    if (_contentWebView) {
        [_contentWebView evaluateScript:script];
    }
}


- (void)dealloc {
    // [CacheURLProtocol unregisterCacheURLProtocol];
}

- (void)viewWillDisappear:(BOOL)animated {
    [_progressView removeFromSuperview];
}


- (void)layoutWebView {
    
    if (!_contentWebView) {
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        self.progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        [_progressView setProgress:0.0];
        [self.navigationController.navigationBar addSubview:_progressView];
        
        self.progressProxy = [[NJKWebViewProgress alloc] init];
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight] - 49)];
        [_contentWebView setDelegate:_progressProxy];
        [self.view addSubview:_contentWebView];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavTitle:@"WebView"];
    [self layoutWebView];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"To-JS" style:UIBarButtonItemStylePlain target:self action:@selector(toJS:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)toJS:(UIBarButtonItem*)sender {
    
    [self evaluateScript:@"showAlert('通过Native调用JS增加的节点');"];
    [self evaluateScript:@"addElementNode('通过Native调用JS增加的节点');"];
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
    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_progressView setProgress:0.0];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    [_progressView setProgress:0.0];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end

