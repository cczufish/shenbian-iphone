//
//  CommentListViewController.m
//  shenbian
//
//  Created by MagicYang on 10-11-23.
//  Copyright 2010 personal. All rights reserved.
//

#import "CommentListViewController.h"
#import "HttpRequest+Statistic.h"
#import "SBComment.h"
#import "SBShopInfo.h"
#import "CustomCell.h"
#import "CommentCellView.h"
#import "CommentInfoViewController.h"
#import "SBJsonParser.h"
#import "Utility.h"
#import "CacheCenter.h"
#import "SBApiEngine.h"
#import "HomeViewController.h"

@interface CommentListViewController()

- (void)requestCommentList;

@end


@implementation CommentListViewController

@synthesize shopInfo;
@synthesize hasTabbar;


- (CommentListViewController *)initCommentListControllerWithShop:(SBShopInfo *)aShopInfo {
	if ((self = [super init])) {
		self.shopInfo = aShopInfo;
		currentPage = 0;
	}
	return self;
}

- (void)dealloc {
	CancelRequest(request);
	[shopInfo release];
	[commentList release];
    [super dealloc];
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, hasTabbar ? 367 : 416) style:UITableViewStylePlain];
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.separatorColor = [Utility colorWithHex:0xd4d4d4];
	tableView.delegate = self;
	tableView.dataSource = self;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
    CancelRequest(request);
	Release(commentList);
}
- (void)viewDidAppear:(BOOL)animated {
	Stat(@"cmtlist_into");
}

- (void)loadView {
	isPullLoadMore = YES;
	[super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    self.title = @"点评";
    commentList = [NSMutableArray new];
	[self requestCommentList];
	
	self.loadingUpText = @"上拉载入更多";
	self.loadingReleaseText = @"松开载入更多";
	self.loadingText = @"正在载入...";
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [commentList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CommentCellView heightOfCell:[commentList objectAtIndex:indexPath.row]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		CommentCellView *cellView = [[CommentCellView alloc] initWithFrame:cell.frame];
		((CustomCell *)cell).cellView = cellView;
		[cellView addIconBtnTarget:self sel:@selector(onBtnUserIconPressed:)];
		[cellView release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
	}
	
	[((CustomCell *)cell) setDataModel:[commentList objectAtIndex:indexPath.row]];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	PercentCount index = {indexPath.row, shopInfo.intCmtCount};
	CommentInfoViewController *controller = [[CommentInfoViewController alloc] initWithDelegate:self commentList:commentList andIndex:index];
	controller.shopId = shopInfo.shopId;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}


#pragma mark -
#pragma mark PrivateMethods
- (void)requestCommentList {
    if (currentPage == 0) {
        [self showLoading];
    }
    
    CancelRequest(request);
    // http://client.shenbian.com/iphone/getMoreCommentDetail?s_fcrid=xxx&p=int&pn=int
	NSString *url = [NSString stringWithFormat:@"%@/getMoreCommentDetail?s_fcrid=%@&p=%d&pn=%d", 
					 ROOT_URL, self.shopInfo.shopId, currentPage, MessageCountPerPage];
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	
	[request requestGET:url useStat:YES];
}

- (void)startLoadingData {
	[self requestCommentList];
}

#pragma mark -
- (void)onBtnUserIconPressed:(NSString*)userID
{
	if (userID) {
		HomeViewController* homeVC = [[HomeViewController alloc] initWithUserID:userID];
		[self.navigationController pushViewController:homeVC animated:YES];
		[homeVC release];
	}
	VSLog(@"%@",userID);
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error
{
	[self hideLoading];
    [super noMoreData];
	Release(request);
	[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)requestSucceeded:(HttpRequest*)req 
{
	[self hideLoading];
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    if ([[dict objectForKey:@"errno"] intValue] == 0) {
        if (!IMG_BASE_URL) {
            [CacheCenter sharedInstance].imagePath = [dict objectForKey:@"pic_path"];
        }
        
        totalCount = [[dict objectForKey:@"cmt_total"] intValue];
        NSArray *list = [dict objectForKey:@"comment"];
        for (NSDictionary *cmtDict in list) {
            SBComment *cmt = [[SBComment alloc] initWithDictionary:cmtDict];
            [commentList addObject:cmt];
            [cmt release];
        }
        
        if ([commentList count] < totalCount) {
            [super addPullLoadMore];
        } else {
            [super noMoreData];
        }
        
        // record current page
        currentPage++;
        [tableView reloadData];
    } else {
        [super noMoreData];
    }
	
	Release(request);
	[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)loadMore
{
    [self requestCommentList];
}

@end

