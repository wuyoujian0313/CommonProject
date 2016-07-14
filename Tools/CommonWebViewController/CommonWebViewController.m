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
#import "UIWebView+JSPatch.h"


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
    
   // [CacheURLProtocol unregisterCacheURLProtocol];
}


-(void)viewWillDisappear:(BOOL)animated {
    [_progressView removeFromSuperview];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = nil;
    [self setNavTitle:self.tabBarItem.title];
//    // 注册监听
//    NSArray *ignores = @[@"http://101.69.181.210",
//                         @"http://pic22.nipic.com/20120717/9774499_115645635000_2.jpg",
//                         @"http://pic4.nipic.com/20090919/3372381_123043464790_2.jpg",
//                         @"http://www.9doo.net/__demo/jd0024/upload/b1.jpg",
//                         @"http://pic.58pic.com/58pic/13/18/50/23K58PIC38v_1024.jpg",
//                         @"http://pic2.ooopic.com/10/57/50/93b1OOOPIC4d.jpg"];
//    BOOL bSuc = [CacheURLProtocol registerProtocolWithIgnoreURLs:ignores];
//    if (bSuc) {
//        NSLog(@"CacheURLProtocol register success!");
//    }
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    [_progressView setProgress:0.0];
    [self.navigationController.navigationBar addSubview:_progressView];
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo screenWidth], [DeviceInfo screenHeight] - [DeviceInfo navigationBarHeight] - 49)];
    [_contentWebView setDelegate:_progressProxy];
    [self.view addSubview:_contentWebView];
    
#if 0
    NSURL *url = [NSURL URLWithString:@"https://www.baidu.com/"];
#else
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"template" withExtension:@"html"];
#endif
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [_contentWebView loadRequest:request];
    
    __weak CommonWebViewController *wSelf = self;
    [_contentWebView registNativeAPIInWebViewApiName:@"JSToNative" apiBlock:^(NSArray<JSValue *> *arguments) {
        //
        
        NSString *arg1 = nil;
        NSString *arg2 = nil;
        NSInteger index = 0;
        for (JSValue *jsVal in arguments) {
            NSLog(@"%@", jsVal.toString);
            if (index == 0) {
                arg1 = [NSString stringWithFormat:@"%@",jsVal.toString];
            } else if (index == 1) {
                arg2 = [NSString stringWithFormat:@"%@",jsVal.toString];
            }
            
            index ++;
        }
        
        UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:arg1 message:arg2 preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:aAction2];
        
        CommonWebViewController *sSelf = wSelf;
        [sSelf presentViewController:alertController animated:YES completion:nil];

    }];
    
    [_contentWebView registNativeAPIInWebViewApiName:@"JSToNative2" apiBlock:^(NSArray<JSValue *> *arguments) {
        
        [FadePromptView showPromptStatus:@"JSToNative2被调用" duration:2.0 finishBlock:^{
            //
        }];
    }];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"To-JS" style:UIBarButtonItemStylePlain target:self action:@selector(toJS:)];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)toJS:(UIBarButtonItem*)sender {
    
    [_contentWebView evaluateScript:@"showAlert('通过Native调用JS增加的节点');"];
    [_contentWebView evaluateScript:@"addElementNode('通过Native调用JS增加的节点');"];
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
                        [obj pickerCameraController:self type:LocalAbilityTypePickerImage_AllowsEditing finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
                            //
                        }];
                        
                        break;
                    }
                    case InvokeServerSubTypePhotograph: {
                        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
                        self.localAbilityMgr = obj;
                        [obj pickerCameraController:self type:LocalAbilityTypePickerPhotograph_AllowsEditing finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
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
