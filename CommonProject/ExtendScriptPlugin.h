//
//  ExtendScriptPlugin.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/15.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ScriptPluginBase.h"

/**
 *  扩展插件类
 *  1、JSExport是JS与OC之间的穿梭机；
 *  2、把需要扩展的API定义到protocol:JSExport里，在插件类里实现接口；
 *  3、若是多参数的API，可以采用JSExportAs来声明接口,可以参考ScriptPluginBase；默认的情况，在JS端是会把参数tag首字母大写拼接成JS的function调用方式，例如：test:(NString*)str key:(NString*)k --> testKey(str,k);
 *  4、注意，扩张的API，建议采用dispatch_async包装起来，在主线程里调用。很多情况，jscontext是非主线程调用API；
 */

@protocol JN_ExtendPluginExport <JSExport>
- (void)JN_ShowAlert:(NSString*)message;
- (void)JN_Signature:(NSString*)userName;
@end

@interface ExtendScriptPlugin : ScriptPluginBase<JN_ExtendPluginExport>

@end
