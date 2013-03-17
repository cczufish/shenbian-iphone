//
//  AlertCenter.m
//  shenbian
//
//  Created by MagicYang on 2/14/11.
//  Copyright 2011 personal. All rights reserved.
//

#import "AlertCenter.h"

@interface AlertCenter(PrivateMethods)

- (NSString *)titleForRequestType:(int)requestType;
- (NSString *)messageForError:(NSError *)error;

@end


@implementation AlertCenter

@synthesize sharedAlertView;

- (id)init {
	if((self = [super init])) {
		UIAlertView *alertView = [[UIAlertView alloc] init];
		alertView.delegate = self;
		[alertView addButtonWithTitle:@"好的"];
		self.sharedAlertView = alertView;
		[alertView release];
		isShow = NO;
	}
	return self;
}

- (void)dealloc {
	self.sharedAlertView = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark PublicMethods
+ (id)sharedInstance {
	static id instance = nil;
	
	if(!instance) {
		@synchronized([AlertCenter class]) {
			instance = [[AlertCenter alloc] init];
		}
	}
	return instance;
}


- (void)showAlertWithTitle:(NSString*)titleText andMessage:(NSString*)msgText {
	if(!isShow) {
		sharedAlertView.title = titleText;
		sharedAlertView.message = msgText;
		[sharedAlertView show];
		isShow = YES;
	}
}

- (void)showAlertWithError:(NSError*)error {
	[self showAlertWithError:error requestType:0];
}

- (void)showAlertWithError:(NSError*)error requestType:(int)requestType {
	NSString* title = (0 == requestType) ? nil : [self titleForRequestType:requestType];
	[self showAlertWithTitle:title andMessage:[self messageForError:error]];
}


- (void)showAlertWithErrorCode:(NSInteger)errorCode {
	NSString *title, *message;
	switch (errorCode) {
		case 400: {
			title   = @"网络错误";
			message = @"无法连接到服务器, 请检查您的网络连接后重试.";
		} break;
		case 403: {
			title   = @"错误";
			message = @"帐号验证失败, 用户名或密码错误.";
		} break;
		case 404: {
			title   = @"错误";
			message = @"请求的资源无法找到.";
		} break;
		case -1001: {
			title   = nil;
			message = @"请求超时";
		} break;
		case -1003:
		case -1004:
		{
			title   = @"网络错误";
			message = @"无法连接到服务器, 请检查您的网络连接后重试.";
		} break;
		case -1009: {
			title   = @"网络错误";
			message = @"您还没有联网, 请检查您的网络连接后重试.";
		} break;
		default: {
			title   = @"错误";
			message = [NSString stringWithFormat:@"未知错误,Code:%d", errorCode];
		} break;
	}
	[self showAlertWithTitle:title andMessage:message];
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	isShow = NO;
}


#pragma mark -
#pragma mark PrivateMethods
- (NSString*)titleForRequestType:(int)requestType {
	// TODO: switch-case, return title with type
	return nil;
}

- (NSString*)messageForError:(NSError*)error {
	// TODO: switch-case, return message with type
	return nil;
}


@end
