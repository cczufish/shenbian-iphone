//
//  SearchResultsHeader.m
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import "SearchResultsHeader.h"
#import "Utility.h"
#import "SBPickerButton.h"
#import "SBSubcategoryTabView.h"
#import "UIAdditions.h"


@implementation SearchResultsHeader

@synthesize delegate;
@synthesize leftTitle, rightTitle;

- (id)initWithDelegate:(id)del andFrame:(CGRect)frame {
    if ((self = [super initWithFrame:frame])) {
        self.delegate = del;
        self.height = 72;
		self.backgroundColor = [UIColor colorWithRed:0.871 green:0.843 blue:0.776 alpha:1];
		
		// ------------------ Subviews ------------------
        
		leftButton = [[SBPickerButton alloc] initWithFrame:CGRectMake(5, 5, 147, 33) andTitle:nil];
		[leftButton setDelegate:delegate andClickAction:@selector(selectLeft)];
		rightButton = [[SBPickerButton alloc] initWithFrame:CGRectMake(163, 5, 147, 33) andTitle:nil];
		[rightButton setDelegate:delegate andClickAction:@selector(selectRight)];
		
        UIImageView *line_dot = [[UIImageView alloc] initWithFrame:CGRectMake(0, 41, 320, 1)];
        line_dot.image = PNGImage(@"line_dot");
        
        headerTabView = [[SBSubcategoryTabView alloc] initWithFixedSize];
        headerTabView.delegate = delegate;
        headerTabView.top = 43;
        [headerTabView setDatasource:[NSArray arrayWithObjects:@"默认", @"总分", @"距离", @"点评数", @"优惠", nil]];
        headerTabView.segmentView.selectedIndex = 0;
        
        [self addSubview:leftButton];
        [self addSubview:rightButton];
        [self addSubview:line_dot];
        [self addSubview:headerTabView];
        
        [line_dot release];
    }
    return self;
}

- (void)setLeftTitle:(NSString *)left {
	if ([leftTitle isEqual:left]) {
		return;
	}
	[leftTitle release];
	leftTitle = [left retain];
	
	[leftButton setTitle:leftTitle];
}

- (void)setRightTitle:(NSString *)right {
	if ([rightTitle isEqual:right]) {
		return;
	}
	[rightTitle release];
	rightTitle = [right retain];
	
	[rightButton setTitle:rightTitle];
}

- (void)dealloc {
	[leftTitle release];
	[rightTitle release];
	[leftButton release];
	[rightButton release];
    [headerTabView release];
	[sortTerms release];
    [super dealloc];
}

@end
