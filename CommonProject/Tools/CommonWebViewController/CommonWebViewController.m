//
//  CommonWebViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "CommonWebViewController.h"
#import "NJKWebViewProgress.h"
#import "NJKWebViewProgressView.h"
#import "LocalAbilityManager.h"
#import "PayManager.h"
#import "SharedManager.h"
#import "URLParseManager.h"
#import "CacheURLProtocol.h"


@interface CommonWebViewController ()<UIWebViewDelegate,NJKWebViewProgressDelegate>
@property (nonatomic, strong) UIWebView             *contentWebView;
@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@property (nonatomic, strong) PayManager            *payMgr;
@property (nonatomic, strong) SharedManager         *sharedMgr;

@property (nonatomic, strong) NJKWebViewProgressView    *progressView;
@property (nonatomic, strong) NJKWebViewProgress        *progressProxy;
@end

@implementation CommonWebViewController

-(void)dealloc {
    _localAbilityMgr = nil;
    _payMgr = nil;
    _sharedMgr = nil;
    
    [CacheURLProtocol unregisterCacheURLProtocol];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 注册监听
    BOOL bSuc = [CacheURLProtocol registerCacheURLProtocol];
    if (bSuc) {
        NSLog(@"CacheURLProtocol register success!");
    }

    [self setNavTitle:@"WebView"];
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [_progressView setProgress:0.0];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo getScreenSize].width, [DeviceInfo getScreenSize].height - [DeviceInfo navigationBarHeight])];
    [_contentWebView setDelegate:_progressProxy];
    
#if 1
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
    [_contentWebView loadRequest:[NSURLRequest requestWithURL:url]];
#else
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    [_contentWebView loadHTMLString:htmlString baseURL:nil];
#endif
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
    
    if ([URLParseManager isCustomURL:request.URL]) {
        //
        [URLParseManager urlParseWithURL:request.URL finish:^(InvokeServerType serverType, InvokeServerSubType subType, NSDictionary *param) {
            //
            if (serverType == InvokeServerTypeLocalAbility) {
                //
                switch (subType) {
                    case InvokeServerSubTypeBaiduMap:
                        break;
                    case InvokeServerSubTypeSelectImage: {
                        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
                        self.localAbilityMgr = obj;
                        [obj pickerCameraController:self type:LocalAbilityTypePickerImage finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
                            //
                        }];
                        
                        break;
                    }
                    case InvokeServerSubTypePhotograph: {
                        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
                        self.localAbilityMgr = obj;
                        [obj pickerCameraController:self type:LocalAbilityTypePickerPhotograph finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
                            //
                        }];
                        break;
                    }
                    case InvokeServerSubTypeVideotape: {
                        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
                        self.localAbilityMgr = obj;
                        [obj pickerCameraController:self type:LocalAbilityTypePickerVideotape finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
                            //
                        }];
                        break;
                    }
                    case InvokeServerSubTypeScanQRCode:{
                        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
                        self.localAbilityMgr = obj;
                        [obj pickerCameraController:self type:LocalAbilityTypePickerScanQRCode finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
                            //
                        }];
                        break;
                    }
                    case InvokeServerSubTypeGenerateQRCode: {
                        [LocalAbilityManager generateQRCode:@"wuyoujian" width:100 height:100];
                    }
                        break;
                        
                    default:
                        break;
                }
                
            } else if(serverType == InvokeServerTypeShared) {
                if (subType == InvokeServerSubTypeShared) {
                    //
                    SharedManager *obj = [[SharedManager alloc] init];
                    self.sharedMgr = obj;
                    
                    SharedDataModel *mObj = [[SharedDataModel alloc] init];
                    mObj.title = @"title";
                    mObj.content = @"content";
                    mObj.data = @"www.baidu.com";
                    
                    [obj sharedDataFromViewController:self withData:mObj finish:^(SharedStatusCode statusCode) {
                        //
                    }];
                }
                
            } else if (serverType == InvokeServerTypePay) {
                
                switch (subType) {
                    case InvokeServerSubTypeWXPay:
                        break;
                    case InvokeServerSubTypeAlipay:
                        break;
                        
                    default:
                        break;
                }
                
            }
        }];
        return NO;
    }
    
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
