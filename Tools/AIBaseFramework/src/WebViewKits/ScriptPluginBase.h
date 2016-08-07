//
//  ScriptPluginBase.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

typedef NS_ENUM(NSInteger, PluginCallbackStatus) {
    PluginCallbackStatusNone,
    PluginCallbackStatusSuccessWithData,
    PluginCallbackStatusSuccessWithoutData,
    PluginCallbackStatusFail,
    PluginCallbackStatusCancel,
    PluginCallbackStatusSave,
};


/*
 @param apiName, OC下的函数名
 @param status, 状态
 @param response, 插件获取的数据，例如，拍照的图片，选择的图片，视频URL等等
 @param argument1, 从JS传过来的第一个参数
 @param argument2, 从JS传过来的第二个参数
 
 注意！！！！
 1、多余2个参数的JS函数，就请在回调里遍历后面的参数；
 2、这种不定参数的回调，调用时，必须最后传入个nil参数；
 */

typedef void(^PluginCallbackHandler)(NSString *apiName, PluginCallbackStatus status, id response, id argument1,id argument2,...);



@protocol JN_LocalAbilityExport <JSExport>

JSExportAs(JN_Email,- (void)JN_EmailSubject:(NSString*)subject content:(NSString*)content);

- (void)JN_SMSContent:(NSString*)content;
- (void)JN_DailPhoneNumber:(NSString*)phoneNumber;

JSExportAs(JN_SelectImage,- (void)JN_SelectImageAllowsEditing:(BOOL)isEditing argument:(NSString*)argument);

JSExportAs(JN_Photograph,- (void)JN_PhotographAllowsEditing:(BOOL)isEditing argument:(NSString*)argument);

- (void)JN_ScanQRCodeForArgument:(NSString*)argument;
- (void)JN_VideotapeForArgument:(NSString*)argument;

@end

@interface ScriptPluginBase : NSObject<JN_LocalAbilityExport>
@property (nonatomic, copy) PluginCallbackHandler        callbackHandler ;
@end
