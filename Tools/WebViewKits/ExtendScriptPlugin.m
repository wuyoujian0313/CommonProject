//
//  ExtendScriptPlugin.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/15.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ExtendScriptPlugin.h"

@implementation ExtendScriptPlugin

- (void)JN_ShowAlert:(NSString*)message {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        UIAlertAction *aAction2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            //
        }];
        //
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"标题" message:message preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:aAction2];
        
        UIApplication *app = [UIApplication sharedApplication];
        [app.keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
        
    });
}

@end
