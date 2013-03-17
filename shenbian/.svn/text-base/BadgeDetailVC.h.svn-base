//
//  BadgeDetailVC.h
//  shenbian
//
//  Created by xhan on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"

@class SBBadge;
@class HttpRequest;
@class LoadingView;
@interface BadgeDetailVC : SBNavigationController <UIActionSheetDelegate>{
    SBBadge* badge;
    HttpRequest *request;
	HttpRequest *useBadgeRequest;
    LoadingView *loadingView;
	UIScrollView *scrollView;
	
	BOOL _badgeImageDisplayed;
}

- (id)initWithBadge:(SBBadge*)badge;

@end
