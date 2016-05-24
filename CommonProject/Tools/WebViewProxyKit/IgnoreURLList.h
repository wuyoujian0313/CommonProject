//
//  IgnoreURLList.h
//  WebViewProxySDK
//
//  Created by wuyj on 15/9/8.
//  Copyright (c) 2015年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IgnoreURLList : NSObject

+ (instancetype) sharedIgnoreURLList;

- (void) addIgnoreURL:(NSString *)url;
- (BOOL) urlIsContainedInIgnoreURLList:(NSString *)url;

@end
