//
//  BadgeListVC.h
//  shenbian
//
//  Created by xhan on 5/17/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import "BadgeListView.h"

@class HttpRequest;
@class LoadingView;
@interface BadgeListVC : SBNavigationController<HttpRequestDelegate,BadgeListViewDelegate> {
    HttpRequest* httpClient;
    //others 
    NSString* userID;
    
    NSMutableArray* badgesList;
    BadgeListView* listView;
    
    LoadingView *loadingView;
}

- (id)initWithUserID:(NSString*)ufcrid;

- (void)loadBadgeList;

@end
