//
//  VSSegmentCell.m
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSSegmentCell.h"

@interface VSSegmentCell ()

- (void)onViewDidBecameNormal;
- (void)onViewDidBecameSelected;

@end


@implementation VSSegmentCell


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}


#pragma mark -
#pragma mark override for defaults uicontrol actions

- (void)setSelected:(BOOL)value
{
	[super setSelected:value];
	if (value) {
		[self onViewDidBecameSelected];
	}else {
		[self onViewDidBecameNormal];
	}

}
/*
- (void)setHighlighted:(BOOL)value
{
	[super setHighlighted:value];
	if (value) {
		[self onViewDidBeingHovering];
	}else {
		[self onViewDidBecameNormal];
	}

}*/

#pragma mark -
#pragma mark implement these methods on your subclass

- (void)onViewDidBecameNormal
{
	
}

- (void)onViewDidBecameSelected
{
	
}


@end
