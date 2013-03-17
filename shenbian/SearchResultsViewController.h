//
//  SearchResultsViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"
#import "SearchResultsHeader.h"
#import "HttpRequest+Statistic.h"
#import "VSPickerView.h"
#import "EGORefreshTableHeaderView.h"

enum {
	LeftPicker  = 0,
	RightPicker = 1
};


@class CancelView;
@class LoadingView;
@class SBLocationView;
@class EGORefreshTableHeaderView;
@interface SearchResultsViewController : SBTableViewController
<UIPickerViewDelegate, UIPickerViewDataSource, EGORefreshTableHeaderDelegate> {
	SearchResultsHeader *header;
    UILabel *tableHeader;
    VSPickerView *picker;
    SBLocationView *locationView;
    EGORefreshTableHeaderView *refreshHeaderView;
	
	// 检索条件
	NSString *what, *where;	// 关键字
	NSInteger cityId;		// 城市Id
	NSInteger sort;			// 排序 (0 默认 1 总分 2 距离 3 点评数 4 优惠)
    NSString *area, *category;
	NSInteger areaId, categoryId;
	
	NSMutableArray *resultList;
	HttpRequest *request;
	NSInteger currentPage;
	NSInteger resultCount;
	
	NSMutableArray *areaList, *categoryList;
	NSInteger leftMainIndex, rightMainIndex;
	CancelView *cancelView;
	
	//	not found view
	UIView *notFoundView;
	
	BOOL showAddShop;
	BOOL tabbarHidden;
	BOOL headerHidden;
	
	BOOL isSearchFinished;
    BOOL isRefreshing;
}

@property(nonatomic, retain) NSString *what;
@property(nonatomic, retain) NSString *where;
@property(nonatomic, retain) NSString *area;
@property(nonatomic, retain) NSString *category;
@property(nonatomic, assign) NSInteger cityId;
@property(nonatomic, assign) NSInteger sort;
@property(nonatomic, assign) NSInteger areaId;
@property(nonatomic, assign) NSInteger categoryId;
@property(nonatomic, assign) BOOL tabbarHidden;
@property(nonatomic, assign) BOOL headerHidden;
@property(nonatomic, retain) UIView *notFoundView;

- (void)searchRequest;
- (void)cleanAll;
- (void)showNotFoundView;

@end
