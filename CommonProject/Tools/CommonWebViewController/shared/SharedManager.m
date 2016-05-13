//
//  SharedManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "SharedManager.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "WXApi.h"

#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDKUI/SSUIShareActionSheetStyle.h>
#import <ShareSDKUI/SSUIShareActionSheetCustomItem.h>
#import <ShareSDK/ShareSDK+Base.h>

// 分享相关
#define ShareSDKAppKey              @"e7d5f19efdb0"

#define QQSDKAppKey                 @"alkvsxWc7Eh7GwGk"
#define QQSDKAppId                  @"1105106734"

#define WeiXinSDKAppSecret          @"dce5699086e990df3104052ce298f573"
#define WeiXinSDKAppId              @"wx7a296d05150143e5"


@interface SharedManager ()

@property(nonatomic, copy) SharedFinishBlock        finishBlock;
@end

@implementation SharedManager


- (instancetype)init {
    
    if (self = [super init]) {
        //只需要注册一次
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self registerShareSDK];
            NSLog(@"dispatch_once");
        });
    }
    
    return self;
}

- (void)registerShareSDK {
    
    [ShareSDK registerApp:ShareSDKAppKey
          activePlatforms:@[@(SSDKPlatformTypeQQ),@(SSDKPlatformTypeWechat)]
                 onImport:^(SSDKPlatformType platformType) {
                     
                     switch (platformType) {
                         case SSDKPlatformTypeWechat:
                             [ShareSDKConnector connectWeChat:[WXApi class] delegate:self];
                             break;
                         case SSDKPlatformTypeQQ:
                             [ShareSDKConnector connectQQ:[QQApiInterface class]
                                        tencentOAuthClass:[TencentOAuth class]];
                             break;
                             
                         default:
                             break;
                     }
                 }
          onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
              
              switch (platformType) {
                  case SSDKPlatformTypeWechat:
                      [appInfo SSDKSetupWeChatByAppId:WeiXinSDKAppId
                                            appSecret:WeiXinSDKAppSecret];
                      break;
                  case SSDKPlatformTypeQQ:
                      [appInfo SSDKSetupQQByAppId:QQSDKAppId
                                           appKey:QQSDKAppKey
                                         authType:SSDKAuthTypeBoth];
                      break;
                  default:
                      break;
              }
          }];
}

- (void)shared2OpenPlatformWithView:(UIView*)view withData:(SharedDataModel*)dataModel sharedWay:(SharedWayType)wayType {
    
    //1、创建分享参数
    NSString *title = dataModel.title;
    NSString *url = dataModel.data;
    NSString *content = dataModel.content;
    UIImage *image = [UIImage imageFromColor:[UIColor grayColor]];
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:content
                                     images:image
                                        url:[NSURL URLWithString:url]
                                      title:title
                                       type:SSDKContentTypeAuto];
    
    //2、分享（可以弹出我们的分享菜单和编辑界面）
    [ShareSDK showShareActionSheet:view
                             items:nil
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                       case SSDKResponseStateBegin: {
                           
                           break;
                       }
                           
                           
                       case SSDKResponseStateSuccess: {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                           
                       case SSDKResponseStateFail: {
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                           
                       case SSDKResponseStateCancel: {
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           break;
                       }
                       default:
                           break;
                   }
               }
     ];
}

- (void)sharedDataFromViewController:(UIViewController*)viewController withData:(SharedDataModel*)dataModel sharedWay:(SharedWayType)wayType finish:(SharedFinishBlock)finishBlock {
    
    self.finishBlock = finishBlock;
    [self shared2OpenPlatformWithView:viewController.view withData:dataModel sharedWay:wayType];
}

@end
