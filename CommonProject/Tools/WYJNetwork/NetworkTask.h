//
//  NetworkTask.h
//
//
//  Created by wuyj on 14-9-2.
//  Copyright (c) 2014年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSInteger, NetStatusCode) {
    NetStatusCodeSuccess = 1000,
    NetStatusCodeMAPSuccess = 0,
    NetStatusCodeUnknown,
};


#define NetStatusCodeSuc(status)    (status == NetStatusCodeSuccess || status == NetStatusCodeMAPSuccess)
#define NetStatusCodeFail(status)    (status != NetStatusCodeSuccess && status != NetStatusCodeMAPSuccess)

@interface UploadFileInfo : NSObject
@property(nonatomic,copy) NSString      *fileName;
@property(nonatomic,strong) NSString    *mimeType;
@property(nonatomic,strong) NSData      *fileData;
@property(nonatomic,strong) NSString    *key;
@end


@class NetResultBase;
@protocol NetworkTaskDelegate <NSObject>

@optional
-(void)netResultSuccessBack:(NetResultBase *)result forInfo:(id)customInfo;
-(void)netResultFailBack:(NSString *)errorDesc errorCode:(NSInteger)errorCode forInfo:(id)customInfo;

@end



@interface NetworkTask : NSObject

@property(nonatomic, assign) NSTimeInterval taskTimeout;

+ (NetworkTask *)sharedNetworkTask;

+(NSString *)errerDescription:(NSInteger)statusCode;

// upload File 带上传文件的
- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  fileData:(NSData*)fileData
                   fileKey:(NSString*)fileKey
                  fileName:(NSString*)fileName
                  mimeType:(NSString*)mimeType
                  delegate:(id <NetworkTaskDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  filePath:(NSString*)filePath
                   fileKey:(NSString*)fileKey
                  fileName:(NSString*)fileName
                  mimeType:(NSString*)mimeType
                  delegate:(id <NetworkTaskDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

- (void)startUploadTaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                     files:(NSArray<UploadFileInfo*>*)files
                  delegate:(id <NetworkTaskDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

// GET
- (void)startGETTaskURL:(NSString*)urlString
               delegate:(id <NetworkTaskDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

- (void)startGETTaskApi:(NSString*)api
               forParam:(NSDictionary *)param
               delegate:(id <NetworkTaskDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

// POST
- (void)startPOSTTaskApi:(NSString*)api
                forParam:(NSDictionary *)param
                delegate:(id <NetworkTaskDelegate>)delegate
               resultObj:(NetResultBase*)resultObj
              customInfo:(id)customInfo;

// PUT
- (void)startPUTTaskApi:(NSString*)api
               forParam:(NSDictionary *)param
               delegate:(id <NetworkTaskDelegate>)delegate
              resultObj:(NetResultBase*)resultObj
             customInfo:(id)customInfo;

// DELETE
- (void)startDELETETaskApi:(NSString*)api
                  forParam:(NSDictionary *)param
                  delegate:(id <NetworkTaskDelegate>)delegate
                 resultObj:(NetResultBase*)resultObj
                customInfo:(id)customInfo;

@end
