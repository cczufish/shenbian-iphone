//
//  WTFButton2.m
//  shenbian
//
//  Created by xu xhan on 5/24/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "WTFButton2.h"
#import "VSEffectLabel.h"

@implementation WTFButton2
@synthesize isVisited;
- (id)init
{
    self = [super init];
    if (self) {
        normalImg = [PNGImage(@"button_shop_been_0") retain];
        votedImg = [PNGImage(@"button_shop_been_1") retain];
        [self setBackgroundImage:votedImg forState:UIControlStateDisabled];
    }
    return self;
}

- (void)setVisited:(BOOL)isVisited_
{
    isVisited = isVisited_;
    UIImage* img = isVisited ? votedImg : normalImg;
    [self setBackgroundImage:img
                    forState:UIControlStateNormal];
    [self setVisitedNum:(visitedNum + (isVisited ? 1 : -1))];
    
    if (!isVisited) {
		wtflabel.textColor = [UIColor colorWithRed:0.647 green:0.718 blue:0.745 alpha:1];
		[wtflabel setEffectStroke:[UIColor whiteColor] width:2];
	}else {
		wtflabel.textColor = [UIColor whiteColor];
		[wtflabel setEffectStroke:[UIColor colorWithRed:0.894 green:0.204 blue:0.184 alpha:1] width:2];
	}   
}

- (void)setVisitedNum:(int)num
{
    visitedNum = num;
	if (visitedNum >= 1000) {
		wtflabel.text = @"999+人 ";
	}else {
		wtflabel.text = [NSString stringWithFormat:@"%d人 ",visitedNum];
	}
}

@end
