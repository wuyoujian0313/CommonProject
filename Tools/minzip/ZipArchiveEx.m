//
//  ZipEx.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/23.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "ZipArchiveEx.h"
#import "ZipArchive.h"

@implementation ZipArchiveEx

// 1、解压
+ (BOOL)unZipWithPassword:(NSString*)password sourceFile:(NSString*)sourceFile outDirectory:(NSString*)directory {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL *isDirectory = NULL;
    if (![fileManager fileExistsAtPath:directory isDirectory:isDirectory]) {
        [fileManager createDirectoryAtPath:directory withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    if (![fileManager fileExistsAtPath:sourceFile]) {
        
        NSLog(@"sourceFile：%@ 不存在！",sourceFile);
        return NO;
    }
    
    ZipArchive* zip = [[ZipArchive alloc] init];
    if([zip UnzipOpenFile:sourceFile Password:password]){
        BOOL bSuc = [zip UnzipFileTo:directory overWrite:YES];
        if (!bSuc) {
            NSLog(@"解压文件失败！");
            [zip UnzipCloseFile];
            return bSuc;
        }
        [zip UnzipCloseFile];
    }
    
    return YES;
}

// 2、压缩
+ (BOOL)zipWithPassword:(NSString*)password sourceFiles:(NSArray *)sourceFiles outZipFile:(NSString *)zipFile {
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *extension = [zipFile pathExtension];
    if (extension) {
        //
        if (![fileManager fileExistsAtPath:zipFile]) {
            NSString *path = [zipFile stringByDeletingLastPathComponent];
            [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        } else {
            [fileManager removeItemAtPath:zipFile error:nil];
        }
        
        ZipArchive* zip = [[ZipArchive alloc] init];
        [zip CreateZipFile2:zipFile Password:password];
        for (NSString*sourceFile in sourceFiles) {
            if ([fileManager fileExistsAtPath:sourceFile]) {
                [zip addFileToZip:sourceFile newname:[sourceFile lastPathComponent]];
            } else {
                NSLog(@"sourceFile:%@ 不存在",sourceFile);
                [zip CloseZipFile2];
                return NO;
            }
        }
        
        [zip CloseZipFile2];
        return YES;
        
    } else {
        return NO;
    }
    
    return YES;
}


@end
