//
//  ZipEx.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/23.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZipArchiveEx : NSObject

//1、解压
+ (BOOL)unZipWithPassword:(NSString*)password sourceFile:(NSString*)sourceFile outDirectory:(NSString*)directory;

//2、压缩
+ (BOOL)zipWithPassword:(NSString*)password sourceFiles:(NSArray *)sourceFiles outZipFile:(NSString *)zipFile;

@end
