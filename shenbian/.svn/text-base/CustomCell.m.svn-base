//
//  CustomCell.m
//  shenbian
//
//  Created by MagicYang on 10-11-24.
//  Copyright 2010 personal. All rights reserved.
//

#import "CustomCell.h"
#import "CustomCellView.h"
#import "Utility.h"


@implementation CustomCell

@synthesize cellView;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) {
		[self.contentView addSubview:cellView];
		self.backgroundColor = [UIColor clearColor];
		self.contentView.frame = self.frame;
    }
	return self;
}

- (void)setCellView:(CustomCellView *)view {
	if ([cellView isEqual:view])
		return;
	
	[cellView removeFromSuperview];
	[cellView release];
	cellView = [view retain];
	
	cellView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	[self.contentView addSubview:cellView];
}

- (void)setDataModel:(id)model {
	cellView.dataModel = model;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
	[cellView setHighlighted:highlighted animated:animated];
}

- (void)dealloc {
	[cellView release];
    [super dealloc];
}

@end
