//
//  CacheURLProtocol.m
//  CommonProject
//
//  Created by wuyoujian on 16/6/2.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "CacheURLProtocol.h"
#import <CommonCrypto/CommonDigest.h>

static NSUInteger const kCacheExpireTime = 600;//缓存的时间  默认设置为600秒

@interface WebCachedData : NSObject <NSCoding>
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLRequest *redirectRequest;
@property (nonatomic, strong) NSDate *date;
@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";
static NSString *const kDateKey = @"date";

@implementation WebCachedData

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
    [aCoder encodeObject:[self date] forKey:kDateKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
        [self setDate:[aDecoder decodeObjectForKey:kDateKey]];
    }
    
    return self;
}

@end

static NSString *const kOurRecursiveRequestFlagProperty = @"COM.WEIMEITC.CACHE";
static NSString *const kSessionQueueName = @"weimeitc_sessionQueueName";
static NSString *const kSessionDescription = @"weimeitc_sessionDescription";


@interface CacheURLProtocol ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession                  *session;
@property (nonatomic, copy) NSURLSessionConfiguration       *configuration;
@property (nonatomic, strong) NSOperationQueue              *sessionQueue;
@property (nonatomic, strong) NSURLSessionDataTask          *task;
@property (nonatomic, strong) NSMutableData                 *data;
@property (nonatomic, strong) NSURLResponse                 *response;

- (void)appendData:(NSData *)newData;
@end

@implementation CacheURLProtocol

- (void)dealloc {
    [self.task cancel];
    
    [self setTask:nil];
    [self setSession:nil];
    [self setData:nil];
    [self setResponse:nil];
    [self setSessionQueue:nil];
    [self setConfiguration:nil];
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request {
    // 可以修改request对象
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(NSURLRequest *)a toRequest:(NSURLRequest *)b {
    return [super requestIsCacheEquivalent:a toRequest:b];
}

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    // 如果是startLoading里发起的request忽略掉，避免死循环
    return [self propertyForKey:kOurRecursiveRequestFlagProperty inRequest:task.currentRequest] == nil;
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(nullable NSCachedURLResponse *)cachedResponse client:(nullable id <NSURLProtocolClient>)client {
    
    self = [super initWithTask:task cachedResponse:cachedResponse client:client];
    if (self != nil) {
        [self configProtocolParam];
    }
    return self;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    // 如果是startLoading里发起的request忽略掉，避免死循环
    return [self propertyForKey:kOurRecursiveRequestFlagProperty inRequest:request] == nil;
}

- (id)initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id <NSURLProtocolClient>)client {
    
    self = [super initWithRequest:request cachedResponse:cachedResponse client:client];
    if (self != nil) {
        [self configProtocolParam];
    }
    return self;
}

- (void)startLoading {
    
    WebCachedData *cache = [NSKeyedUnarchiver unarchiveObjectWithFile:[self cachePathForRequest:[self request]]];
    
    if (cache) {
        // 本地有缓存
        NSData *data = [cache data];

        NSURLResponse *response = [cache response];
        NSURLRequest *redirectRequest = [cache redirectRequest];
        NSDate *date = [cache date];
        if ([self expireCacheData:date]) {
            // 数据过期
            NSLog(@"request Data-expire!");
            NSMutableURLRequest *recursiveRequest = [[self request] mutableCopy];
            [[self class] setProperty:@YES forKey:kOurRecursiveRequestFlagProperty inRequest:recursiveRequest];
            self.task = [self.session dataTaskWithRequest:recursiveRequest];
            [self.task resume];
            
        } else {
            if (redirectRequest) {
                [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
            } else {
                
                if (data) {
                    NSLog(@"cached Data!");
                    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                    [[self client] URLProtocol:self didLoadData:data];
                    [[self client] URLProtocolDidFinishLoading:self];
                } else {
                    // 本地没有缓存上data
                    NSLog(@"request Data-uncached data!");
                    NSMutableURLRequest *recursiveRequest = [[self request] mutableCopy];
                    [[self class] setProperty:@YES forKey:kOurRecursiveRequestFlagProperty inRequest:recursiveRequest];
                    self.task = [self.session dataTaskWithRequest:recursiveRequest];
                    [self.task resume];
                }
            }
        }
        
    } else {
        
        // 本地无缓存
        NSLog(@"request Data-no data!");
        NSMutableURLRequest *recursiveRequest = [[self request] mutableCopy];
        [[self class] setProperty:@YES forKey:kOurRecursiveRequestFlagProperty inRequest:recursiveRequest];
        self.task = [self.session dataTaskWithRequest:recursiveRequest];
        [self.task resume];
    }
}

- (void)stopLoading {
    [self.task cancel];
    
    [self setTask:nil];
    [self setData:nil];
    [self setResponse:nil];
}

#pragma mark - NSURLSession delegate

- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task willPerformHTTPRedirection:(NSHTTPURLResponse *)response newRequest:(NSURLRequest *)newRequest completionHandler:(void (^)(NSURLRequest *))completionHandler {
    
    if (response != nil) {
        NSMutableURLRequest *redirectableRequest = [newRequest mutableCopy];
        [[self class] removePropertyForKey:kOurRecursiveRequestFlagProperty inRequest:redirectableRequest];
        
        NSString *cachePath = [self cachePathForRequest:[self request]];
        WebCachedData *cache = [[WebCachedData alloc] init];
        [cache setResponse:response];
        [cache setData:[self data]];
        [cache setDate:[NSDate date]];
        [cache setRedirectRequest:redirectableRequest];
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];

        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        
        [self.task cancel];
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
        
        completionHandler(redirectableRequest);
    } else {
        completionHandler(newRequest);
    }
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void(^)(NSURLSessionResponseDisposition))completionHandler {
    
    [self setResponse:response];
    [self setData:nil];
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data {
    
    [[self client] URLProtocol:self didLoadData:data];
    [self appendData:data];
}


- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)dataTask didCompleteWithError:(NSError *)error {
    
    if (error ) {
        [self.client URLProtocol:self didFailWithError:error];
    } else {
        NSString *cachePath = [self cachePathForRequest:[self request]];
        WebCachedData *cache = [[WebCachedData alloc] init];
        [cache setResponse:[self response]];
        [cache setData:[self data]];
        [cache setDate:[NSDate date]];
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - private APIs

- (void)configProtocolParam {
    NSURLSessionConfiguration *config = [[NSURLSessionConfiguration defaultSessionConfiguration] copy];
    [config setProtocolClasses:@[ [self class] ]];
    [self setConfiguration:config];
    
    NSOperationQueue *q = [[NSOperationQueue alloc] init];
    [q setMaxConcurrentOperationCount:1];
    [q setName:kSessionQueueName];
    [self setSessionQueue:q];
    
    NSURLSession *s = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionQueue];
    s.sessionDescription = kSessionDescription;
    [self setSession:s];
}

- (NSString*)md5Encode:(NSString*)srcString {
    const char *cStr = [srcString UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), result);
    
    NSString *formatString = @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x";
    
    return [NSString stringWithFormat:formatString,
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [self md5Encode:[[aRequest URL] absoluteString]];
    return [cachesPath stringByAppendingPathComponent:fileName];
}

- (void)appendData:(NSData *)newData {
    if ([self data] == nil) {
        self.data = [[NSMutableData alloc] initWithCapacity:0];
    }
    
    if (newData) {
        [[self data] appendData:newData];
    }
}

- (BOOL)expireCacheData:(NSDate *)date {
    
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSinceDate:date];
    BOOL bRet = timeInterval < kCacheExpireTime;
    if (!bRet) {
        // 过期删除缓存
        NSString *filename = [self cachePathForRequest:[self request]];
        NSFileManager *defaultManager = [NSFileManager defaultManager];
        if ([defaultManager isDeletableFileAtPath:filename]) {
            [defaultManager removeItemAtPath:filename error:nil];
        }
    }
    
    return !bRet;
}

@end


