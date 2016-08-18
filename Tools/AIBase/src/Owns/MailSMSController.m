//
//  MailSMSController.m
//  CommonProject
//
//  Created by wuyoujian on 16/5/13.
//  Copyright © 2016年 wuyoujian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MailSMSController.h"
#import "../Owns/FadePromptView.h"

@interface MailSMSController ()

@property (nonatomic, copy) SendFinishBlock finishBlock;

@end


@implementation MailSMSController

+ (MailSMSController *)sharedMailSMSController {
    
    static MailSMSController *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [[self alloc] init];
    });
    return obj;
}

- (void)dealloc {
    self.finishBlock = nil;
}

/**
 *  邮件分享
 *  @param viewController 当前的VC，主要从哪个VC弹出邮件VC
 *  @param subject 邮件主题
 *  @param content 邮件内容
 */

- (void)pickerMailComposeViewController:(UIViewController*)viewController andSubject:(NSString*)subject andContent:(NSString*)content finish:(SendFinishBlock)finishBlock {
    
    Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
    self.finishBlock = finishBlock;
    
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

/**
 *  短信分享
 *
 *  @param viewController 当前的VC，主要从哪个VC弹出SMS VC
 *  @param content 短信内容
 */
- (void)pickerMessageComposeViewController:(UIViewController*)viewController andContent:(NSString*)content finish:(SendFinishBlock)finishBlock {
    
    Class messageClass = (NSClassFromString(@"MFMessageComposeViewController"));
    self.finishBlock = finishBlock;
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

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {

    // Notifies users about errors associated with the interface
    switch (result) {
        case MessageComposeResultCancelled:
            //用户自己取消，不用提醒
            if (_finishBlock) {
                _finishBlock(SendTypeSMS,SendStatusCancel);
            }
            break;
        case MessageComposeResultSent:
            if (_finishBlock) {
                _finishBlock(SendTypeSMS,SendStatusSuccess);
            }
            
            break;
        case MessageComposeResultFailed:
            if (_finishBlock) {
                _finishBlock(SendTypeSMS,SendStatusFail);
            }
            
            break;
        default:
            if (_finishBlock) {
                _finishBlock(SendTypeSMS,SendStatusFail);
            }
            
            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    
    
    switch (result) {
        case MFMailComposeResultCancelled:
            //用户取消，不在提醒
            if (_finishBlock) {
                _finishBlock(SendTypeMail,SendStatusCancel);
            }
            
            break;
        case MFMailComposeResultSaved:
            //邮件已经保存，不在提醒
            //
            if (_finishBlock) {
                _finishBlock(SendTypeMail,SendStatusSave);
            }
            
            break;
        case MFMailComposeResultSent:
            if (_finishBlock) {
                _finishBlock(SendTypeMail,SendStatusSuccess);
            }
            
            break;
        case MFMailComposeResultFailed:
            if (_finishBlock) {
                _finishBlock(SendTypeMail,SendStatusFail);
            }
            break;
        default:
            if (_finishBlock) {
                _finishBlock(SendTypeMail,SendStatusFail);
            }
            

            break;
    }
    
    [controller dismissViewControllerAnimated:YES completion:nil];
}

@end
