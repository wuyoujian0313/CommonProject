//
//  NetworkTaskEx.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/4.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, NetStatusCodeEx) {
    NetStatusCodeExSuccess = 1000,
    NetStatusCodeExMAPSuccess = 0,
    NetStatusCodeExUnknown,
};


#define NetStatusCodeExSuc(status)    (status == NetStatusCodeExSuccess || status == NetStatusCodeExMAPSuccess)
#define NetStatusCodeExFail(status)    (status != NetStatusCodeExSuccess && status != NetStatusCodeExMAPSuccess)

@interface UploadFileInfoEx : NSObject
@property(nonatomic,copy) NSString      *fileName;
@property(nonatomic,copy) NSString      *mimeType;
@property(nonatomic,strong) NSData      *fileData;
@property(nonatomic,copy) NSString      *fileKey;
@end


@class NetResultBase;
@protocol NetworkTaskExDelegate <NSObject>

@optional
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo;
-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo;

@end

@interface NetworkTaskEx : NSObject

@property(nonatomic, assign) NSTimeInterval taskTimeout;

+ (NetworkTaskEx *)sharedNetworkTask;

+(NSString *)errerDescription:(NSInteger)statusCode;

// upload File 带上传文件的
- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  fileData:(NSData*)fileData
                   fileKey:(NSString*)fileKey
                  fileName:(NSString*)fileName
                  mimeType:(NSString*)mimeType
                  delegate:(id <NetworkTaskExDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  filePath:(NSString*)filePath
                   fileKey:(NSString*)fileKey
                  fileName:(NSString*)fileName
                  mimeType:(NSString*)mimeType
                  delegate:(id <NetworkTaskExDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                     files:(NSArray<UploadFileInfoEx*>*)files
                  delegate:(id <NetworkTaskExDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

// GET
- (void)startGETTaskURL:(NSString*)urlString
               delegate:(id <NetworkTaskExDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

- (void)startGETTaskApi:(NSString*)api
               forParam:(NSDictionary *)param
               delegate:(id <NetworkTaskExDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

// POST
- (void)startPOSTTaskApi:(NSString*)api
                forParam:(NSDictionary *)param
                delegate:(id <NetworkTaskExDelegate>)delegate
               resultObj:(NetResultBase*)resultObj
              customInfo:(id)customInfo;

// PUT
- (void)startPUTTaskApi:(NSString*)api
               forParam:(NSDictionary *)param
               delegate:(id <NetworkTaskExDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

// DELETE
- (void)startDELETETaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  delegate:(id <NetworkTaskExDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

@end
