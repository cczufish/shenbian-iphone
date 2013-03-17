//
//  CancelView.m
//
//  Created by MagicYang on 11/10/09.
//  Copyright 2010 personal. All rights reserved.
//

#import "CancelView.h"


@implementation CancelView

- (id)initWithFrame:(CGRect)frame bgColor:(UIColor*)color andDelegate:(id)del {
    if (self = [super initWithFrame:frame]) {
		self.backgroundColor = color;
		delegate = del;
		self.userInteractionEnabled = YES;
    }
    return self;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	if([delegate respondsToSelector:@selector(touchCancelView)])
		[delegate touchCancelView];
}

- (void)dealloc {
    [super dealloc];
}


@end
