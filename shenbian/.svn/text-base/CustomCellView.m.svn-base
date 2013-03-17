//
//  CustomCellView.m
//  shenbian
//
//  Created by MagicYang on 10-11-24.
//  Copyright 2010 personal. All rights reserved.
//

#import "CustomCellView.h"


@implementation CustomCellView
@synthesize dataModel;
@synthesize noSeperator;

- (id)initWithFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setDataModel:(id)model {
	if ([dataModel isEqual:model]) {
		return;
	}
	
	[dataModel release];
	dataModel = [model retain];
}

- (void)dealloc {
	[dataModel release];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)data {
	// Implements by subclass
	NSAssert(NO, @"Must implements by subclass");
	return 0;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	
	[self setNeedsDisplay];
}


- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	isHighlighted = highlighted;
	[self setNeedsDisplay];
}

@end
