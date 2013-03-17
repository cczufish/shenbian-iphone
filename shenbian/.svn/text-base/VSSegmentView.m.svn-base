//
//  VSSegmentView.m
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSSegmentView.h"
#import "VSSegmentCell.h"

@implementation VSSegmentView
@synthesize delegate, cells = _items;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		_items = [[NSMutableArray array] retain];
		_selectedIndex = -1;
    }
    return self;
}



- (void)dealloc {
	VSSafeRelease(_items);
    [super dealloc];
}

- (void)addCells:(NSArray*)cells
{
	for (VSSegmentCell* cell in cells) {
		[self addCell:cell];
	}
}

- (void)cleanCells
{
	for (VSSegmentCell* cell in _items) {
		[cell removeFromSuperview];
	}
	[_items removeAllObjects];
	_selectedIndex = -1;
}

- (int)selectedIndex
{
	return _selectedIndex;
}

- (void)setSelectedIndex:(int)value
{
	int previousIndex = _selectedIndex;
	_selectedIndex = value;
	
	if (previousIndex != _selectedIndex) {
		if(previousIndex != -1)
			((VSSegmentCell*)[_items objectAtIndex:previousIndex]).selected = NO;
		((VSSegmentCell*)[_items objectAtIndex:_selectedIndex]).selected = YES;
	}
}

- (void)addCell:(VSSegmentCell*)cell
{
	[cell addTarget:self action:@selector(onCellClicked:) forControlEvents:UIControlEventTouchUpInside];
	[_items addObject:cell];
	[self addSubview:cell];
}

- (void)onCellClicked:(VSSegmentCell*)cell
{
	NSInteger index = [_items indexOfObject:cell];
	NSAssert(index != NSNotFound , @"error on the cell click!");
	
	int previousIndex = _selectedIndex;
    
    //check if need to handle this click event
    if ([self.delegate respondsToSelector:@selector(segment:willClickAtIndex:onCurrentCell:)]) {
        BOOL isNeedHandle = [delegate segment:self willClickAtIndex:index onCurrentCell:self.selectedIndex == previousIndex];
        if (!isNeedHandle) {
            return;
        }
    }
    
	self.selectedIndex = index;		
	
	if ([self.delegate respondsToSelector:@selector(segment:clickedAtIndex:onCurrentCell:)]) {
		[self.delegate segment:self clickedAtIndex:self.selectedIndex onCurrentCell:self.selectedIndex == previousIndex];
	}
}

@end
