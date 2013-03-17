//
//  AttentionCell.m
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "AttentionCell.h"

@implementation AttentionCell
@synthesize att1,att2,att3;

- (void)initAttention {
    att1=[[AttentionView alloc] initWithFrame:CGRectMake(15, 15, 80, 120)];
    [self.contentView addSubview:att1.view];
    att2=[[AttentionView alloc] initWithFrame:CGRectMake(120, 15, 80, 120)];
    [self.contentView addSubview:att2.view];
    att3=[[AttentionView alloc] initWithFrame:CGRectMake(225, 15, 80, 120)];
    [self.contentView addSubview:att3.view];
    
}
- (void)dealloc {
    [att1 release];
    [att2 release];
    [att3 release];
    [super dealloc];
}
-(void)clearData
{
    [att1 clearValue];
    [att2 clearValue];
    [att3 clearValue];


}
-(void)drawRect:(CGRect)rect
{

[PNGImage(@"dot_line_320") drawAtPoint:ccp(0, rect.size.height - 1)];
}
@end
