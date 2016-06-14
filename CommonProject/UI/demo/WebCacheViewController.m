//
//  WebCacheViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "WebCacheViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "CacheURLProtocol.h"


@interface WebCacheViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView             *contentWebView;

@property (nonatomic, strong) NJKWebViewProgressView    *progressView;
@property (nonatomic, strong) NJKWebViewProgress        *progressProxy;
@end

@implementation WebCacheViewController

-(void)dealloc {
    [CacheURLProtocol unregisterCacheURLProtocol];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle:@"WebView Cached"];
    // 注册监听
    BOOL bSuc = [CacheURLProtocol registerCacheURLProtocol];
    if (bSuc) {
        NSLog(@"CacheURLProtocol register success!");
    }
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [_progressView setProgress:0.0];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight])];
    [_contentWebView setDelegate:_progressProxy];
    
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    [_contentWebView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:_contentWebView];
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
