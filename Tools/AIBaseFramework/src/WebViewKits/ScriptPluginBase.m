//
//  ScriptPluginBase.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScriptPluginBase.h"
#import "../Owns/LocalAbilityManager.h"


@interface ScriptPluginBase ()
@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@end

@implementation ScriptPluginBase

- (void)JN_EmailSubject:(NSString*)subject content:(NSString*)content {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ScriptPluginBase *sSelf = wSelf;
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];
        
        [obj pickerMailSMSController:app.keyWindow.rootViewController type:LocalAbilityTypeMail andSubject:subject andContent:content finish:^(SendType type, SendStatus status) {
            //
            
            
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithoutData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                } else if (status == SendStatusSave) {
                    status = PluginCallbackStatusSave;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,nil);
            }
        }];
    });
}


- (void)JN_SMSContent:(NSString*)content {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        ScriptPluginBase *sSelf = wSelf;
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];
        
        [obj pickerMailSMSController:app.keyWindow.rootViewController type:LocalAbilityTypeSMS andSubject:nil andContent:content finish:^(SendType type, SendStatus status) {
            //
            
            
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithoutData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                } else if (status == SendStatusSave) {
                    status = PluginCallbackStatusSave;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,nil);
            }
        }];
    });
}

- (void)JN_DailPhoneNumber:(NSString*)phoneNumber {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LocalAbilityManager telephoneToNumber:phoneNumber];
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            sSelf.callbackHandler(NSStringFromSelector(_cmd),PluginCallbackStatusSuccessWithoutData,nil);
        }
    });
}


- (void)JN_SelectImageAllowsEditing:(BOOL)isEditing {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        ScriptPluginBase *sSelf = wSelf;
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];
        
        LocalAbilityType type = isEditing ? LocalAbilityTypePickerImage_AllowsEditing : LocalAbilityTypePickerImage_ForbidEditing;
        
        [obj pickerCameraController:app.keyWindow.rootViewController type:type finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,data);
            }
        }];
    });
}


- (void)JN_PhotographAllowsEditing:(BOOL)isEditing {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        ScriptPluginBase *sSelf = wSelf;
        
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];
        
        LocalAbilityType type = isEditing ? LocalAbilityTypePickerPhotograph_AllowsEditing : LocalAbilityTypePickerPhotograph_ForbidEditing;
        
        [obj pickerCameraController:app.keyWindow.rootViewController type:type finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,data);
            }
        }];
    });
}

- (void)JN_ScanQRCode {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        //
        ScriptPluginBase *sSelf = wSelf;
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];
        [obj pickerCameraController:app.keyWindow.rootViewController type:LocalAbilityTypePickerScanQRCode finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,data);
            }
        }];
    });
}

- (void)JN_Videotape {
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ScriptPluginBase *sSelf = wSelf;
        LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
        sSelf.localAbilityMgr = obj;
        UIApplication *app = [UIApplication sharedApplication];

        [obj pickerCameraController:app.keyWindow.rootViewController type:LocalAbilityTypePickerVideotape finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
            //
            
            if (sSelf.callbackHandler) {
                PluginCallbackStatus status = PluginCallbackStatusNone;
                if (status == SendStatusSuccess) {
                    status = PluginCallbackStatusSuccessWithData;
                } else if (status == SendStatusFail) {
                    status = PluginCallbackStatusFail;
                } else if (status == SendStatusCancel) {
                    status = PluginCallbackStatusCancel;
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),status,data);
            }
        }];
    });
}

@end
