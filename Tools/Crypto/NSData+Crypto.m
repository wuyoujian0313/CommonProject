//
//  NSData+Crypto.m
//  Encrypt
//
//  Created by wuyj on 15/7/3.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSData+Crypto.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>


NSString * const kNSDataCryptoErrorDomain = @"NSDataCryptoErrorDomain";

@interface NSError (NSDataCryptoErrorDomain)
+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status;
@end

@implementation NSError (NSDataCryptoErrorDomain)

+ (NSError *)errorWithCCCryptorStatus:(CCCryptorStatus)status {
    NSString *desc = nil;
    
    switch (status) {
        case kCCSuccess:
            desc = @"Success";
            break;
            
        case kCCParamError:
            desc = @"Parameter Error";
            break;
            
        case kCCBufferTooSmall:
            desc = @"Buffer Too Small";
            break;
            
        case kCCMemoryFailure:
            desc = @"Memory Failure";
            break;
            
        case kCCAlignmentError:
            desc = @"Alignment Error";
            break;
            
        case kCCDecodeError:
            desc = @"Decode Error";
            break;
            
        case kCCUnimplemented:
            desc = @"Unimplemented Function";
            break;
            
        default:
            desc = @"Unknown Error";
            break;
    }
    
    NSMutableDictionary * userInfo = [[NSMutableDictionary alloc] init];
    [userInfo setObject: desc forKey: NSLocalizedDescriptionKey];
    [userInfo setObject: desc forKey: NSLocalizedFailureReasonErrorKey];
    
    return [NSError errorWithDomain:kNSDataCryptoErrorDomain code:status userInfo:userInfo];
}

@end


@implementation NSData (Crypto)


- (NSData *)AES128EncryptedDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedWithAlgorithm:kCCAlgorithmAES128
                                                    key:key
                                                options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                  error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)decryptedAES128DataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataWithAlgorithm:kCCAlgorithmAES128
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)DESEncryptedDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedWithAlgorithm:kCCAlgorithmDES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)decryptedDESDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataWithAlgorithm:kCCAlgorithmDES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)tripleDESEncryptedDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self dataEncryptedWithAlgorithm:kCCAlgorithm3DES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}

- (NSData *)decryptedTripleDESDataWithKey:(id)key error:(NSError **)error {
    
    CCCryptorStatus status = kCCSuccess;
    NSData * result = [self decryptedDataWithAlgorithm:kCCAlgorithm3DES
                                                   key:key
                                               options:kCCOptionPKCS7Padding | kCCOptionECBMode
                                                 error:&status];
    
    if (result)
        return result;
    
    if (error)
        *error = [NSError errorWithCCCryptorStatus:status];
    
    return nil;
}


- (void)appendKeyLengthsByAlgorithm:(CCAlgorithm)algorithm keyData:(NSMutableData*)keyData {
    
    switch (algorithm) {
        case kCCAlgorithmAES128: {
            [keyData setLength:kCCKeySizeAES128];
            break;
        }
            
        case kCCAlgorithmDES: {
            [keyData setLength:kCCKeySizeDES];
            break;
        }
            
        case kCCAlgorithm3DES: {
            [keyData setLength:kCCKeySize3DES];

            break;
        }
            
        default:
            break;
    }
}

- (NSData *)cryptorToData:(CCCryptorRef)cryptor result:(CCCryptorStatus *)status {
    
    size_t bufsize = CCCryptorGetOutputLength(cryptor, (size_t)[self length],true);
    void * buf = malloc( bufsize );
    size_t bufused = 0;
    size_t bytesTotal = 0;
    *status = CCCryptorUpdate(cryptor,
                              [self bytes],
                              (size_t)[self length],
                              buf,
                              bufsize,
                              &bufused);
    if (*status != kCCSuccess) {
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    *status = CCCryptorFinal(cryptor, buf + bufused, bufsize - bufused, &bufused);
    if (*status != kCCSuccess){
        free(buf);
        return nil;
    }
    
    bytesTotal += bufused;
    
    return [NSData dataWithBytesNoCopy:buf length:bytesTotal];
}


- (NSData *)dataEncryptedWithAlgorithm:(CCAlgorithm)algorithm
                                   key:(id)key
                               options:(CCOptions)options
                                 error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData *keyData;
    if ([key isKindOfClass: [NSData class]])
        keyData = (NSMutableData *)[key mutableCopy];
    else
        keyData = [[key dataUsingEncoding:NSUTF8StringEncoding] mutableCopy];
    
    [self appendKeyLengthsByAlgorithm:algorithm keyData:keyData];

    status = CCCryptorCreate(kCCEncrypt,
                             algorithm,
                             options,
                             [keyData bytes],
                             [keyData length],
                             NULL,
                             &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL)
            *error = status;
        return nil;
    }
    
    NSData *result = [self cryptorToData:cryptor result:&status];
    if (result == nil && error != NULL)
        *error = status;
    
    CCCryptorRelease(cryptor);
    return result;
}

- (NSData *)decryptedDataWithAlgorithm:(CCAlgorithm)algorithm
                                     key:(id)key
                                 options:(CCOptions)options
                                   error:(CCCryptorStatus *)error {
    CCCryptorRef cryptor = NULL;
    CCCryptorStatus status = kCCSuccess;
    
    NSMutableData * keyData;
    if ( [key isKindOfClass: [NSData class]] )
        keyData = (NSMutableData *)[key mutableCopy];
    else
        keyData = [[key dataUsingEncoding: NSUTF8StringEncoding] mutableCopy];
    
    [self appendKeyLengthsByAlgorithm:algorithm keyData:keyData];
    
    status = CCCryptorCreate(kCCDecrypt,
                             algorithm,
                             options,
                             [keyData bytes],
                             [keyData length],
                             NULL,
                             &cryptor);
    
    if (status != kCCSuccess) {
        if (error != NULL)
            *error = status;
        return nil;
    }
    
    NSData *result = [self cryptorToData:cryptor result:&status];
    if (result == nil && error != NULL)
        *error = status;
    
    CCCryptorRelease(cryptor);
    return result;
}

- (NSString*)md5String {
    
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(self.bytes, (CC_LONG)self.length, r);
    NSString *md5 = [[NSString alloc] initWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]];
    
    
    return md5;
}

#define CHUNK_SIZE 1024

+ (NSString *)fileMD5:(NSString*)path {
    NSFileHandle* handle = [NSFileHandle fileHandleForReadingAtPath:path];
    
    if(handle == nil)
        return nil;
    
    CC_MD5_CTX md5_ctx;
    CC_MD5_Init(&md5_ctx);
    
    // 分块读取数据
    NSData* filedata;
    do {
        
        filedata = [handle readDataOfLength:CHUNK_SIZE];
        
        //调用系统底层函数，无法避免32->64
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wshorten-64-to-32"
        CC_MD5_Update(&md5_ctx, [filedata bytes], [filedata length]);
#pragma clang diagnostic pop
        
    }
    
    while([filedata length]);
    
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5_Final(result, &md5_ctx);
    [handle closeFile];
    
    NSMutableString *hash = [NSMutableString string];
    
    for(int i=0;i<CC_MD5_DIGEST_LENGTH;i++) {
        [hash appendFormat:@"%02x",result[i]];
    }
    return [hash lowercaseString];
}

- (NSData*)base64EncodeData {
    
    NSData *stringData =[self base64EncodedDataWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return stringData;
}

- (NSData*)base64DecodeData {
    NSData *stringBase64Data = [[NSData alloc] initWithBase64EncodedData:self options:NSDataBase64DecodingIgnoreUnknownCharacters];
    return stringBase64Data;
}

- (NSString*)base64EncodeString {
    NSString *string = [self base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    return string;
}

- (NSString*)base64DecodeString {
    
    NSData *stringData = [self base64DecodeData];
    return [[NSString alloc] initWithData:stringData encoding:NSUTF8StringEncoding];
}

@end

