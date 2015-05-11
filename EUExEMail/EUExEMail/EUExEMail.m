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

-(id)initWithBrwView:(EBrowserView *) eInBrwView{
	if (self = [super initWithBrwView:eInBrwView]) {
	}
	return self;
}

-(void)dealloc{
    if (mailObj) {
        [mailObj release];
        mailObj = nil;
    }
	[super dealloc];
}

-(void)open:(NSMutableArray *)inArguments {
	NSString *inReceiverEmail = [inArguments objectAtIndex:0];
	NSString *inSubject = [inArguments objectAtIndex:1];
	NSString *inContent = [inArguments objectAtIndex:2];
	NSString *inAttachmentPath = [inArguments objectAtIndex:3];
	//跳转到发邮件应用，不能返回
	//[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"mailto://%@",inReceiverEmail]]];
    //启动一个邮件发送界面，可以返回
	if (inReceiverEmail == nil) {
		[super jsFailedWithOpId:0 errorCode:1080101 errorDes:UEX_ERROR_DESCRIBE_ARGS];
		return;
	}
	NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:10];
	[dict setObject:inReceiverEmail forKey:@"receiver"];
	[dict setObject:inSubject forKey:@"subject"];
	[dict setObject:inContent forKey:@"content"];
	[dict setObject:inAttachmentPath forKey:@"attachment"];
	if (!mailObj) {
		mailObj = [[Email alloc] init];
	}
	[mailObj openMailWithUExObj:self argDict:dict];
	[dict removeAllObjects];
	[dict release];
}

-(void)clean{
	if (mailObj) {
		[mailObj release];
		mailObj = nil;
	}
}
@end
