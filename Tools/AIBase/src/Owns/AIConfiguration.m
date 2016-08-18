//
//  AIConfiguration.m
//  CRMMobile_TJ
//
//  Created by wuyoujian on 16/8/2.
//  Copyright © 2016年 Asiainfo. All rights reserved.
//

#import "AIConfiguration.h"

@interface AIConfiguration ()
@property (nonatomic, strong) NSDictionary *config;
@end

@implementation AIConfiguration

+ (AIConfiguration *)sharedConfiguration {
    
    static AIConfiguration *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

// @param name 配置文件名
- (NSDictionary *)configurationName:(NSString*)name {
    
    if (self.config && [self.config count] > 0) {
        return _config;
    }
    
    // 兼容:只传入文件名，不带后缀
    NSString *ext = ([name pathExtension] == nil || [[name pathExtension] length] == 0) ? @"properties":[name pathExtension];
    
    NSString *fileName = [name stringByDeletingPathExtension];
    
    NSURL *proURL = [[NSBundle mainBundle] URLForResource:fileName withExtension:ext];
    NSString *configString = [NSString stringWithContentsOfURL:proURL encoding:NSUTF8StringEncoding error:nil];
    
    return [self configurationString:configString];
}

// @param configData 配置文件数据
- (NSDictionary *)configurationData:(NSData*)configData {
    
    if (self.config && [self.config count] > 0) {
        return _config;
    }
    
    NSString *configString = [[NSString alloc] initWithData:configData encoding:NSUTF8StringEncoding];
    return [self configurationString:configString];
}

// @param configString 配置文件数据
- (NSDictionary *)configurationString:(NSString*)configString {
    
    if (self.config && [self.config count] > 0) {
        return _config;
    }
    
    NSArray *pros = [configString componentsSeparatedByString:@"\n"];
    NSMutableDictionary *config = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *item in pros) {
        NSArray *kv = [item componentsSeparatedByString:@"="];
        if ([kv count] == 2) {
            NSString *value = [[kv objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            NSString *key = [[kv objectAtIndex:0] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            [config setObject:value forKey:key];
        }
    }
    
    self.config = config;
    
    return config;
}

@end
