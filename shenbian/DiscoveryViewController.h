//
//  DiscoveryViewController.h
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DatasourceDiscovery.h"
#import "SBPickerViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "SBNavigationController.h"


extern BOOL hasAlertGPSEnabled;

@class SBSubcategoryTabView, SBSegmentView;
@class SBCommodityList, SBCommodity, DatasourceDiscovery;
@class SBLocationView, SBNoResultView;
@class SBAdvertisement;
@interface DiscoveryViewController : SBNavigationController<UITableViewDelegate,UITableViewDataSource,EGORefreshTableFooterDelegate,EGORefreshTableHeaderDelegate,
	DatasourceDiscoveryDelegate, SBPickerDelegate> {

    SBSubcategoryTabView *headerTabView;
	SBSegmentView* titleTabView;
	
	UITableView* _tableView;
		
	SBLocationView *locationFloatView;
    SBNoResultView *noResultView;
	//discovery datasource
	DatasourceDiscovery* datasource;
	
	EGORefreshTableFooterView* refreshFooter;
	EGORefreshTableHeaderView* refreshHeader;
	
	BOOL isRefreshingHeader;
	BOOL isRefreshingFooter;
}

@property(retain)UITableView* tableView;

- (void)showCellAtIndex:(int)index;

//private methods
- (void)loadMoreDatas;
- (void)reloadRemoteData;
- (void)reloadCurrentListData;

- (void)finishedHttpClientReload;
- (void)finishedHttpClientLoadmore;

- (void)setupFooterRefreshView;

- (void)reloadDataAtTab:(int)tab subTab:(int)subtab;

- (void)showCategorySegmentView:(BOOL)isShow;

//reset and reload datas
- (void)resetData;
// public method to select LatestTab
- (void)selectLatestTab;

@end







