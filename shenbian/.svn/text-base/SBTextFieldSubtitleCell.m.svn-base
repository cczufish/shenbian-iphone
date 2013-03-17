//
//  SBTextFieldSubtitleCell.m
//  shenbian
//
//  Created by Leeyan on 11-5-18.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBTextFieldSubtitleCell.h"


@implementation SBTextFieldSubtitleCell

@synthesize subtitle, subtitleLabel;

- (id)initWithDelegate:(id)del reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithDelegate:del reuseIdentifier:reuseIdentifier]) {
		
		UILabel* _subtitleLabel = [[UILabel alloc] initWithFrame:vsr(12, 32, 280, 24)];
		self.subtitleLabel = _subtitleLabel;
		subtitleLabel.backgroundColor = [UIColor clearColor];
		
		subtitleLabel.textColor = [UIColor colorWithRed:0.618 green:0.618 blue:0.618 alpha:1];
		
		subtitleLabel.font = FontWithSize(12);
		
		[self.contentView addSubview:self.subtitleLabel];
		[_subtitleLabel release];
		
		[self addObserver:self
			   forKeyPath:@"subtitle"
				  options:NSKeyValueObservingOptionNew
				  context:nil];
	}
	return self;
}

- (void)dealloc
{
	VSSafeRelease(subtitle);
	[self removeObserver:self forKeyPath:@"subtitle"];
	
	[super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath 
					  ofObject:(id)object 
						change:(NSDictionary *)change 
					   context:(void *)context
{
	if ([keyPath isEqualToString:@"subtitle"]) {
		self.subtitleLabel.text = [change objectForKey:@"new"];
	}
}

@end
