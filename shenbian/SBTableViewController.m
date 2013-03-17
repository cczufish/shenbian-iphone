    //
//  SBTableViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBTableViewController.h"


@implementation SBTableViewController

@synthesize loadingUpText, loadingReleaseText, loadingText;


+ (UITableViewCell *)cellWithIdentifier:(NSString *)identifier {
	UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	cell.backgroundView = [[[UIImageView alloc] initWithImage:PNGImage(@"tableview_cell_bg")] autorelease];
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.selectionStyle = UITableViewCellSelectionStyleGray;
	cell.textLabel.font = FontWithSize(18);
	return [cell autorelease];
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:TableViewFrameWithoutKeyboard style:UITableViewStyleGrouped];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	Release(tableView);
}

- (void)loadView {
	[super loadView];
	
	[self initTableView];
	[super addSubview:tableView];
}

- (void)dealloc {
	Release(tableView);
	Release(refreshFooterView);
	[loadingUpText release];
	[loadingReleaseText release];
	[loadingText release];
	[nodataView release];
	[loadingView release];
	[super dealloc];
}

- (void)showLoading {
	if (!loadingView) {
		loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
	}
	[self.view addSubview:loadingView];
}

- (void)hideLoading {
	[loadingView removeFromSuperview];
}

- (void)addPullLoadMore {
	if (isPullLoadMore) {	// Load More View
		if (refreshFooterView == nil) {
			refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0.0f, tableView.frame.size.height, tableView.frame.size.width, tableView.bounds.size.height)];
			refreshFooterView.delegate = self;
			refreshFooterView.upText = loadingUpText ? loadingUpText : @"上拉载入更多";
			refreshFooterView.releaseText = loadingReleaseText ? loadingReleaseText : @"松开载入更多";
			refreshFooterView.loadingText = loadingText ? loadingText : @"正在载入…";
			[tableView addSubview:refreshFooterView];
		}
	}
}


#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	NSAssert(NO, @"Must be implemented by subclass");
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSAssert(NO, @"Must be implemented by subclass");
	return nil;
}


// ==================== EGORefreshTableFooterView Delegate Methods =================
#pragma mark -
#pragma mark Data Source Loading / Reloading Method
- (void)loadDataFrom:(NSInteger)indexFrom count:(NSInteger)count {
	if (count <= 0) {
		return;
	}
	
	NSMutableArray *indexPaths = [NSMutableArray array];
	for (int i = 0; i < count; i++) {
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:indexFrom + i inSection:0];
		[indexPaths addObject:indexPath];
	}
	[tableView beginUpdates];
	[tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	[tableView endUpdates];
}

- (void)startLoadingData {
	// Here's the implement of loading data by subclass
	NSAssert(NO, @"Must be implemented by subclass");
}

- (void)finishLoadingData {
	isLoading = NO;
	
	// Move the loading view Y position
	CGRect frame = refreshFooterView.frame;
	refreshFooterView.frame = CGRectMake(frame.origin.x, tableView.contentSize.height, frame.size.width, frame.size.height);
	
	[refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
}

- (void)removeFooterView {
    [refreshFooterView removeFromSuperview];
	Release(refreshFooterView);
}

- (void)noMoreData {
	isPullLoadMore = NO;
	[self performSelector:@selector(removeFooterView) withObject:nil afterDelay:0.01];
}


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	if (isPullLoadMore && refreshFooterView != nil) {
		[refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
	}
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if (isPullLoadMore && refreshFooterView != nil) {
		[refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
	}
}


#pragma mark -
#pragma mark EGORefreshTableFooterDelegate Methods
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView*)v{
	isLoading = YES;
	[self startLoadingData];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)v {
	return isLoading; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableFooterDataSourceLastUpdated:(EGORefreshTableFooterView *)v {
	return [NSDate date]; // should return date data source was last changed
}
// ==================== EGORefreshTableFooterView Delegate Methods =================

@end
