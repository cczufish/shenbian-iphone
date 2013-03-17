//
//  UserPhotoListVC.h
//  shenbian
//
//  Created by xhan on 5/17/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "HttpRequest+Statistic.h"
#import "SBNavigationController.h"
#import "SBTableViewController.h"
#import "SBSegmentView.h"
@interface UserPhotoListVC : SBTableViewController <EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate, HttpRequestDelegate> {
    
    // refresh views
	EGORefreshTableFooterView* refreshFooter;
	EGORefreshTableHeaderView* refreshHeader;
	
	BOOL isRefreshingHeader;
	BOOL isRefreshingFooter;
    
//    UITableView* _tableView;
    
    HttpRequest* httpClient, *hcLoadMore;
    //others 
    NSString* userID, *userName, *userIconURL;
    UIImage* userICON;
    
    NSMutableArray* lists;
    int pageIndex;
    int picCountTotal;
    bool hasTabbar;
    SBSegmentView *titleTabView;
    int offset;
    int hasmore;
    int feedsPage;
}
@property(nonatomic)bool hasTabbar;
//@property(retain)UITableView* tableView;

- (id)initWithUserID:(NSString*)ufcrid uiconPath:(NSString*)url uname:(NSString*)name uicon:(UIImage*)img;

- (void)loadRefreshHeaderView;

- (void)setupFooterRefreshView;
- (void)finishedHttpClientReload;
- (void)finishedHttpClientLoadmore;
- (void)reloadRemoteData;
- (void)loadMoreData;

- (NSMutableArray*)commodityFromDict:(NSDictionary*)dict;
//从home页面的title标签加载
-(void)readyHasTabbar;

@end
