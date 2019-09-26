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
#import <MobileCoreServices/MobileCoreServices.h>

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
- (void)mailComposeController:(MFMailComposeViewController*)controller_ didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [controller_ dismissViewControllerAnimated:YES completion:nil];
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
    
    NSString *attachPath =[dict objectForKey:@"attachment"];
    if ([attachPath isKindOfClass:[NSString class]] && attachPath.length>0) {
        NSArray *attachPath_ary = [attachPath componentsSeparatedByString:@","];
        for (int i=0; i<[attachPath_ary count]; i++) {
            NSString *str = [euexObj absPath:[attachPath_ary objectAtIndex:i]];
            if ([[NSFileManager defaultManager] fileExistsAtPath:str]) {
                NSData *myData = [NSData dataWithContentsOfFile:str];
                if (myData && [myData length]>0) {
                    NSString *fileExtension = [str pathExtension];
                    NSString *UTI = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExtension, NULL);
                    NSString *mimeType = (__bridge NSString *)UTTypeCopyPreferredTagWithClass((__bridge CFStringRef)UTI, kUTTagClassMIMEType);
                    [picker addAttachmentData:myData mimeType:mimeType?:@"application/octet-stream" fileName:[str lastPathComponent]];
                }
            }
        }
    }
    NSString *inContent = [dict objectForKey:@"content"];
    if (inContent&&[inContent length]>0) {
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy/MM/dd"];
        NSDate *date=[[NSDate alloc] init];
        NSString *content=[[NSString alloc] initWithFormat:@"Date:%@\r\n%@",[dateFormatter stringFromDate:date],inContent];
        NSString *sendContent = [content stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [picker setMessageBody:sendContent isHTML:NO];
        
    }
    [[euexObj.webViewEngine viewController] presentViewController:picker animated:YES completion:nil];

}

-(void)launchMailAppOnDevice{
    NSString *receiver = [dict objectForKey:@"receiver"];
    NSString *subject = [dict objectForKey:@"subject"];
    NSString *content = [dict objectForKey:@"content"];
    NSString *email = [NSString stringWithFormat:@"mailto:%@", receiver];
    if (IS_NSString(subject) || IS_NSString(content)) {
        // 传入的参数中有任何参数不为空，则认为后面有参数，需要先拼个问号
        email = [NSString stringWithFormat:@"%@?",email];
        if (IS_NSString(subject)) {
            email = [NSString stringWithFormat:@"%@subject=%@&", email, subject];
        }
        if (IS_NSString(content)) {
            email = [NSString stringWithFormat:@"%@body=%@&", email, content];
        }
        // 参数之间都有&，结尾的无用可以去掉
        if ([email hasSuffix:@"&"]) {
            email = [email substringToIndex:[email length]-1];
        }
    }
    email = [email stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *emailURL = [NSURL URLWithString:email];
//    [[UIApplication sharedApplication] openURL:emailURL];
    NSLog(@"uexEmail===>open emailURL: %@", emailURL);
    [[UIApplication sharedApplication] openURL:emailURL options:@{} completionHandler:nil];
}

@end
