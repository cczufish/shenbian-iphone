//
//  ShopVisitedViewController.m
//  shenbian
//
//  Created by MagicYang on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "ShopVisitedViewController.h"
#import "ShopInfoViewController.h"

#import "CustomCell.h"
#import "SearchResultCellView.h"

#import "SBShopInfo.h"

#import "HttpRequest+Statistic.h"
#import "Utility.h"
#import "SBApiEngine.h"


@implementation ShopVisitedViewController

@synthesize userId;

- (void)dealloc
{
    [userId release];
    [resultList release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    Release(resultList);
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad
{
    isPullLoadMore = YES;
    self.title = @"我去过的";
    resultList = [NSMutableArray new];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self startLoadingData];
}

- (void)viewDidAppear:(BOOL)animated {
	NSString *session = [NSString stringWithFormat:@"home_intobeento?u_fcry=%@", userId];
	Stat(session);
}

- (void)startLoadingData
{
    if (currentPage == 0) {
		[self showLoading];
	}
    
    // http://client.shenbian.com/iphone/beenTo?u_fcrid=xxxx&p=0&pn=10
	NSString *url = [NSString stringWithFormat:@"%@/beenTo?u_fcrid=%@&p=%d&pn=%d",
					 ROOT_URL, userId, currentPage, MessageCountPerPage];
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:NO useStat:YES];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [resultList count];
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchResultCellView heightOfCell:[resultList objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SearchResultCell = @"SearchResultCell";
	CustomCell *cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:SearchResultCell];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchResultCell] autorelease];
        cell.cellView = [[SearchResultCellView new] autorelease];
        cell.cellView.frame = cell.frame;
        ((SearchResultCellView *)cell.cellView).showDistance = YES;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
    }
    cell.cellView.noSeperator = indexPath.row == 0;
    SBShopInfo *shop = [resultList objectAtIndex:indexPath.row];
    [cell setDataModel:shop];
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == [resultList count]) {
		[self performSelector:@selector(addShop:)];
	} else {
        SBShopInfo *shop = [resultList objectAtIndex:indexPath.row];
		ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shop.shopId];
		controller.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest *)req error:(NSError *)error {
    [super noMoreData];
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)requestSucceeded:(HttpRequest*)req {
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    totalCount = [[dict objectForKey:@"total"] intValue];
    NSArray *shops = [dict objectForKey:@"shop"];
    for (NSDictionary *shopDict in shops) {
        SBShopInfo *shop = [SBShopInfo new];
        shop.shopId = [shopDict objectForKey:@"s_fcrid"];
        shop.strName = [shopDict objectForKey:@"s_name"];
        shop.intCmtCount = [[shopDict objectForKey:@"s_cmt_count"] intValue];
        shop.strAddress = [shopDict objectForKey:@"s_addr"];
        shop.fltAverage = [[shopDict objectForKey:@"s_average"] floatValue];
		shop.intScoreTotal = [[shopDict objectForKey:@"s_score"] intValue];
        if ([[shopDict objectForKey:@"s_categories"] length] > 0) {
            shop.tagList = [shopDict objectForKey:@"s_categories"];
        }
        [resultList addObject:shop];
        [shop release];
    }
        
    if ([resultList count] < totalCount) {
        [super addPullLoadMore];
    } else {
        [super noMoreData];
    }
    // record current page
    currentPage++;
    [tableView reloadData];
    
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}


@end
