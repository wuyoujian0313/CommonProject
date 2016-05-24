//
//  IgnoreURLList.m
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/8.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import "IgnoreURLList.h"

@interface IgnoreURLList ()

@property (nonatomic, strong) NSMutableArray *ignoreList;

@end

@implementation IgnoreURLList

- (instancetype) init {
    if(self = [super init]) {
        _ignoreList = [[NSMutableArray alloc] initWithCapacity:7];
    }
    return self;
}

+ (instancetype) sharedIgnoreURLList {
    static IgnoreURLList *_sIgnoreList = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        _sIgnoreList = [[IgnoreURLList alloc] init];
    });
    return _sIgnoreList;
}


- (void) addIgnoreURL:(NSString *)url {
    
    if(![self urlIsContainedInIgnoreURLList:url]) {
        [_ignoreList addObject:url];
    }
}


- (BOOL) urlIsContainedInIgnoreURLList:(NSString *)url {
    if(url == nil) return NO;
    
    for (NSString *u in _ignoreList) {
        if ([url rangeOfString:u].length > 0) {
            return YES;
        }
    }
    
    return NO;
}


@end
