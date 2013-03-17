//
//  VSTabBarController+Swip.m
//  shenbian
//
//  Created by xu xhan on 5/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSTabBarController+Swip.h"
#import "SBTabBar.h"

@implementation VSTabBarController (Swip)

- (void)exchangeControllersBetween:(int)indexA :(int)indexB
{
    //exchange controllers
    NSMutableArray* ary = [NSMutableArray arrayWithArray:self.viewControllers];
    [ary exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
    self.viewControllers = [NSArray arrayWithArray:ary];
    
    //exchange tabs
    [(SBTabBar*)self.tabBarView exchangeCellsAtIndex:indexA by:indexB];
    
    int selectedIndex = self.selectedIndex;
    if (selectedIndex == indexA) {
        self.selectedIndex = indexB;
    }else if(selectedIndex == indexB){
        self.selectedIndex = indexA;
    }
}

@end
