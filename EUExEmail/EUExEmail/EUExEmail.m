//
//  EUExEMail.m
//  WBPalm
//
//  Created by AppCan on 11-9-8.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "EUExEmail.h"

#import "EUtility.h"
#import "EUExBaseDefine.h"

@implementation EUExEmail


-(void)dealloc{
    mailObj = nil;
}

- (void)open:(NSMutableArray *)inArguments {
    if ([inArguments count] < 2) {
        return;
    }

    NSString * inReceiverEmail = [inArguments objectAtIndex:0];
    NSString * inSubject = [inArguments objectAtIndex:1];
    NSString * inContent = [inArguments count] > 2 ? [inArguments objectAtIndex:2] : @"";
    NSString * inAttachmentPath = [inArguments count] > 3 ?[inArguments objectAtIndex:3] : @"";
    //跳转到发邮件应用，不能返回
    //[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",inReceiverEmail]]];
    //启动一个邮件发送界面，可以返回

    NSMutableDictionary * dict = [[NSMutableDictionary alloc] initWithCapacity:10];
    
    [dict setObject:inReceiverEmail forKey:@"receiver"];
    [dict setObject:inSubject forKey:@"subject"];
    [dict setObject:inContent forKey:@"content"];
    [dict setObject:inAttachmentPath forKey:@"attachment"];
    
    if (!mailObj) {
        mailObj = [[Email alloc] init];
    }
    [mailObj openMailWithUExObj:self argDict:dict];
}




- (void)clean{
    mailObj = nil;
}
@end
