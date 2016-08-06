//
//  AIConfiguration.m
//  CRMMobile_TJ
//
//  Created by wuyoujian on 16/8/2.
//  Copyright © 2016年 Asiainfo. All rights reserved.
//

#import "AIConfiguration.h"

@implementation AIConfiguration

// @param name 配置文件名
+ (NSDictionary *)configurationName:(NSString*)name {
    
    // 兼容:只传入文件名，不带后缀
    NSString *ext = ([name pathExtension] == nil || [[name pathExtension] length] == 0) ? @"properties":[name pathExtension];
    
    NSString *fileName = [name stringByDeletingPathExtension];
    
    NSURL *proURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:ext];
    NSString *configString = [NSString stringWithContentsOfURL:proURL encoding:NSUTF8StringEncoding error:nil];
    
    return [[self class] configurationString:configString];
}

// @param configData 配置文件数据
+ (NSDictionary *)configurationData:(NSData*)configData {
    
    NSString *configString = [[NSString alloc] initWithData:configData encoding:NSUTF8StringEncoding];
    return [[self class] configurationString:configString];
}

// @param configString 配置文件数据
+ (NSDictionary *)configurationString:(NSString*)configString {
    
    NSArray *pros = [configString componentsSeparatedByString:@"\n"];
    NSMutableDictionary *config = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *item in pros) {
        NSArray *kv = [item componentsSeparatedByString:@"="];
        if ([kv count] == 2) {
            [config setObject:[kv objectAtIndex:1] forKey:[kv objectAtIndex:0]];
        }
    }
    
    return config;
}

@end
