//
//  VSCommentView.h
//  shenbian
//
//  Created by Leeyan on 11-6-21.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VSCommentView : UIView <UITextViewDelegate> {
	UIImageView *bgTextImageView;
	NSString *m_comment;
	UITextView *m_textView;
	UIButton *btnCommit;
	UIButton *btnCancel;
	
	id m_delegate;
	SEL m_commitSelector;
	SEL m_cancelSelector;
    NSString *m_defaultToText;
}

@property(nonatomic, retain) UITextView *textView;
@property(nonatomic, assign) id withOjbAssign;
@property(assign) id extra;

+ (void)showWithComment:(NSString *)comment andDelegate:(id)delegate 
			   onCommit:(SEL)commitSelector onCancel:(SEL)cancelSelector andExtra:(id)extra;

@end

