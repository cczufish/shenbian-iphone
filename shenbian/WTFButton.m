//
//  WTFButton.m
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "WTFButton.h"
#import "VSEffectLabel.h"

@implementation WTFButton
@synthesize isVoted;

- (id)init
{

	self = [super initWithFrame:CGRectMake(0, 0, 56, 56)];
	if (self) {
		normalImg = [[T imageNamed:@"btn_recommand_n.png"] retain];
		votedImg = [[T imageNamed:@"btn_recommand_disable.png"] retain];
		self.backgroundColor = [UIColor clearColor];
		[self setBackgroundImage:normalImg forState:UIControlStateNormal];
		[self setShowsTouchWhenHighlighted:YES];
		
        UIColor *textColor   = [UIColor colorWithRed:0.647 green:0.722 blue:0.745 alpha:1];
        UIColor *borderColor = [UIColor whiteColor];
		wtflabel = [[VSEffectLabel alloc] initWithFrame:CGRectMake(0, 0, 40, 20)];
		wtflabel.top = 0;
		wtflabel.right = 23;
		wtflabel.textAlignment = UITextAlignmentRight;
		wtflabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
		wtflabel.font = [UIFont boldSystemFontOfSize:12];
        [wtflabel setTextColor:textColor];
        [wtflabel setEffectStroke:borderColor width:2];
        
		[self addSubview:wtflabel];
		self.enabled = YES;
	}
	return self;
	
}

- (void)setVoted:(BOOL)isVoted_
{
    if (isVoted == isVoted_) return;
    
    isVoted = isVoted_;
    UIImage* img = isVoted ? votedImg : normalImg;
    [self setBackgroundImage:img
                    forState:UIControlStateNormal];
    [self setVoteNum:(voteNum + (isVoted ? 1 : -1))];
    
    if (!isVoted) {
		wtflabel.textColor = [UIColor grayColor];
		[wtflabel setEffectStroke:[UIColor whiteColor] width:2];
	}else {
		wtflabel.textColor = [UIColor whiteColor];
		[wtflabel setEffectStroke:[UIColor redColor] width:2];
	}
}


- (void)setVoteNum:(int)num
{
    voteNum = num;
	if (voteNum >= 1000) {
		wtflabel.text = @"999+";
	} else {
		wtflabel.text = [NSString stringWithFormat:@"%d ",num];
	}
}

- (void)setEnabled:(BOOL)value
{
	[super setEnabled:value];
    /*
	if (value) {
		wtflabel.textColor = [UIColor grayColor];
		[wtflabel setEffectStroke:[UIColor whiteColor] width:2];
	}else {
		wtflabel.textColor = [UIColor whiteColor];
		[wtflabel setEffectStroke:[UIColor redColor] width:2];
	}
     */

}

- (void)dealloc{
	VSSafeRelease(wtflabel);
    VSSafeRelease(normalImg);
    VSSafeRelease(votedImg);
	[super dealloc];
}

@end
