//
//  SBSubcategoryTabView.m
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBSubcategoryTabView.h"

#define SBSubcategoryTabViewHeight  31
#define SBSubcategoryTabViewWidth 72

@implementation SBSubcategoryTabView
@synthesize segmentView = _segmentView;
- (id)initWithFixedSize
{
	self = [self initWithFrame:CGRectMake(0, 0, 320, 31)];	
	return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		self.bounces = YES;
		self.backgroundColor = [UIColor clearColor];
		self.scrollsToTop = NO;
//		self.decelerationRate = UIScrollViewDecelerationRateFast;
		self.showsHorizontalScrollIndicator = NO;
		self.showsVerticalScrollIndicator = NO;
		_segmentView = [[SBSubcategoryTabCellWrapper alloc] initWithFrame:CGRectMake(0, 0, 0, SBSubcategoryTabViewHeight)];
		[self addSubview:_segmentView];
    }
    return self;
}

- (void)dealloc
{
	VSSafeRelease(_segmentView);
    [super dealloc];
}


- (void)setDatasource:(NSArray*)source
{
	_innerContentWidth = 0;
	[_segmentView cleanCells];
	for (NSString* title in source) {
		SBSubcategoryTabCell* cellView = [[SBSubcategoryTabCell alloc] initWithFrame:CGRectMake(_innerContentWidth, 0, SBSubcategoryTabViewWidth, SBSubcategoryTabViewHeight) name:title];
		[_segmentView addCell:cellView];
		[cellView release];
		_innerContentWidth = cellView.right;
	}
	int finalWidth = MAX(_innerContentWidth,320);
	_segmentView.width = finalWidth;
	
	[_segmentView setNeedsDisplay];
	self.contentSize = _segmentView.bounds.size;
	self.contentOffset = CGPointZero;
	
}

- (void)setDelegate:(id <VSSegmentViewDelegate>)adelegate
{
	_segmentView.delegate = adelegate;
}

- (id)delegate{
	return _segmentView.delegate;
}

@end
