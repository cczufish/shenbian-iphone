//
//  SBPopupTextField.m
//  shenbian
//
//  Created by MagicYang on 10-12-22.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBPopupTextField.h"


@implementation SBPopupTextField


- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	
	if (!_textField) {
		_textField = [[UITextField alloc] initWithFrame:CGRectMake(20, rect.size.height - 95, rect.size.width - 40, 30)];
		_textField.delegate = self.delegate;
        _textField.backgroundColor = [UIColor whiteColor];
		_textField.borderStyle = UITextBorderStyleLine;
	}
	
	if (![_textField superview]) {
		[self addSubview:_textField];
	}
}

- (UITextField *)textField {
	return _textField;
}

- (void)dealloc {
	[_textField release];
    [super dealloc];
}

@end
