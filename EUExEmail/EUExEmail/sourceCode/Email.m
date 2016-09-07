//
//  Email.m
//  WebKitCorePlam
//
//  Created by AppCan on 11-9-20.
//  Copyright 2011 AppCan. All rights reserved.
//

#import "Email.h"
#import "EUExEMail.h"
#import "EUtility.h"

@implementation Email

-(void)openMailWithUExObj:(EUExEmail *)euexObj_ argDict:(NSMutableDictionary *)inArgDict{
    euexObj = euexObj_;
	dict = inArgDict;
	Class mailClass = (NSClassFromString(@"MFMailComposeViewController"));
	if (mailClass != nil)
	{
		if ([mailClass canSendMail]) {
			[self displayComposerSheet];
		} else {
			[self launchMailAppOnDevice];
		}
	} else {
		[self launchMailAppOnDevice];
	}
	
}
// Dismisses the email composition interface when users tap Cancel or Send. Proceeds to update the message field with the result of the operation.
- (void)mailComposeController:(MFMailComposeViewController*)controller_ didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
	//	message.hidden = NO;
	// Notifies users about errors associated with the interface
	switch (result)
	{
		case MFMailComposeResultCancelled:
			//message.text = @"Result: canceled";
            //	[euexObj jsFailedWithOpId:0 errorCode:134 errorDes:@"取消发送"];
			break;
		case MFMailComposeResultSaved:
			break;
		case MFMailComposeResultSent:
			//message.text = @"Result: sent";
			break;
		case MFMailComposeResultFailed:
            //	[euexObj jsFailedWithOpId:0 errorCode:123 errorDes:@"发送失败"];
			break;
		default:
			//	message.text = @"Result: not sent";
			break;
	}
	[controller_ dismissModalViewControllerAnimated:YES];
}

-(void)displayComposerSheet
{
	picker = [[MFMailComposeViewController alloc] init];
	picker.title=UEX_LOCALIZEDSTRING(@"新建邮件");
	picker.mailComposeDelegate = self;
	NSString *subjectStr = [[dict objectForKey:@"subject"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	if (subjectStr&&[subjectStr length]>0) {
		[picker setSubject:subjectStr];
	}
	
	NSString *recipient = [dict objectForKey:@"receiver"];
	if ([recipient isKindOfClass:[NSString class]] && [recipient length]>0) {
        NSArray *toRecipients = [recipient componentsSeparatedByString:@","];
		[picker setToRecipients:toRecipients];
	}
    
	//	NSArray *ccRecipients = [NSArray arrayWithObjects:@"second@example.com", @"third@example.com", nil];
	//	NSArray *bccRecipients = [NSArray arrayWithObject:@"fourth@example.com"];
	//	[picker setCcRecipients:ccRecipients];
	//	[picker setBccRecipients:bccRecipients];
    
    NSString *attachPath =[dict objectForKey:@"attachment"];
    NSString *mimeType = [dict objectForKey:@"mimeType"];
    if ([attachPath isKindOfClass:[NSString class]] && attachPath.length>0 && mimeType &&mimeType.length >0) {
        NSArray *attachPath_ary = [attachPath componentsSeparatedByString:@","];
        for (int i=0; i<[attachPath_ary count]; i++) {
            NSString *str = [euexObj absPath:[attachPath_ary objectAtIndex:i]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
                NSData *myData = [NSData dataWithContentsOfFile:str];
                if (myData && [myData length]>0) {
                    [picker addAttachmentData:myData mimeType:mimeType fileName:[str lastPathComponent]];
                }
            }
        }
    }
	NSString *inContent = [dict objectForKey:@"content"];
	if (inContent&&[inContent length]>0) {
		NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy/MM/dd"];
		NSDate *date=[[NSDate alloc] init];
		NSString *content=[[NSString alloc]
                        initWithFormat:@"Date:%@\r\n%@",[dateFormatter stringFromDate:date],inContent];
		NSString *sendContent = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		[picker setMessageBody:sendContent isHTML:NO];
		
	}
    
    [[euexObj.webViewEngine viewController] presentViewController:picker animated:YES completion:nil];
}
-(void)launchMailAppOnDevice{
	NSString *recipients = [NSString stringWithFormat:@"mailto:%@&subject=%@",[dict objectForKey:@"receiver"],[dict objectForKey:@"suject"]];
	NSString *body = [NSString stringWithFormat:@"&body=%@",[dict objectForKey:@"content"]];
	NSString *email = [NSString stringWithFormat:@"%@%@", recipients, body];
	email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
	
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:email]];
}
-(void)dealloc{
	
}
@end
