//
//  TreasureView.m
//  shenbian
//
//  Created by Leeyan on 11-5-10.
//  Copyright 2011 百度. All rights reserved.
//

#import "TreasureView.h"
#import "Utility.h"


@implementation TreasureView


- (id)initWithFrame:(CGRect)frame treasures:(NSDictionary*)treasures{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		_iTreasureCellHeight = 40;
		_iTreasureCellWidth = 296;
		_iTreasureLeft = 12;
		_iTreasureTop = 12;
		
		_treasures = [treasures retain];
    }
    return self;
}

- (int)_getTreasureCellTopAt:(unsigned int)idx
{
	return _iTreasureCellHeight * idx;
}

- (unsigned int)getViewHeight
{
	unsigned int uCnt = [[self treasures] count];
	
	return uCnt * _iTreasureCellHeight;
}

- (unsigned int)getViewWidth
{
	return _iTreasureCellWidth;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
	// Drawing code.
	self.backgroundColor = [UIColor whiteColor];

	UILabel* actLabel;
	
	unsigned int idx = 0;
	int iCellTop;
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetLineWidth(context, 2);
	CGContextSetStrokeColorWithColor(context, [UIColor redColor].CGColor);
	
	for (id key in _treasures)
	{
		iCellTop = [self _getTreasureCellTopAt:idx];
		
		if (0 == idx) {
			CGContextMoveToPoint(context, iCellTop, 0);
			CGContextAddLineToPoint(context, iCellTop, _iTreasureCellWidth);
		}
		//	action
		actLabel = [[UILabel alloc] initWithFrame:
					vsr(0, iCellTop + 1, _iTreasureCellWidth, _iTreasureCellHeight - 1)];
		actLabel.text = (NSString*)key;
		actLabel.font = [UIFont systemFontOfSize:14.0f];
		actLabel.textColor = [UIColor blackColor];
		
		[self addSubview:actLabel];
		[actLabel release];
		
		//	plus
		actLabel = [[UILabel alloc] initWithFrame:
					vsr(200, iCellTop, 32, _iTreasureCellHeight)];
		actLabel.text = @"+5";
		actLabel.font = [UIFont systemFontOfSize:24.0f];
		//		actLabel.textAlignment = UITextAlignmentRight;
		actLabel.textColor = [UIColor redColor];
		
		[self addSubview:actLabel];
		[actLabel release];
		
		//	treasure label
		actLabel = [[UILabel alloc] initWithFrame:
					vsr(240, iCellTop, 40, _iTreasureCellHeight)];
		actLabel.text = @"财富值";
		actLabel.font = [UIFont systemFontOfSize:11.75f];
		actLabel.textColor = [Utility colorWithHex:0x858585];
		
		[self addSubview:actLabel];
		[actLabel release];
		
		idx++;
	}
	
	CGContextStrokePath(context);
	
}


- (void)dealloc {
	[_treasures release];
	
    [super dealloc];
}



@end
