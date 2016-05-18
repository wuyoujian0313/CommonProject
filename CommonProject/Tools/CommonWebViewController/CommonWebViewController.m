//
//  CommonWebViewController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "CommonWebViewController.h"

#import "LocalAbilityManager.h"
#import "PayManager.h"
#import "SharedManager.h"
#import "URLParseManager.h"


@interface CommonWebViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView             *contentWebView;
@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@property (nonatomic, strong) PayManager            *payMgr;
@property (nonatomic, strong) SharedManager         *sharedMgr;
@end

@implementation CommonWebViewController

-(void)dealloc {
    _localAbilityMgr = nil;
    _payMgr = nil;
    _sharedMgr = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self setNavTitle:@"WebView"];
    
    self.contentWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, [DeviceInfo navigationBarHeight], [DeviceInfo getScreenSize].width, [DeviceInfo getScreenSize].height - [DeviceInfo navigationBarHeight])];
    
    [_contentWebView setDelegate:self];
    
    NSString *htmlPath = [[NSBundle mainBundle] pathForResource:@"template" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
//    NSURL *url = [NSURL URLWithString:_urlString];
//    [_contentWebView loadRequest:[NSURLRequest requestWithURL:url]];
   [_contentWebView loadHTMLString:htmlString baseURL:nil];
    [self.view addSubview:_contentWebView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error {
    
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
