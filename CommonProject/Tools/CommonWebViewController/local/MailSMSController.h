//
//  SharedMailSMSController.h
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>


typedef NS_ENUM(NSInteger, SendStatus) {
    
    SendStatusSuccess,
    SendStatusFail,
    SendStatusSave,
    SendStatusCancel,
};

typedef NS_ENUM(NSInteger, SendType) {
    SendTypeMail,
    SendTypeSMS,
};

//
typedef void(^SendFinishBlock)(SendType type, SendStatus status);

@interface MailSMSController : NSObject<MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate>

// 建议不用单例，建议把MailSMSController作为类一个strong成员变量
// 可以跟随使用的页面对象释放而释放
+ (MailSMSController *)sharedMailSMSController;

/**
 *  邮件分享
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */
- (void)pickerMailComposeViewController:(UIViewController*)viewController andSubject:(NSString*)subject andContent:(NSString*)content finish:(SendFinishBlock)finishBlock;

/**
 *  短信分享
 *
 *  @param viewController 当前的VC，主要从哪个VC弹出SMS VC
 *  @param content 短信内容
 */
- (void)pickerMessageComposeViewController:(UIViewController*)viewController andContent:(NSString*)content finish:(SendFinishBlock)finishBlock;

@end
