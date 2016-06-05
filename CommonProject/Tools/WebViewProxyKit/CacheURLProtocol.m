//
//  CacheURLProtocol.m
//  
//
//  Created by wuyoujian on 16/6/2.
//
//

#import "CacheURLProtocol.h"
#import "NSString+Utility.h"


@interface WebCachedData : NSObject <NSCoding>
@property (nonatomic, strong) NSData *data;
@property (nonatomic, strong) NSURLResponse *response;
@property (nonatomic, strong) NSURLRequest *redirectRequest;
@end

static NSString *const kDataKey = @"data";
static NSString *const kResponseKey = @"response";
static NSString *const kRedirectRequestKey = @"redirectRequest";

@implementation WebCachedData

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[self data] forKey:kDataKey];
    [aCoder encodeObject:[self response] forKey:kResponseKey];
    [aCoder encodeObject:[self redirectRequest] forKey:kRedirectRequestKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self != nil) {
        [self setData:[aDecoder decodeObjectForKey:kDataKey]];
        [self setResponse:[aDecoder decodeObjectForKey:kResponseKey]];
        [self setRedirectRequest:[aDecoder decodeObjectForKey:kRedirectRequestKey]];
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

+ (BOOL)canInitWithTask:(NSURLSessionTask *)task {
    // 如果是startLoading里发起的request忽略掉，避免死循环
    return [self propertyForKey:kOurRecursiveRequestFlagProperty inRequest:task.currentRequest] == nil;
}

- (instancetype)initWithTask:(NSURLSessionTask *)task cachedResponse:(nullable NSCachedURLResponse *)cachedResponse client:(nullable id <NSURLProtocolClient>)client {
    
    self = [super initWithTask:task cachedResponse:cachedResponse client:client];
    if (self != nil) {
        NSURLSessionConfiguration *config = [[NSURLSessionConfiguration defaultSessionConfiguration] copy];
        [self setConfiguration:config];
        [_configuration setProtocolClasses:@[ [self class] ]];
        
        NSOperationQueue *q = [[NSOperationQueue alloc] init];
        [q setMaxConcurrentOperationCount:1];
        [q setName:kSessionQueueName];
        [self setSessionQueue:q];
        
        NSURLSession *s = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionQueue];
        s.sessionDescription = kSessionDescription;
        [self setSession:s];
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
        NSURLSessionConfiguration *config = [[NSURLSessionConfiguration defaultSessionConfiguration] copy];
        [self setConfiguration:config];
        [_configuration setProtocolClasses:@[ [self class] ]];
        
        NSOperationQueue *q = [[NSOperationQueue alloc] init];
        [q setMaxConcurrentOperationCount:1];
        [q setName:kSessionQueueName];
        [self setSessionQueue:q];
        
        NSURLSession *s = [NSURLSession sessionWithConfiguration:_configuration delegate:self delegateQueue:_sessionQueue];
        s.sessionDescription = kSessionDescription;
        [self setSession:s];
        
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
        if (redirectRequest) {
            [[self client] URLProtocol:self wasRedirectedToRequest:redirectRequest redirectResponse:response];
        } else {
            
            if (data) {
                [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
                [[self client] URLProtocol:self didLoadData:data];
                [[self client] URLProtocolDidFinishLoading:self];
            } else {
                // 本地没有缓存上data
                NSMutableURLRequest *recursiveRequest = [[self request] mutableCopy];
                [[self class] setProperty:@YES forKey:kOurRecursiveRequestFlagProperty inRequest:recursiveRequest];
                self.task = [self.session dataTaskWithRequest:recursiveRequest];
                [self.task resume];
            }
            
            
        }
    } else {
        
        // 本地无缓存
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
        [cache setRedirectRequest:redirectableRequest];
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];

        [[self client] URLProtocol:self wasRedirectedToRequest:redirectableRequest redirectResponse:response];
        
        completionHandler(redirectableRequest);
        
        [self.task cancel];
        [[self client] URLProtocol:self didFailWithError:[NSError errorWithDomain:NSCocoaErrorDomain code:NSUserCancelledError userInfo:nil]];
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
        [NSKeyedArchiver archiveRootObject:cache toFile:cachePath];
        
        [[self client] URLProtocolDidFinishLoading:self];
    }
}

#pragma mark - private APIs
- (NSString *)cachePathForRequest:(NSURLRequest *)aRequest {
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName = [[[aRequest URL] absoluteString] md5EncodeUpper:NO];
    return [cachesPath stringByAppendingPathComponent:fileName];
}

- (void)appendData:(NSData *)newData {
    if ([self data]) {
        self.data = [[NSMutableData alloc] initWithCapacity:0];
    }
    
    if (newData) {
        [[self data] appendData:newData];
    }
}

@end


