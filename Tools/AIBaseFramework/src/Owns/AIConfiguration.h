//
//  AIConfiguration.h
//  CRMMobile_TJ
//
//  Created by wuyoujian on 16/8/2.
//  Copyright © 2016年 Asiainfo. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 专用于读取在mainBoundle里的properties的配置
 */
@interface AIConfiguration : NSObject

// @param name 配置文件名
+ (NSDictionary *)configurationName:(NSString*)name;

// @param configData 配置文件数据
+ (NSDictionary *)configurationData:(NSData*)configData;

// @param configString 配置文件数据
+ (NSDictionary *)configurationString:(NSString*)configString;

@end
