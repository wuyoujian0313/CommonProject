//
//  DBManager.h
//  FMDB-encrypt
//
//  Created by wuyj on 16-06-20.
//  Copyright (c) 2016年 wuyj. All rights reserved.
//

#import <Foundation/Foundation.h>




static NSString * const indexIdentifier = @"wuyj_index";


@interface DBManager : NSObject


-(BOOL)openDB:(NSString*)filePath;
-(NSArray *)executeSQL:(NSString*)dbFile KEY:(NSString*)key SQL:(NSString*)sql;
-(void)closeDB;

@end
