//
//  MailSMSController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import "MailSMSController.h"
#import "DeviceInfo.h"
#import "FadePromptView.h"


@implementation MailSMSController

/**
 *  邮件分享
 *
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */

- (void)pickerMailComposeViewController:(UIViewController*)viewController andSubject:(NSString*)subject andContent:(NSString*)content {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    
    if (mailClass != nil) {
        if ([mailClass canSendMail]) {
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
            picker.mailComposeDelegate = self;
            [picker setSubject:subject];
            [picker setMessageBody:content isHTML:NO];
            [viewController presentViewController:picker animated:YES completion:nil];
        } else {
            [FadePromptView showPromptStatus:@"当前设置暂时没有办法发送邮件" duration:1.0 finishBlock:nil];
        }
    } else {
        [FadePromptView showPromptStatus:@"当前设置暂时没有办法发送邮件" duration:1.0 finishBlock:nil];
    }
}



- (void)sendEmailWithSubject:(NSString*)subject andContent:(NSString*)content {
    
    UIViewController *ownen = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([DeviceInfo isOS7]) {
        ownen = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    }
    
    [self pickerMailComposeViewController:ownen andSubject:subject andContent:content];
}

/**
 *  邮件分享
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */
- (void)sendEmailWithViewController:(UIViewController*)viewController andSubject:(NSString*)subject andContent:(NSString*)content {
    
    [self pickerMailComposeViewController:viewController andSubject:subject andContent:content];
}


- (void)pickerMessageComposeViewController:(UIViewController*)viewController andContent:(NSString*)content  {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    
    if (messageClass != nil) {
        if ([messageClass canSendText]) {
            MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
            picker.messageComposeDelegate = self;
            picker.body = content;
            [viewController presentViewController:picker animated:YES completion:nil];
        } else {
            [FadePromptView showPromptStatus:@"当前设备暂时没有办法发送短信" duration:1.0 finishBlock:nil];
        }
    } else {
        [FadePromptView showPromptStatus:@"iphone 4.0以上版本支持发送短信" duration:1.0 finishBlock:nil];
    }
}


/**
 *  短信分享
 *
 *  @param content 短信内容
 */
- (void)sendSmsWithContent:(NSString*)content {
    UIViewController *ownen = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([DeviceInfo isOS7]) {
        ownen = [[[[UIApplication sharedApplication] windows] objectAtIndex:0] rootViewController];
    }
    
    [self pickerMessageComposeViewController:ownen andContent:content];
}

/**
 *  短信分享
 *
 *  @param viewController 当前的VC，主要从哪个VC弹出SMS VC
 *  @param content 短信内容
 */
- (void)sendSmsWithViewController:(UIViewController*)viewController andContent:(NSString*)content {
    [self pickerMessageComposeViewController:viewController andContent:content];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    
    // Notifies users about errors associated with the interface
    switch (result) {
        case MessageComposeResultCancelled:
            //用户自己取消，不用提醒
            break;
        case MessageComposeResultSent:
            break;
        case MessageComposeResultFailed:
            [FadePromptView showPromptStatus:@"短信发送失败" duration:1.0 finishBlock:nil];
            break;
        default:
            [FadePromptView showPromptStatus:@"短信没有发送" duration:1.0 finishBlock:nil];
            break;
    }
    
    UIViewController *_ownen = [UIApplication sharedApplication].keyWindow.rootViewController;
    [_ownen dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    switch (result) {
        case MFMailComposeResultCancelled:
            //用户取消，不在提醒
            break;
        case MFMailComposeResultSaved:
            //邮件已经保存，不在提醒
            break;
        case MFMailComposeResultSent:
            break;
        case MFMailComposeResultFailed:
            [FadePromptView showPromptStatus:@"邮件发送失败" duration:1.0 finishBlock:nil];
            break;
        default:
            [FadePromptView showPromptStatus:@"邮件未能发出" duration:1.0 finishBlock:nil];
            break;
    }
    
    UIViewController *_ownen = [UIApplication sharedApplication].keyWindow.rootViewController;
    [_ownen dismissViewControllerAnimated:YES completion:nil];
}

@end
