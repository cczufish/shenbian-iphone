//
//  VSCommentView.m
//  shenbian
//
//  Created by Leeyan on 11-6-21.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSCommentView.h"
#import "AppDelegate.h"
#import "AlertCenter.h"

@interface VSCommentView()

- (UIButton *)buttonCommit;
- (UIButton *)buttonCancel;
- (UITextView *)getTextView;
- (UIImageView *)bgTextImageView;

- (id)initWithCommentString:(NSString *)comment delegate:(id)delegate
				   onCommit:(SEL)commitSelector onCancel:(SEL)cancelSelector;

- (void)CommentInputDidFinished;

@end


@implementation VSCommentView

static VSCommentView *instance;

@synthesize textView = m_textView;
@synthesize withOjbAssign;
@synthesize extra;

+ (void)showWithComment:(NSString *)comment andDelegate:(id)delegate 
			   onCommit:(SEL)commitSelector onCancel:(SEL)cancelSelector andExtra:(id)extra {
	instance = [[VSCommentView alloc] initWithCommentString:comment
												   delegate:delegate
												   onCommit:commitSelector
												   onCancel:cancelSelector];
	instance.extra = extra;
	UIWindow *win = [AppDelegate sharedDelegate].window;
	win.windowLevel = UIWindowLevelNormal;
	[win addSubview:instance];
	[instance.textView becomeFirstResponder];
}


- (id)initWithCommentString:(NSString *)comment delegate:(id)delegate
				   onCommit:(SEL)commitSelector onCancel:(SEL)cancelSelector {
	if ((self = [super initWithFrame:[UIScreen mainScreen].bounds])) {
		m_delegate = delegate;
		m_comment = comment;
		m_commitSelector = commitSelector;
		m_cancelSelector = cancelSelector;
        m_defaultToText = [comment retain];
        
		btnCommit = [[self buttonCommit] retain];
		
		btnCancel = [[self buttonCancel] retain];
		
		m_textView = [[self getTextView] retain];
		
		bgTextImageView = [[self bgTextImageView] retain];
		
		self.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
		
		[self addSubview:bgTextImageView];
		[self addSubview:m_textView];
		[self addSubview:btnCancel];
		[self addSubview:btnCommit];
		
		[btnCommit addTarget:self action:@selector(onCommitPressed) forControlEvents:UIControlEventTouchUpInside];
		[btnCancel addTarget:self action:@selector(onCancelPressed) forControlEvents:UIControlEventTouchUpInside];
	}
	return self;
}

- (void)onCommitPressed {
	if ([[m_textView.text stringByTrimmingCharactersInSet:
		  [NSCharacterSet whitespaceAndNewlineCharacterSet]] isEmpty]
		&& m_textView.text.length > 0) {
		Alert(@"", @"请说点什么");
		return;
	}
	[self CommentInputDidFinished];
	if ([m_delegate respondsToSelector:m_commitSelector]) {
        NSString *submitStr=m_textView.text;
        if (m_defaultToText != nil && [m_defaultToText isEqualToString:[m_textView.text substringToIndex:[m_defaultToText length]]]) {
           
            NSRange tempRange=NSMakeRange([m_defaultToText length], [submitStr length]-[m_defaultToText length]);
            submitStr=[submitStr substringWithRange:tempRange];
        }
		[m_delegate performSelector:m_commitSelector withObject:submitStr withObject:self.extra];
	}
}

- (void)onCancelPressed {
	[self CommentInputDidFinished];
	if ([m_delegate respondsToSelector:m_cancelSelector]) {
		[m_delegate performSelector:m_cancelSelector withObject:self.extra];
	}
}

- (void)CommentInputDidFinished {
	[m_textView resignFirstResponder];
	[self removeFromSuperview];
}

- (UIButton *)buttonCommit {
	UIImage *img = PNGImage(@"btn_check");
	UIButton *button = [[UIButton alloc] initWithFrame:vsr(258, 229, img.size.width, img.size.height)];
	[button setBackgroundImage:img forState:UIControlStateNormal];
	return [button autorelease];
}

- (UIButton *)buttonCancel {
	UIImage *img = PNGImage(@"btn_cross");
	UIButton *button = [[UIButton alloc] initWithFrame:vsr(11, 229, img.size.width, img.size.height)];
	[button setBackgroundImage:img forState:UIControlStateNormal];
	return [button autorelease];
}

- (UITextView *)getTextView {
	UITextView *textView = [[UITextView alloc] initWithFrame:vsr(11, 24, 298, 196)];
	textView.textColor = [UIColor blackColor];
	textView.backgroundColor = [UIColor clearColor];
	textView.delegate = self;
	textView.font = FontWithSize(16);
	textView.text = m_comment;
	
	return [textView autorelease];
}

- (UIImageView *)bgTextImageView {
	UIImage *bg = PNGImage(@"photosubmit_tf_bg");
	bg = [bg stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:vsr(11, 20, 298, 204)];
	bgImageView.image = bg;
	return [bgImageView autorelease];
}

- (void)dealloc {
	[m_defaultToText release];
	[bgTextImageView release];
	[m_textView release];
	[btnCancel release];
	[btnCommit release];
	
    [super dealloc];
}


@end
