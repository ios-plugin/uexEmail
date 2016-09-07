//
//  EUExEMail.h
//  WBPalm
//
//  Created by AppCan on 11-9-8.
//  Copyright 2011 AppCan. All rights reserved.
//



#import "Email.h"

@interface EUExEmail : EUExBase {
	Email *mailObj;
}
/**
 * 打开系统发送邮件界面
 * 
 * @param inReceiverEmail
 *            接受者邮箱地址
 *@param inSubject
 *            邮件主题
 *@param inContent
 *            邮件正文
 *@param inAttachmentPath
 *            邮件附件路径
 */
 @end
