//
//  BDWebViewProxySDK.m
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/6.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import "BDWebViewProxySDK.h"
#import "CustomHTTPProtocol.h"
#import "CredentialsManager.h"
#import "IgnoreURLList.h"
#import "NSData+Crypto.h"


#define kNetworkAPIServer_test          @"http://bb-art-osupdate01.bb01.baidu.com:8280/api_proxy"
#define kNetworkAPIServer1              @"https://mop.baidu.com/rest"


//测试环境
#define PROXY_SERVER_TEST               @"bb-art-osupdate01.bb01.baidu.com"
#define PROXY_PORT_TEST                 8899

//正式环境
#define PROXY_SERVER                    @"proxy.mop.baidu.com"
#define PROXY_PORT                      80

//过滤掉uuap sdk中的请求
#define IGNORE_EMS_API_BASE_ONLINE      @"https://mop.baidu.com"
#define IGNORE_EMS_API_BASE_TEST        @"http://bb-art-osupdate01.bb01.baidu.com:8280"



@interface BDWebViewProxySDK ()<CustomHTTPProtocolDelegate>

@property (nonatomic, strong, readwrite)CredentialsManager      *credentialsManager;
@property (nonatomic, strong) NSDictionary                      *proxyDict;
@property (nonatomic, strong) NSDictionary                      *authDict;
@property (nonatomic, assign) BDWebViewProxySDKEnvironment      environment;
@property (nonatomic, strong) NSString                          *at;
@property (nonatomic, strong) NSString                          *key;

@end

@implementation BDWebViewProxySDK

-(instancetype)init {
    return [self initWithEnviroment:BDWebViewProxySDK_ONLINE];
}

- (instancetype)initWithEnviroment:(BDWebViewProxySDKEnvironment)environment {
    if(self = [super init]) {
        
        IgnoreURLList * sharedIgnoreList = [IgnoreURLList sharedIgnoreURLList];
        [sharedIgnoreList addIgnoreURL:IGNORE_EMS_API_BASE_ONLINE];
        [sharedIgnoreList addIgnoreURL:IGNORE_EMS_API_BASE_TEST];
        
        _environment = environment;
        
    }
    return self;
}

-(void)dealloc {
    [self stopHTTPProxy];
}

- (void)stopHTTPProxy {
    self.at = nil;
    self.key = nil;
    [CustomHTTPProtocol stop];
}

- (void)addIgnoreURLList:(NSArray*)urls {
    
    IgnoreURLList * sharedIgnoreList = [IgnoreURLList sharedIgnoreURLList];
    for (NSString *url in urls) {
        [sharedIgnoreList addIgnoreURL:url];
    }
}


- (void)startHTTTPProxyWithAT:(NSString*)at mopKey:(NSString*)mopKey userName:(NSString*)userName finish:(startHTTTPProxyFinish)block {
    
    __block startHTTTPProxyFinish finishBlock = block;
    
    if ((_at == nil || [_at isEqualToString:at]) && (_key == nil || [_key isEqualToString:at])) {
        // 创建Data Task
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/portal/genpk/1.0",kNetworkAPIServer1]];
        if (_environment == BDWebViewProxySDK_TEST) {
            url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/portal/genpk/1.0",kNetworkAPIServer_test]];
        }
        
        NSURLSession *session = [NSURLSession sharedSession];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
        NSString *param = [NSString stringWithFormat:@"at=%@",at];
        [request setHTTPBody:[NSData dataWithData:[param dataUsingEncoding:NSUTF8StringEncoding]]];
        [request setHTTPMethod:@"POST"];
        
        NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler: ^(NSData *data, NSURLResponse *response, NSError *error) {
            
            if (data) {
                NSError *er;
                NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&er];
                
                if (jsonDictionary && [[jsonDictionary objectForKey:@"code"] integerValue] == 200) {
                    
                    NSString *encryptKey = [[jsonDictionary objectForKey:@"data"] objectForKey:@"key"];
                    if (encryptKey && [encryptKey length] > 0) {
                        
                        self.key = encryptKey;
                        
                        NSString* proxyHost = [NSString stringWithFormat:@"%@",PROXY_SERVER];
                        NSNumber* proxyPort = [NSNumber numberWithInteger:PROXY_PORT];
                        if (_environment == BDWebViewProxySDK_TEST) {
                            proxyHost = [NSString stringWithFormat:@"%@",PROXY_SERVER_TEST];
                            proxyPort = [NSNumber numberWithInteger:PROXY_PORT_TEST];
                        }
                        
                        [self setHTTTPProxy:proxyHost port:proxyPort at:at encryptKey:encryptKey mopKey:mopKey userName:userName];
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            NSLog(@"finishBlock:%@",finishBlock);
                            finishBlock();
                        });
                    }
                }
            }
        }];
        // 使用resume方法启动任务
        [dataTask resume];
    } else {
        
        NSString* proxyHost = [NSString stringWithFormat:@"%@",PROXY_SERVER];
        NSNumber* proxyPort = [NSNumber numberWithInteger:PROXY_PORT];
        if (_environment == BDWebViewProxySDK_TEST) {
            proxyHost = [NSString stringWithFormat:@"%@",PROXY_SERVER_TEST];
            proxyPort = [NSNumber numberWithInteger:PROXY_PORT_TEST];
        }
        
        [self setHTTTPProxy:proxyHost port:proxyPort at:at encryptKey:_key mopKey:mopKey userName:userName];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            finishBlock();
        });
    }
}

- (void)setHTTTPProxy:(NSString*)host port:(NSNumber *)port at:(NSString*)at encryptKey:(NSString*)encryptKey mopKey:(NSString*)mopKey userName:(NSString*)userName {
    
    [CustomHTTPProtocol stop];
    
    NSString* proxyHost = host;
    NSNumber* proxyPort = port;
    
    self.proxyDict = @{
                       
                       @"HTTPEnable"  : [NSNumber numberWithInt:1],
                       (__bridge NSString *)kCFStreamPropertyHTTPProxyHost  : proxyHost,
                       (__bridge NSString *)kCFStreamPropertyHTTPProxyPort  : proxyPort,
                       
                       @"HTTPSEnable" : [NSNumber numberWithInt:1],
                       (__bridge NSString *)kCFStreamPropertyHTTPSProxyHost : proxyHost,
                       (__bridge NSString *)kCFStreamPropertyHTTPSProxyPort : proxyPort,
                       
                       };
    
    [CustomHTTPProtocol setProxyConfig:self.proxyDict];
    NSData *encryptData = [[at dataUsingEncoding:NSUTF8StringEncoding] AES128EncryptedDataWithKey:encryptKey error:nil];
    NSString *password = [encryptData base64EncodedStringWithOptions:0];
    [CustomHTTPProtocol setContentPassword:encryptKey];//密码请用具体的密码
    
    NSString *upString = [NSString stringWithFormat:@"ios/%@/%@:%@",mopKey,userName,password];
    NSString *base64Str = [[upString dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:0];
    NSString *authString = [NSString stringWithFormat:@"Basic %@",base64Str];
    if (authString && [authString length] > 0) {
        self.authDict = @{@"Proxy-Authorization" : authString};
        [CustomHTTPProtocol setAuthConfig:self.authDict];
    }
    
    self.credentialsManager = [[CredentialsManager alloc] init];
    [CustomHTTPProtocol setDelegate:self];
    [CustomHTTPProtocol start];
}

#pragma mark - CustomHTTPProtocol
- (BOOL)customHTTPProtocol:(CustomHTTPProtocol *)protocol canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace {
    
    //// assert(protocol != nil);
#pragma unused(protocol)
    //// assert(protectionSpace != nil);
    
    return [[protectionSpace authenticationMethod] isEqual:NSURLAuthenticationMethodServerTrust];
}

/*! Called by an CustomHTTPProtocol instance to request that the delegate process on authentication
 *  challenge. Will be called on the main thread. Unless the challenge is cancelled (see below)
 *  the delegate must eventually resolve it by calling -resolveAuthenticationChallenge:withCredential:.
 *  \param protocol The protocol instance itself; will not be nil.
 *  \param challenge The authentication challenge; will not be nil.
 */

- (void)customHTTPProtocol:(CustomHTTPProtocol *)protocol didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
    OSStatus            err;
    NSURLCredential *   credential;
    SecTrustRef         trust;
    SecTrustResultType  trustResult;
    
    // Given our implementation of -customHTTPProtocol:canAuthenticateAgainstProtectionSpace:, this method
    // is only called to handle server trust authentication challenges.  It evaluates the trust based on
    // both the global set of trusted anchors and the list of trusted anchors returned by the CredentialsManager.
    
    //// assert(protocol != nil);
    //// assert(challenge != nil);
    //// assert([[[challenge protectionSpace] authenticationMethod] isEqual:NSURLAuthenticationMethodServerTrust]);
    //// assert([NSThread isMainThread]);
    
    credential = nil;
    
    // Extract the SecTrust object from the challenge, apply our trusted anchors to that
    // object, and then evaluate the trust.  If it's OK, create a credential and use
    // that to resolve the authentication challenge.  If anything goes wrong, resolve
    // the challenge with nil, which continues without a credential, which causes the
    // connection to fail.
    
    trust = [[challenge protectionSpace] serverTrust];
    if (trust == NULL) {
        //// assert(NO);
    } else {
        err = SecTrustSetAnchorCertificates(trust, (__bridge CFArrayRef) self.credentialsManager.trustedAnchors);
        if (err != noErr) {
            //// assert(NO);
        } else {
            err = SecTrustSetAnchorCertificatesOnly(trust, false);
            if (err != noErr) {
                // assert(NO);
            } else {
                err = SecTrustEvaluate(trust, &trustResult);
                if (err != noErr) {
                    // assert(NO);
                } else {
                    if ( (trustResult == kSecTrustResultProceed) || (trustResult == kSecTrustResultUnspecified) ) {
                        credential = [NSURLCredential credentialForTrust:trust];
                        // assert(credential != nil);
                    }
                    //credential = [NSURLCredential credentialForTrust:trust];
                }
            }
        }
    }
    
    [protocol resolveAuthenticationChallenge:challenge withCredential:credential];
}

/*! Called by an CustomHTTPProtocol instance to cancel an issued authentication challenge.
 *  Will be called on the main thread.
 *  \param protocol The protocol instance itself; will not be nil.
 *  \param challenge The authentication challenge; will not be nil; will match the challenge
 *  previously issued by -customHTTPProtocol:canAuthenticateAgainstProtectionSpace:.
 */

- (void)customHTTPProtocol:(CustomHTTPProtocol *)protocol didCancelAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge {
    
}

/*! Called by the CustomHTTPProtocol to log various bits of information.
 *  Can be called on any thread.
 *  \param protocol The protocol instance itself; nil to indicate log messages from the class itself.
 *  \param format A standard NSString-style format string; will not be nil.
 *  \param arguments Arguments for that format string.
 */

- (void)customHTTPProtocol:(CustomHTTPProtocol *)protocol logWithFormat:(NSString *)format arguments:(va_list)arguments {
    
    //return;
    
    NSString *  prefix;
    
    // protocol may be nil
    // assert(format != nil);
    
    if (protocol == nil) {
        prefix = @"protocol ";
    } else {
        prefix = [NSString stringWithFormat:@"protocol %p ", protocol];
    }
    [self logWithPrefix:prefix format:format arguments:arguments];
}


- (void)logWithPrefix:(NSString *)prefix format:(NSString *)format arguments:(va_list)arguments {
    // assert(prefix != nil);
    // assert(format != nil);
    NSString *body = [[NSString alloc] initWithFormat:format arguments:arguments];
    NSLog(@"%@ - %@", prefix, body);
}

@end
