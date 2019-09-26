//
//  Email.h
//  WebKitCorePlam
//
//  Created by AppCan on 11-9-20.
//  Copyright 2011 AppCan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MessageUI/MessageUI.h>

#define IS_NSString(x) ([x isKindOfClass:[NSString class]] && x.length>0)

@class EUExEmail;
@interface Email : NSObject <MFMailComposeViewControllerDelegate>{
	EUExEmail *euexObj;
	NSMutableDictionary *dict;
	MFMailComposeViewController *picker;
}
-(void)launchMailAppOnDevice;
-(void)displayComposerSheet;
-(void)openMailWithUExObj:(EUExEmail *)euexObj_ argDict:(NSMutableDictionary *)inArgDict;
@end
