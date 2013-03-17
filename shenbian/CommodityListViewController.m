//
//  CommodityListViewController.m
//  shenbian
//
//  Created by MagicYang on 4/23/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "CommodityListViewController.h"
#import "CommodityPhotoDetailVC.h"
#import "HttpRequest+Statistic.h"
#import "CustomCell.h"
#import "CommentCellView.h"
#import "ShopInfoCellView.h"
#import "SBJsonParser.h"
#import "Utility.h"
#import "SBCommodityList.h"
#import "PhotoController.h"
#import "SBApiEngine.h"
#import "Notifications.h"


@implementation CommodityListViewController

@synthesize shopId, shopName;

- (void)dealloc
{
    CancelRequest(request);
    [shopId release];
    [shopName release];
    [super dealloc];
}

- (void)requestCommodityList
{
    if (currentPage == 0) {
		[self showLoading];
	}
    CancelRequest(request);
    // http://client.shenbian.com/iphone/getMoreCommodityDetail?s_fcrid=xxx&p=int&pn=int
    NSString *url = [NSString stringWithFormat:@"%@/getMoreCommodityDetail?s_fcrid=%@&p=%d&pn=%d", ROOT_URL, shopId, currentPage, MessageCountPerPage];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestGET:url useCache:YES useStat:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
	Stat(@"itemlist_into?s_fcry=%@", shopId);
    [Notifier addObserver:self selector:@selector(takePhotoForCommodity:) name:kShopActionTakePhoto object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [Notifier removeObserver:self name:kShopActionTakePhoto object:nil];
}

- (void)loadView
{
    isPullLoadMore = YES;
    self.loadingUpText = @"上拉载入更多";
	self.loadingReleaseText = @"松开载入更多";
	self.loadingText = @"正在载入...";
    [super loadView];
    self.title = @"菜单";
    self.view.backgroundColor = [UIColor whiteColor];
    
    list = [NSMutableArray new];
    
    [self requestCommodityList];
	
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    CancelRequest(request);
    Release(list);
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}

- (void)addCommodity:(id)sender
{
    PhotoController *pc = [PhotoController singleton];
    pc.shopId   = shopId;
    pc.shopName = shopName;
    [pc showActionSheet];
}

- (void)takePhotoForCommodity:(NSNotification *)notification {
    SBCommodity *commodity = [[notification userInfo] objectForKey:@"commodity"];
    PhotoController *pc = [PhotoController singleton];
    pc.shopId = shopId;
    pc.shopName = shopName;
    pc.commodity = commodity.cname;
    [pc showActionSheet];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [ShopCommodityCellView heightOfCell:[list objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		CustomCellView *cellView = [[ShopCommodityCellView alloc] initWithFrame:cell.frame];
        [cellView setValue:NUM(1) forKey:@"yaoXuXianMa"];
		((CustomCell *)cell).cellView = cellView;
		[cellView release];
	}
	
    SBCommodity *com = [list objectAtIndex:indexPath.row];
	[((CustomCell *)cell) setDataModel:com];
    cell.selectionStyle = com.ccount > 0 ? UITableViewCellSelectionStyleGray : UITableViewCellSelectionStyleNone;
    cell.accessoryType  = com.ccount > 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
    SBCommodity *com = [list objectAtIndex:indexPath.row];
    com.sid = shopId;
    if (com.ccount > 0) {
		Stat(@"itemlist_click?r=%d&p_fcry=%@", indexPath.row, com.pid);
        CommodityPhotoDetailVC *controller = [[CommodityPhotoDetailVC alloc] initWithCommdity:com displayType:CommodityPhotoDetailTypeCommodityOnly];
        controller.from = CommodityPhotoSourceFromShopInfo;
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}


- (void)startLoadingData {
	if (currentPage > 0) {
		Stat(@"itemlist_upmore");
	}
	[self requestCommodityList];
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    [super noMoreData];
	Release(request);
	[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
    [self hideLoading];
}

- (void)requestSucceeded:(HttpRequest*)req {
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    totalCount = [[dict objectForKey:@"c_total"] intValue];
    for (NSDictionary *d in [dict objectForKey:@"commodity"]) {
        SBCommodity *sb = [[SBCommodity alloc] initWithDict:d imagePrefix:[dict objectForKey:@"pic_path"]];
        [list addObject:sb];
        [sb release];
    }
    
    if ([list count] < totalCount) {
        [super addPullLoadMore];
    } else {
        [super noMoreData];
        
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
        footer.backgroundColor = [UIColor clearColor];
        UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [addBtn setImage:PNGImage(@"button_commodity_add_0") forState:UIControlStateNormal];
        [addBtn setImage:PNGImage(@"button_commodity_add_1") forState:UIControlStateHighlighted];
        [addBtn addTarget:self action:@selector(addCommodity:) forControlEvents:UIControlEventTouchUpInside];
        [addBtn setFrame:CGRectMake(15, 10, 143, 31)];
        [footer addSubview:addBtn];
        tableView.tableFooterView = footer;
        [footer release];
    }
    // record current page
    currentPage++;
    [tableView reloadData];
	
	Release(request);
	[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
    [self hideLoading];
}


@end
