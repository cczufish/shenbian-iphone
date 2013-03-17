//
//  SBPickerButton.m
//  shenbian
//
//  Created by MagicYang on 10-12-21.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBPickerButton.h"
#import "Utility.h"


#define ButtonWidth  152
#define ButtonHeight 32
#define ButtonTextColorNomarl   [Utility colorWithHex:0x969696]
#define ButtonTextColorSelected [UIColor whiteColor]

@implementation SBPickerButton

- (id)initWithFrame:(CGRect)frame {
	if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, ButtonWidth, ButtonHeight)])) {
        button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		[button setFrame:CGRectMake(0, 0, ButtonWidth, ButtonHeight)];
		[button setBackgroundImage:PNGImage(@"button_search_header") forState:UIControlStateNormal];
		[button addTarget:self action:@selector(buttonTouchDown) forControlEvents:UIControlEventTouchDown|UIControlEventTouchDragInside];
		[button addTarget:self action:@selector(buttonTouchUp) forControlEvents:UIControlEventTouchUpOutside|UIControlEventTouchUpInside|UIControlEventTouchCancel|UIControlEventTouchDragOutside];
		
        button.titleLabel.font = FontWithSize(14);
        button.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 70);
		[self addSubview:button];
		
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title {
    id obj = [self initWithFrame:frame];
	label.text = title;
	return obj;
}

- (void)dealloc {
	[button release];
	[label release];
    [super dealloc];
}

- (void)buttonTouchDown {
	label.textColor = ButtonTextColorSelected;
}

- (void)buttonTouchUp {
	label.textColor = ButtonTextColorNomarl;
}

- (void)setTitle:(NSString *)title {
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}

- (void)setDelegate:(id)delegate andClickAction:(SEL)action {
	[button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
