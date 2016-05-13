//
//  SharedMailSMSController.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

@interface MailSMSController : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

/**
 *  邮件分享:默认取UIWindow的rootViewController
 *
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */
- (void)sendEmailWithSubject:(NSString*)subject andContent:(NSString*)content;


/**
 *  邮件分享
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */
- (void)sendEmailWithViewController:(UIViewController*)viewController andSubject:(NSString*)subject andContent:(NSString*)content;

/**
 *  短信分享:默认取UIWindow的rootViewController
 *
 *  @param content 短信内容
 */
- (void)sendSmsWithContent:(NSString*)content;

/**
 *  短信分享
 *
 *  @param viewController 当前的VC，主要从哪个VC弹出SMS VC
 *  @param content 短信内容
 */
- (void)sendSmsWithViewController:(UIViewController*)viewController andContent:(NSString*)content;

@end
