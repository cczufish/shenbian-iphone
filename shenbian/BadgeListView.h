//
//  BadgeListView.h
//  shenbian
//
//  Created by xhan on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SBBadge;
@protocol BadgeListViewDelegate;
@interface BadgeListView : UIScrollView {
    NSArray* badges;
    NSMutableArray* badgeViews,*buttons;
    id<BadgeListViewDelegate> badgeDelegate;
    UIView* wrapperView;
}


@property(nonatomic,assign)id badgeDelegate;
- (void)reloadData:(NSArray*)badges;

@end

@protocol BadgeListViewDelegate <NSObject>

- (void)badgeListView:(BadgeListView*)view badgeClicked:(SBBadge*)badge atIndex:(int)index;

@end