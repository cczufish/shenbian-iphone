//
//  SBSegmentView.m
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBSegmentView.h"
#import "SBSegmentCell.h"

@implementation SBSegmentView

- (id)init{
	self = [super initWithFrame:CGRectMake(0, 0, 0, SBSegmentCellHeight)];
	return self;		
}


- (void)setDatasource:(NSArray*)source
{
	int count = [source count];
	[self cleanCells];
	
	for (int i = 0; i< count; i++) {
		NSString* title = [source objectAtIndex:i];

		SBSegmentCellType type = i == 0 ? SBSegmentCellTypeLeft : (i == count -1 ? SBSegmentCellTypeRight : SBSegmentCellTypeMid);
		SBSegmentCell* cell = [[SBSegmentCell alloc] initWithType:type title:title];
		[self addCell:cell];
		cell.left = i * SBSegmentCellWidth;
		[cell release];
	}

    self.width = [_items count] * SBSegmentCellWidth;
}

- (void)setCellWidth:(CGFloat)w
{
    self.width = [_items count] * w;
    int cnt= 0;
    for (SBSegmentCell* cell in _items) {
		[cell setCellWidth:w];
        cell.left = cnt * w;
        cnt++;
	}
}

@end
