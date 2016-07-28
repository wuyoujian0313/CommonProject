//
//  ExtendScriptPlugin.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/15.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendScriptPlugin.h"
#import "SharedManager.h"

@interface ExtendScriptPlugin ()
@property (nonatomic, strong) SharedManager         *sharedMgr;
@end

@implementation ExtendScriptPlugin

- (void)JN_ShowAlert:(NSString*)message {
    
    __weak ExtendScriptPlugin * wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:aAction2];
        
        UIApplication *app = [UIApplication sharedApplication];
        [app.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
        ExtendScriptPlugin *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            sSelf.callbackHandler(NSStringFromSelector(_cmd),PluginCallbackStatusSuccessWithoutData,nil,nil);
        }
        
    });
}

- (void)JN_SharedTitle:(NSString*)title content:(NSString *)content data:(id)data {
    
    __weak ExtendScriptPlugin *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ExtendScriptPlugin *sSelf = wSelf;
        SharedManager *obj = [[SharedManager alloc] init];
        sSelf.sharedMgr = obj;
        
        SharedDataModel *mObj = [[SharedDataModel alloc] init];
        mObj.title = title;
        mObj.content = content;
        mObj.data = data;
        
        UIApplication *app = [UIApplication sharedApplication];
        [obj sharedDataFromViewController:app.keyWindow.rootViewController withData:mObj finish:^(SharedStatusCode statusCode) {
            //
            if (sSelf.callbackHandler) {
                NSString *response = nil;
                if (statusCode == SharedStatusCodeSuccess) {
                    response = @"success";
                } else if (statusCode == SharedStatusCodeFail) {
                    response = @"fail";
                } else if (statusCode == SharedStatusCodeCancel) {
                    response = @"cancel";
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),PluginCallbackStatusSuccessWithoutData,nil,nil);
            }
        }];
    });
}

- (void)JN_Signature:(NSString*)userName {
    __weak ExtendScriptPlugin * wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ExtendScriptPlugin *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            sSelf.callbackHandler(NSStringFromSelector(_cmd),PluginCallbackStatusSuccessWithData,nil,userName);
        }
    });
}

@end
