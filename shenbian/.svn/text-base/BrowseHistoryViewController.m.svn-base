    //
//  BrowseHistoryViewController.m
//  shenbian
//
//  Created by Leeyan on 11-5-16.
//  Copyright 2011 百度. All rights reserved.
//

#import "BrowseHistoryViewController.h"
#import "SearchResultCellView.h"
#import "CustomCell.h"
#import "SBShopInfo.h"
#import "CacheCenter.h"
#import "ShopInfoViewController.h"
#import "VSTabBarController.h"

@implementation BrowseHistoryViewController

@synthesize history;

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:vsr(0, 0, 320, 416) style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}


- (void)loadView {
	[super loadView];
	self.title = @"最近浏览";
	self.view.backgroundColor = [UIColor clearColor];
    
	self.navigationItem.rightBarButtonItem = [SBNavigationController buttonItemWithTitle:@"清空记录" andAction:@selector(clearHistory) inDelegate:self];
	
	tableView.rowHeight = 96;
	
}

- (void) clearHistory {
	UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:nil
													  message:@"确定要清空您的浏览记录吗？"
													 delegate:self 
											cancelButtonTitle:@"取消"
											otherButtonTitles:@"确认", nil];
	[confirm show];
    [confirm release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	switch (buttonIndex) {
		case 1:
			[[CacheCenter sharedInstance] cleanBrowseHistory];
			[tableView reloadData];
			break;
		default:
			break;
	}
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchResultCellView heightOfCell:[history objectAtIndex:indexPath.row]];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [history count];
}

- (UITableViewCell*) tableView:(UITableView *)myTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString* identify = @"shop history";
	CustomCell* cell = (CustomCell*)[myTableView dequeueReusableCellWithIdentifier:identify];
	if (nil == cell) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault
								 reuseIdentifier:identify] autorelease];
		cell.cellView = [[SearchResultCellView new] autorelease];
        cell.cellView.frame = cell.frame;
        ((SearchResultCellView *)cell.cellView).showDistance = YES;
	}
    cell.cellView.noSeperator = indexPath.row == 0;
	SBShopInfo *shop = [history objectAtIndex:indexPath.row];
    shop.showCoupon = NO;
    [cell setDataModel:shop];
	
	return cell;
}

- (void) tableView:(UITableView *)myTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[myTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	SBShopInfo *shop = [history objectAtIndex:indexPath.row];
	ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shop.shopId];
	controller.hidesBottomBarWhenPushed = YES;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	self.history = [CacheCenter sharedInstance].shopBrowseHistory;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"latest_into");
}

- (void)dealloc {
    [history release];
    [super dealloc];
}


@end
