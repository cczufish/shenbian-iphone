//
//  SBSearchBar.m
//  shenbian
//
//  Created by MagicYang on 10-12-14.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBSearchBar.h"


@implementation SBSearchBar

@synthesize isAlwaysShowHistoryButton;
@synthesize isAlwaysHideHistoryButton;
@synthesize delegate;
@synthesize searchText;


- (id)initWithFrame:(CGRect)frame delegate:(id)del andTitleView:(UIView *)ttView {
	if ((self = [super initWithFrame:frame])) {
		self.delegate = del;
		self.backgroundColor = [UIColor colorWithRed:0.871 green:0.843 blue:0.776 alpha:1];
        
		titleView = [ttView retain];
        titleView.frame = CGRectMake(18, 14, 20, 15);
        titleView.contentMode = UIViewContentModeLeft;
		titleView.backgroundColor = [UIColor clearColor];
		
        UIImageView *borderBackground = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 300, 32)];
        borderBackground.image = PNGImage(@"searchbar_bg");
        
		textField = [[UITextField alloc] initWithFrame:CGRectMake(45, 8, 260, 27)];
		textField.delegate = self;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
		textField.backgroundColor = [UIColor clearColor];
		textField.returnKeyType = UIReturnKeySearch;
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.enablesReturnKeyAutomatically = YES;
		textField.font = FontLiteWithSize(16);
		textField.autocapitalizationType = NO;
        textField.autocorrectionType = NO;
        
		historyButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		historyButton.frame = CGRectMake(275, 12, 26, 18);
		[historyButton addTarget:self action:@selector(showHistory:) forControlEvents:UIControlEventTouchUpInside];
		[historyButton setImage:PNGImage(@"button_searchbar_bookmark") forState:UIControlStateNormal];
		
        [self addSubview:borderBackground];
        [self addSubview:titleView];
		[self addSubview:textField];
        
        [borderBackground release];
        
        [textField addTarget:self action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
	}
	return self;
}

- (void)dealloc {
	[textField release];
	[titleView release];
	[historyButton release];
	[searchText release];
	[super dealloc];
}

- (void)setPlaceHolder:(NSString *)txt {
	textField.placeholder = txt;
}

- (void)showHistoryButton {
	if (isAlwaysHideHistoryButton) {
		return;
	}
	
	if (![historyButton superview]) {
		[self addSubview:historyButton];
	}
}

- (void)hideHistoryButton {
	if (isAlwaysShowHistoryButton) {
		return;
	}
	
	if ([historyButton superview]) {
		[historyButton removeFromSuperview];
	}
}

- (void)showSawtooth {
    if (!sawtooth) {
        sawtooth = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.height, 320, 6)];
        sawtooth.image = PNGImage(@"searchbar_sawtooth");
    }
    
    if (![sawtooth superview]) {
        [self addSubview:sawtooth];
    }
}

- (void)hideSawtooth {
    [sawtooth removeFromSuperview];
}

- (BOOL)becomeFirstResponder {
	return [textField becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
	return [textField resignFirstResponder];
}

- (BOOL)isFirstResponder {
	return [textField isFirstResponder];
}

- (void)disable {
	textField.userInteractionEnabled = NO;
	// TODO:禁用效果
//	self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
}

- (void)setSearchText:(NSString *)text {
	if ([searchText isEqual:text]) {
		return;
	}
	[searchText release];
	searchText = [text retain];
    
	[self hideHistoryButton];
}

- (void)showHistory:(id)sender {
	if ([delegate respondsToSelector:@selector(showHistory:)]) {
		[delegate performSelector:@selector(showHistory:) withObject:self];
	}
}


// Capture from value change event of UIControl
- (void)searchTextChanged:(id)sender
{
    if (![self.searchText isEqualToString:((UITextField *)sender).text]) {
        self.searchText = ((UITextField *)sender).text;
        if ([delegate respondsToSelector:@selector(searchBarDidChange:)]) {
            [delegate performSelector:@selector(searchBarDidChange:) withObject:self];
        }
    }
}

#pragma mark -
#pragma mark UITextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)tf {
	if ([tf.text length] > 0) {
		[self hideHistoryButton];
	} else {
		[self showHistoryButton];
	}

	if ([delegate respondsToSelector:@selector(searchBarDidBeginEditing:)]) {
		[delegate performSelector:@selector(searchBarDidBeginEditing:) withObject:self];
	}
}

- (BOOL)textFieldShouldClear:(UITextField *)tf {
	[self showHistoryButton];

	if ([delegate respondsToSelector:@selector(searchBarCleared:)]) {
		[delegate performSelector:@selector(searchBarCleared:) withObject:self];
	}
	
	return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)tf {
	[self hideHistoryButton];
	
	if ([delegate respondsToSelector:@selector(searchBarDidEndEditing:)]) {
		[delegate performSelector:@selector(searchBarDidEndEditing:) withObject:self];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)tf {
	if ([delegate respondsToSelector:@selector(searchBarSearch:)]) {
		[delegate performSelector:@selector(searchBarSearch:) withObject:self];
	}
	return YES;
}

@end
