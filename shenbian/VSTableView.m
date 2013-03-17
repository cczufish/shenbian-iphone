//
//  VSTableView.m
//  shenbian
//
//  Created by MagicYang on 4/12/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSTableView.h"


@implementation VSTableView

@synthesize backgroundImage;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    float height = backgroundImage.size.height;
    
    int yPos = 0;
    while (yPos < rect.size.height) {
        [backgroundImage drawAtPoint:ccp(0, yPos)];
        yPos += height;
    }
//    [backgroundImage drawInRect:rect];
//    [super drawRect:rect];
}

- (void)dealloc
{
    [backgroundImage release];
    [super dealloc];
}

@end
