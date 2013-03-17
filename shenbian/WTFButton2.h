//
//  WTFButton2.h
//  shenbian
//
//  Created by xu xhan on 5/24/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "WTFButton.h"

@interface WTFButton2 : WTFButton
{
    int visitedNum;
    BOOL isVisited;
}
@property(nonatomic,readonly)BOOL isVisited;
- (void)setVisited:(BOOL)isVisited;
- (void)setVisitedNum:(int)num;

@end
