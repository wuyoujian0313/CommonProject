//
//  ScriptPluginBase.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef void(^NativeCallbackHandler)(NSString *apiName, id response);


@protocol JN_LocalAbilityExport <JSExport>

JSExportAs(JN_Shared,- (void)JN_SharedTitle:(NSString*)title content:(NSString *)content data:(id)data);
JSExportAs(JN_Email,- (void)JN_EmailSubject:(NSString*)subject content:(NSString*)content);


- (void)JN_SMSContent:(NSString*)content;
- (void)JN_DailPhoneNumber:(NSString*)phoneNumber;
- (void)JN_SelectImageAllowsEditing:(BOOL)isEditing;
- (void)JN_PhotographAllowsEditing:(BOOL)isEditing;
- (void)JN_ScanQRCode;
- (void)JN_Videotape;

@end

@interface ScriptPluginBase : NSObject<JN_LocalAbilityExport>
@property (nonatomic, copy) NativeCallbackHandler        callbackHandler;
@end
