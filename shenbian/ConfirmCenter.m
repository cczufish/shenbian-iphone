//
//  ComfirmCenter.m
//  shenbian
//
//  Created by MagicYang on 5/30/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "ConfirmCenter.h"


@implementation ConfirmCenter

@synthesize delegate, selector;

- (id)init {
	if((self = [super init])) {
		confirmView = [[UIAlertView alloc] init];
		confirmView.delegate = self;
        [confirmView addButtonWithTitle:@"取消"];
		[confirmView addButtonWithTitle:@"确定"];
        confirmView.cancelButtonIndex = 0;
        isShow = NO;
	}
	return self;
}

- (void)dealloc {
	[confirmView release];
	[super dealloc];
}


#pragma mark -
#pragma mark PublicMethods
+ (id)sharedInstance {
	static id instance = nil;
	if(!instance) {
		@synchronized([ConfirmCenter class]) {
			instance = [[ConfirmCenter alloc] init];
		}
	}
	return instance;
}

- (void)confirmAction:(SEL)sel forObject:(id)obj withPromptText:(NSString *)text
{
    if(!isShow) {
        self.delegate = obj;
        self.selector = sel;
        confirmView.message = text;
        isShow = YES;
        [confirmView show];
    }
}


#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
	isShow = NO;
    if (buttonIndex != alertView.cancelButtonIndex) {
        if ([delegate respondsToSelector:selector]) {
            [delegate performSelector:selector];
        }
    }
    self.delegate = nil;
    self.selector = nil;
}

@end
