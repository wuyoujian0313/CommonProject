//
//  SignatureView.h
//  CommonProject
//
//  Created by wuyoujian on 16/7/16.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SigntureStatus) {
    SignatureStatusBegin,
    SignatureStatusMoving,
    SignatureStatusEnd,
};

typedef void(^SignatureStautsCallback)(SigntureStatus status);

@interface SignatureView : UIView

// 签名图片
@property (nonatomic, readonly, strong) UIImage     *image;
// 画笔颜色,默认黑色，背景色:白色
@property (nonatomic, strong) UIColor               *penColor;
// 画笔大小
@property (nonatomic, assign) CGFloat               penSize;

- (instancetype)initWithFrame:(CGRect)frame status:(SignatureStautsCallback)callback;

// @path 是图片保存的全路径
- (void)saveImage2PNGAtPath:(NSString*)path;
- (void)saveImage2JPEGAtPath:(NSString*)path;

- (BOOL)canUndoSignature;
- (BOOL)canRedoSignature;

// 撤销上一笔
- (void)undoSignature;

// 重做上一笔
- (void)redoSignature;

// 清楚所有的笔画
- (void)clear;

@end
