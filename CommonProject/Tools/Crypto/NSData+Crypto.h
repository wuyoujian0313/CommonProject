//
//  NSData+Crypto.h
//  Encrypt
//
//  Created by wuyj on 15/7/3.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//


#import <Foundation/Foundation.h>


/***********************************************
 * !!!!!!!!!! 注意!!!!!!!!!!
 * java后端对于AES和DES 不支持key的补位，需要采用8，16，32等长度的秘钥
 * !!!!!!!!!! AES128,key的长度是16位字符
 * !!!!!!!!!! DES,key的长度是16位或者8位字符
 * 需要跟后端的java调试！！！！！！！！
 ***********************************************/

@interface NSData (Crypto)

// key可以是NString或者NSData
// !!!!!!!!!! AES128,key的长度是16位字符
- (NSData *)AES128EncryptedDataWithKey:(id)key error:(NSError **)error;
- (NSData *)decryptedAES128DataWithKey:(id)key error:(NSError **)error;

// key可以是NString或者NSData
// !!!!!!!!!! DES,key的长度是16位或者8位字符
- (NSData *)DESEncryptedDataWithKey:(id)key error:(NSError **)error;
- (NSData *)decryptedDESDataWithKey:(id)key error:(NSError **)error;

- (NSData *)tripleDESEncryptedDataWithKey:(id)key error:(NSError **)error;
- (NSData *)decryptedTripleDESDataWithKey:(id)key error:(NSError **)error;


// md5加密
- (NSString*)md5String;

// 文件的md5加密校验
+ (NSString *)fileMD5:(NSString*)path;

@end
