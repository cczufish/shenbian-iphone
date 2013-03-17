//
//  SBLocationView.m
//  shenbian
//
//  Created by MagicYang on 4/26/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBLocationView.h"


@implementation SBLocationView

@synthesize address;

- (SBLocationView *)initWithAddress:(NSString *)addr andPosition:(CGPoint)point;
{
    self = [super initWithFrame:CGRectMake(0, point.y, 320, 20)];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.8];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.textColor = [UIColor whiteColor];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.textAlignment = UITextAlignmentLeft;
        [self addSubview:label];
        
        self.address = addr;
    }
    return self;
}

- (void)setAddress:(NSString *)addr
{
    if (![address isEqual:addr]) {
        [address release];
        address = [addr copy];
        
        if (addr)
            label.text = [@"当前位置: " stringByAppendingString:address];
    }
}

- (void)dealloc
{
    [address release];
    [label release];
    [super dealloc];
}

@end
