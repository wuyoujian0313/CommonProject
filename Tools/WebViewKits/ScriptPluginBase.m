//
//  ScriptPluginBase.m
//  CommonProject
//
//  Created by wuyoujian on 16/7/14.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ScriptPluginBase.h"
#import "LocalAbilityManager.h"
#import "SharedManager.h"

@interface ScriptPluginBase ()
@property (nonatomic, strong) LocalAbilityManager   *localAbilityMgr;
@property (nonatomic, strong) SharedManager         *sharedMgr;
@end

@implementation ScriptPluginBase

- (void)JN_SharedTitle:(NSString*)title content:(NSString *)content data:(id)data {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        ScriptPluginBase *sSelf = wSelf;
        SharedManager *obj = [[SharedManager alloc] init];
        sSelf.sharedMgr = obj;
        
        SharedDataModel *mObj = [[SharedDataModel alloc] init];
        mObj.title = @"title";
        mObj.content = @"content";
        mObj.data = @"www.baidu.com";

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
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
            }
        }];
    });
    
    
}


- (void)JN_EmailSubject:(NSString*)subject content:(NSString*)content {
    
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    UIApplication *app = [UIApplication sharedApplication];
    
    __weak ScriptPluginBase *wSelf = self;
    [obj pickerMailSMSController:app.keyWindow.rootViewController type:LocalAbilityTypeMail andSubject:subject andContent:content finish:^(SendType type, SendStatus status) {
        //
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            NSString *response = nil;
            if (status == SendStatusSuccess) {
                response = @"success";
            } else if (status == SendStatusFail) {
                response = @"fail";
            } else if (status == SendStatusCancel) {
                response = @"cancel";
            } else if (status == SendStatusSave) {
                response = @"save";
            }
            
            sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
        }
    }];
}


- (void)JN_SMSContent:(NSString*)content {
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    UIApplication *app = [UIApplication sharedApplication];
    
    __weak ScriptPluginBase *wSelf = self;
    [obj pickerMailSMSController:app.keyWindow.rootViewController type:LocalAbilityTypeSMS andSubject:nil andContent:content finish:^(SendType type, SendStatus status) {
        //
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            NSString *response = nil;
            if (status == SendStatusSuccess) {
                response = @"success";
            } else if (status == SendStatusFail) {
                response = @"fail";
            } else if (status == SendStatusCancel) {
                response = @"cancel";
            } else if (status == SendStatusSave) {
                response = @"save";
            }
            
            sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
        }
    }];
}

- (void)JN_DailPhoneNumber:(NSString*)phoneNumber {
    
    __weak ScriptPluginBase *wSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        [LocalAbilityManager telephoneToNumber:phoneNumber];
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            sSelf.callbackHandler(NSStringFromSelector(_cmd),@"success");
        }
    });
}


- (void)JN_SelectImageAllowsEditing:(BOOL)isEditing {
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    UIApplication *app = [UIApplication sharedApplication];
    
    LocalAbilityType type = isEditing ? LocalAbilityTypePickerImage_AllowsEditing : LocalAbilityTypePickerImage_ForbidEditing;
    
    __weak ScriptPluginBase *wSelf = self;
    [obj pickerCameraController:app.keyWindow.rootViewController type:type finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
        //
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            NSString *response = nil;
            if (status == ImagePickerStatusSuccess) {
                response = @"success";
            } else if (status == ImagePickerStatusFail) {
                response = @"fail";
            } else if (status == ImagePickerStatusCancel) {
                response = @"cancel";
            }
            
            sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
        }
    }];
}


- (void)JN_PhotographAllowsEditing:(BOOL)isEditing {
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    UIApplication *app = [UIApplication sharedApplication];
    
    LocalAbilityType type = isEditing ? LocalAbilityTypePickerPhotograph_AllowsEditing : LocalAbilityTypePickerPhotograph_ForbidEditing;
    
    __weak ScriptPluginBase *wSelf = self;
    [obj pickerCameraController:app.keyWindow.rootViewController type:type finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
        //
        
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            NSString *response = nil;
            if (status == ImagePickerStatusSuccess) {
                response = @"success";
            } else if (status == ImagePickerStatusFail) {
                response = @"fail";
            } else if (status == ImagePickerStatusCancel) {
                response = @"cancel";
            }
            
            sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
        }
    }];
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
                NSString *response = nil;
                if (status == ImagePickerStatusSuccess) {
                    response = @"success";
                } else if (status == ImagePickerStatusFail) {
                    response = @"fail";
                } else if (status == ImagePickerStatusCancel) {
                    response = @"cancel";
                }
                
                sSelf.callbackHandler(NSStringFromSelector(_cmd),data);
            }
        }];
    });
}

- (void)JN_Videotape {
    
    LocalAbilityManager *obj = [[LocalAbilityManager alloc] init];
    self.localAbilityMgr = obj;
    UIApplication *app = [UIApplication sharedApplication];
    __weak ScriptPluginBase *wSelf = self;
    [obj pickerCameraController:app.keyWindow.rootViewController type:LocalAbilityTypePickerVideotape finish:^(ImagePickerType type, ImagePickerStatus status, id data) {
        //
        ScriptPluginBase *sSelf = wSelf;
        if (sSelf.callbackHandler) {
            NSString *response = nil;
            if (status == ImagePickerStatusSuccess) {
                response = @"success";
            } else if (status == ImagePickerStatusFail) {
                response = @"fail";
            } else if (status == ImagePickerStatusCancel) {
                response = @"cancel";
            }
            
            sSelf.callbackHandler(NSStringFromSelector(_cmd),response);
        }
    }];
}

@end
