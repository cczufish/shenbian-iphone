//
//  SBTableViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGORefreshTableFooterView.h"
#import "SBNodataView.h"
#import "LoadingView.h"
#import "SBNavigationController.h"


#define TableViewFrameWithoutKeyboard CGRectMake(0, 0, 320, 368)
#define TableViewFrameWithKeyboard    CGRectMake(0, 0, 320, 200)


@class LoadingView;

@interface SBTableViewController : SBNavigationController<
UITableViewDelegate, UITableViewDataSource, EGORefreshTableFooterDelegate> {
	UITableView *tableView;
	SBNodataView *nodataView;
	LoadingView *loadingView;
	
	BOOL isPullLoadMore;
	BOOL isLoading;
	EGORefreshTableFooterView *refreshFooterView;
	
	NSString *loadingUpText, *loadingReleaseText, *loadingText;
}

@property(nonatomic, retain) NSString *loadingUpText;
@property(nonatomic, retain) NSString *loadingReleaseText;
@property(nonatomic, retain) NSString *loadingText;

+ (UITableViewCell *)cellWithIdentifier:(NSString *)identifier;

// loading display
- (void)showLoading;
- (void)hideLoading;

// add pull view for loading more
- (void)addPullLoadMore;
// insert new data in new rows
- (void)loadDataFrom:(NSInteger)indexFrom count:(NSInteger)count;
// Needed override by subclass
- (void)startLoadingData;
// Called after loading data
- (void)finishLoadingData;
// Called by no more data for loading
- (void)noMoreData;

@end
