//
//  FeedbackViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-30.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"


@class HttpRequest;

@interface FeedbackViewController : SBTableViewController
<UITextFieldDelegate, UITextViewDelegate> {
	UITextView *tv;
	UITextField *tf;
	
	NSString *shopId;
	
	NSString *content, *email;
	
	HttpRequest *request;
}

@property(nonatomic, retain) NSString *shopId;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, retain) NSString *email;

- (void)showSubmitButton;

@end
