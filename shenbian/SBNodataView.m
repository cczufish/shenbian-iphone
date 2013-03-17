//
//  SBNodataView.m
//  shenbian
//
//  Created by MagicYang on 11-1-27.
//  Copyright 2011 personal. All rights reserved.
//

#import "SBNodataView.h"


@implementation SBNodataView


- (id)initWithFrame:(CGRect)frame andPrompt:(NSString *)text {
    if ((self = [super initWithFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 416)])) {
		self.userInteractionEnabled = YES;
		self.image = PNGImage(@"nodata_bg");
		label = [[UILabel alloc] initWithFrame:CGRectMake(10, 180, 300, 60)];
		label.numberOfLines = 3;
		label.font = FontWithSize(18);
		label.textAlignment = UITextAlignmentCenter;
		label.text = text;
		label.backgroundColor = [UIColor clearColor];
		[self addSubview:label];
    }
    return self;
}

- (void)setPrompt:(NSString *)text {
	label.text = text;
}

- (void)dealloc {
	[label release];
	[super dealloc];
}

@end
