//
//  SharedDataModel.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/12.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,SharedDataType) {
    SharedDataTypeURL,
    SharedDataTypeText,
    SharedDataTypeImage,
    SharedDataTypeFile,
};

@interface SharedDataModel : NSObject

@property (nonatomic, assign) SharedDataType dataType;

// 分享的数据，1、url、text ==》NSString; 2、image ==》UIImage； 3、file ==>data
@property (nonatomic, strong) id data;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *content;// 在分享文字的时候，content=data


@end
