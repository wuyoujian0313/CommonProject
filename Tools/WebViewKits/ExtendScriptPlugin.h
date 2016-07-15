//
//  ExtendScriptPlugin.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/15.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ScriptPluginBase.h"

@protocol JN_ExtendPluginExport <JSExport>

- (void)JN_ShowAlert:(NSString*)message;

@end

@interface ExtendScriptPlugin : ScriptPluginBase<JN_ExtendPluginExport>

@end
