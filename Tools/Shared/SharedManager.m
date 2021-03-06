//
//  SharedManager.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SharedManager.h"

#ifdef AISHARE
#import <AIBase/src/Owns/AIActionSheet.h>
#else
#import "AIActionSheet.h"
#endif

//微信平台
#import "WechatAuthSDK.h"
#import "WXApiObject.h"
#import "WXApi.h"

//QQ平台
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>


#define IS_RETINA ([UIScreen mainScreen].scale == 2.0)


typedef NS_ENUM(NSInteger, AISharedPlatformScene) {
    AISharedPlatformSceneSession,   //聊天
    AISharedPlatformSceneTimeline,  //朋友圈&空间
    AISharedPlatformSceneFavorite,  //收藏
};

@interface WXSDKCallback ()
@property (nonatomic, copy) AISharedFinishBlock        finishBlock;
@end

@implementation WXSDKCallback

#pragma mark - WXApiDelegate
- (void)dealloc {
    self.finishBlock = nil;
}

- (void)onResp:(BaseResp*)resp {
    if (_finishBlock) {
        _finishBlock(AISharedStatusCodeDone,resp);
    }
}

@end

@interface QQSDKCallback ()
@property (nonatomic, copy) AISharedFinishBlock        finishBlock;
@end

@implementation QQSDKCallback

- (void)dealloc {
    self.finishBlock = nil;
}

- (void)onResp:(QQBaseResp *)resp {
    if (_finishBlock) {
        _finishBlock(AISharedStatusCodeDone,resp);
    }
}

- (void)onReq:(QQBaseReq *)req {}
- (void)isOnlineResponse:(NSDictionary *)response {}
@end




@implementation SharedPlatformSDKInfo
+ (instancetype)platform:(AISharedPlatform)platform
                  appId:(NSString*)appId
                 secret:(NSString*)appSecret
{
    
    SharedPlatformSDKInfo *sdk = [[SharedPlatformSDKInfo alloc] init];
    sdk.platform = platform;
    sdk.appId = appId;
    sdk.appSecret = appSecret;
    return sdk;
}

@end

@interface SharedPlatformScene : NSObject
@property (nonatomic, assign) AISharedPlatform platform;
@property (nonatomic, assign) AISharedPlatformScene scene;
+ (instancetype)scene:(AISharedPlatformScene)scene platform:(AISharedPlatform)platform;
@end

@implementation SharedPlatformScene
+ (instancetype)scene:(AISharedPlatformScene)scene platform:(AISharedPlatform)platform {
    SharedPlatformScene *sharedscene = [[SharedPlatformScene alloc] init];
    sharedscene.scene = scene;
    sharedscene.platform = platform;
    return sharedscene;
}
@end

@interface SharedManager ()<AIActionSheetDelegate,TencentSessionDelegate>

@property (nonatomic, strong) AIActionSheet            *actionSheet;
@property (nonatomic, strong) NSMutableArray           *scenes;
@property (nonatomic, strong) SharedDataModel          *sharedData;
@property (nonatomic, strong) TencentOAuth             *qqOAuth;
@end

@implementation SharedManager

+ (SharedManager *)sharedSharedManager {
    static SharedManager *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (instancetype)init {
    if (self = [super init]) {
        self.wxCallback = [[WXSDKCallback alloc] init];
        self.qqCallback = [[QQSDKCallback alloc] init];
    }
    
    return self;
}

- (void)registerSharedPlatform:(NSArray<SharedPlatformSDKInfo*> *)platforms {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        for (SharedPlatformSDKInfo *item  in platforms) {
            AISharedPlatform platform = [item platform];
            
            
            
            if (platform == AISharedPlatformWechat) {
                // 微信
                
                [WXApi registerApp:[item appId] withDescription:NSStringFromClass([self class])];
                
                [self addSharedPlatformScene:[SharedPlatformScene scene:AISharedPlatformSceneSession platform:AISharedPlatformWechat]];
                [self addSharedPlatformScene:[SharedPlatformScene scene:AISharedPlatformSceneTimeline platform:AISharedPlatformWechat]];
                [self addSharedPlatformScene:[SharedPlatformScene scene:AISharedPlatformSceneFavorite platform:AISharedPlatformWechat]];
                
                
            } else if (platform == AISharedPlatformQQ) {
                //
                self.qqOAuth = [[TencentOAuth alloc] initWithAppId:[item appId] andDelegate:self];
                
                [self addSharedPlatformScene:[SharedPlatformScene scene:AISharedPlatformSceneSession platform:AISharedPlatformQQ]];
                [self addSharedPlatformScene:[SharedPlatformScene scene:AISharedPlatformSceneTimeline platform:AISharedPlatformQQ]];
            }
            
        }
    
    });
}

- (void)addSharedPlatformScene:(SharedPlatformScene*)scene {
    
    if (_actionSheet == nil) {
        self.actionSheet = [[AIActionSheet alloc] initInParentView:[UIApplication sharedApplication].keyWindow.rootViewController.view delegate:self];
        self.scenes = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    for (SharedPlatformScene*item in _scenes) {
        if (item == scene) {
            return;
        }
    }
    
    NSString *resPath = [[NSBundle mainBundle] pathForResource:@"SharedUI" ofType:@"bundle"];
    AISheetItem * item = [[AISheetItem alloc] init];
    if (scene.platform == AISharedPlatformWechat ) {
        if (scene.scene == AISharedPlatformSceneSession) {
            if (IS_RETINA) {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechat@2x.png"];
            } else {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechat.png"];
            }
            
            item.title = @"微信好友";
        } else if (scene.scene == AISharedPlatformSceneTimeline) {
            if (IS_RETINA) {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechatTimeline@2x.png"];
            } else {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechatTimeline.png"];
            }
            
            item.title = @"微信朋友圈";
        } else if (scene.scene == AISharedPlatformSceneFavorite) {
            if (IS_RETINA) {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechatFav@2x.png"];
            } else {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_wechatFav.png"];
            }
            
            item.title = @"微信收藏";
        }
    } else if (scene.platform == AISharedPlatformQQ ) {
        if (scene.scene == AISharedPlatformSceneSession) {
            if (IS_RETINA) {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_qq@2x.png"];
            } else {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_qq.png"];
            }
            
            item.title = @"QQ";
        } else if (scene.scene == AISharedPlatformSceneTimeline) {
            if (IS_RETINA) {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_qqzoom@2x.png"];
            } else {
                item.iconPath = [resPath stringByAppendingPathComponent:@"icon_qqzoom.png"];
            }
            
            item.title = @"QQ空间";
        }
    }
    
    
    [_actionSheet addActionItem:item];
    [_scenes addObject:scene];
}

- (void)sharedData:(SharedDataModel*)dataModel finish:(AISharedFinishBlock)finishBlock {
    
    self.sharedData = dataModel;
    self.wxCallback.finishBlock = finishBlock;
    self.qqCallback.finishBlock = finishBlock;
    
    if (_actionSheet) {
        [_actionSheet show];
    }
}

#pragma mark - AIActionSheetDelegate
- (void)didSelectedActionSheet:(AIActionSheet*)actionSheet buttonIndex:(NSInteger)buttonIndex {
    if (actionSheet.cancelButtonIndex != buttonIndex) {
        SharedPlatformScene *scene = [_scenes objectAtIndex:buttonIndex];
        if (scene.platform == AISharedPlatformWechat) {
            
            if (![WXApi isWXAppInstalled]) {
                if (_wxCallback.finishBlock) {
                    _wxCallback.finishBlock(AISharedStatusCodeUnintallApp,nil);
                }
                return;
            }
            
            //微信
            SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
            req.scene = scene.scene;
            
            if (_sharedData.dataType == SharedDataTypeText) {
                // 文字类型分享
                req.text = _sharedData.content;
                req.bText = YES;
            } else if (_sharedData.dataType == SharedDataTypeImage) {
                // 图片类型分享
                req.bText = NO;
                WXMediaMessage *message = [WXMediaMessage message];
                [message setThumbImage:_sharedData.thumbImage];
                
                WXImageObject *imageObject = [WXImageObject object];
                imageObject.imageData = _sharedData.imageData;
                message.mediaObject = imageObject;
                
                req.message = message;
                
            } else if (_sharedData.dataType == SharedDataTypeMusic) {
                // 音乐类型分享
                req.bText = NO;
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = _sharedData.title;
                message.description = _sharedData.content;
                [message setThumbImage:_sharedData.thumbImage];
                
                WXMusicObject *musicObject = [WXMusicObject object];
                musicObject.musicUrl = _sharedData.url;
                musicObject.musicLowBandUrl = musicObject.musicUrl;
                musicObject.musicDataUrl = musicObject.musicUrl;
                musicObject.musicLowBandDataUrl = musicObject.musicUrl;
                message.mediaObject = musicObject;
                
                req.message = message;
            } else if (_sharedData.dataType == SharedDataTypeVideo) {
                // 视频类型分享
                req.bText = NO;
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = _sharedData.title;
                message.description = _sharedData.content;
                [message setThumbImage:_sharedData.thumbImage];
                
                WXVideoObject *videoObject = [WXVideoObject object];
                videoObject.videoUrl = _sharedData.url;
                videoObject.videoLowBandUrl = _sharedData.lowBandUrl;
                message.mediaObject = videoObject;
                
                req.message = message;
            } else if (_sharedData.dataType == SharedDataTypeURL) {
                // 网页类型分享
                req.bText = NO;
                WXMediaMessage *message = [WXMediaMessage message];
                message.title = _sharedData.title;
                message.description = _sharedData.content;
                [message setThumbImage:_sharedData.thumbImage];
                
                WXWebpageObject *webpageObject = [WXWebpageObject object];
                webpageObject.webpageUrl = _sharedData.url;
                message.mediaObject = webpageObject;
                
                req.message = message;
                
            } else {
                
            }
            
            [WXApi sendReq:req];
        } else if (scene.platform == AISharedPlatformQQ) {
            //QQ
            
            if (![QQApiInterface isQQInstalled]) {
                if (_wxCallback.finishBlock) {
                    _wxCallback.finishBlock(AISharedStatusCodeUnintallApp,nil);
                }
                return;
            }
            
            if (_sharedData.dataType == SharedDataTypeText || _sharedData.dataType == SharedDataTypeURL) {
                // 文字类型分享
                NSString *text = _sharedData.dataType == SharedDataTypeText ? _sharedData.content : _sharedData.url;
                
                if (scene.scene == AISharedPlatformSceneSession) {
                    // 分享到聊天
                    QQApiTextObject* txtObj = [QQApiTextObject objectWithText:text];
                    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:txtObj];
                    QQApiSendResultCode sentCode = [QQApiInterface sendReq:req];
                    [self handleSendQQResult:sentCode];
                    
                    
                } else if (scene.scene == AISharedPlatformSceneTimeline) {
                    // 分享到空间
                    QQApiImageArrayForQZoneObject *obj = [QQApiImageArrayForQZoneObject objectWithimageDataArray:nil title:text];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
                    QQApiSendResultCode sentCode = [QQApiInterface SendReqToQZone:req];
                    [self handleSendQQResult:sentCode];
                    
                }
                
            } else if (_sharedData.dataType == SharedDataTypeImage) {
                // 图片类型分享
                if (scene.scene == AISharedPlatformSceneSession) {

                    // 分享到聊天
                    QQApiImageObject* img = [QQApiImageObject objectWithData:_sharedData.imageData previewImageData:UIImagePNGRepresentation(_sharedData.thumbImage) title:_sharedData.title description:_sharedData.content];
                    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
                    
                    QQApiSendResultCode sentCode = [QQApiInterface sendReq:req];
                    [self handleSendQQResult:sentCode];
                    
                } else if (scene.scene == AISharedPlatformSceneTimeline) {
                    
                    // 分享到空间
                    QQApiImageArrayForQZoneObject *img = [QQApiImageArrayForQZoneObject objectWithimageDataArray:[NSArray arrayWithObject:_sharedData.imageData] title:_sharedData.title];
                    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
                    QQApiSendResultCode sentCode = [QQApiInterface SendReqToQZone:req];
                    [self handleSendQQResult:sentCode];
                }
                
            } else if (_sharedData.dataType == SharedDataTypeVideo) {
                // 视频类型分享
                if (scene.scene == AISharedPlatformSceneSession) {
                    
                    // 分享到聊天
                    NSURL* url = [NSURL URLWithString:_sharedData.url];
                    QQApiNewsObject* img = [QQApiNewsObject objectWithURL:url title:_sharedData.title description:_sharedData.content previewImageData:UIImagePNGRepresentation(_sharedData.thumbImage)];
                    
                    SendMessageToQQReq* req = [SendMessageToQQReq reqWithContent:img];
                    QQApiSendResultCode sentCode = [QQApiInterface sendReq:req];
                    [self handleSendQQResult:sentCode];
                    
                } else if (scene.scene == AISharedPlatformSceneTimeline) {
                    
                    // 分享到空间
                    QQApiVideoForQZoneObject *video = [QQApiVideoForQZoneObject objectWithAssetURL:_sharedData.url title:_sharedData.title];
                    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:video];
                    QQApiSendResultCode sentCode = [QQApiInterface SendReqToQZone:req];
                    [self handleSendQQResult:sentCode];
                }
            }
        }
    }
}

- (void)handleSendQQResult:(QQApiSendResultCode)sendResult {
    switch (sendResult) {
        case EQQAPIAPPNOTREGISTED: {
            break;
        }
        case EQQAPIMESSAGECONTENTINVALID:
        case EQQAPIMESSAGECONTENTNULL:
        case EQQAPIMESSAGETYPEINVALID: {
            break;
        }
        case EQQAPIQQNOTINSTALLED: {
            break;
        }
        case EQQAPIQQNOTSUPPORTAPI: {
            if (_qqCallback.finishBlock) {
                _qqCallback.finishBlock(sendResult,nil);
            }
            break;
        }
        case EQQAPISENDFAILD: {
            break;
        }
        default:
        {
            break;
        }
    }
}

#pragma mark - TencentLoginDelegate
- (void)tencentDidLogin {}
- (void)tencentDidNotLogin:(BOOL)cancelled {}
- (void)tencentDidNotNetWork {}

@end
