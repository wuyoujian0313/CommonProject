//
//  CacheURLProtocol.h
//  CommonProject
//
//  Created by wuyoujian on 16/6/2.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CacheURLProtocol : NSURLProtocol

+ (BOOL)registerProtocolWithIgnoreURLs:(NSArray*)ignores;
+ (void)unregisterCacheURLProtocol;


@end
