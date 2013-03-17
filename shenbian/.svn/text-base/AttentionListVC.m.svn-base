//
//  AttentionListVC.m
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "AttentionListVC.h"
#import "CustomCell.h"
#import "SBApiEngine.h"
#import "SBAttention.h"
#import "HttpRequest+Statistic.h"
#import "HomeViewController.h"
#import "AttentionCell.h"
#define AttentionPerPage 9
@implementation AttentionListVC
@synthesize userId;

- (void)dealloc {
    CancelRequest(request);
    [resultList release];
    [userId release];
    [super dealloc];
}
//type 1 为关注列表 2为粉丝列表
- (id)initWithUserID:(NSString*)ufcrid RType:(int)type
{
    self = [super init];    
    if (self) {
        requestType=type;
        self.hidesBottomBarWhenPushed = YES;
        userId = [ufcrid copy];
        resultList = [[NSMutableArray alloc] init];
        if (type==1) {
             self.title = @"关注";
        }else
        {
             self.title = @"粉丝";
        }

    }
    return self;
}


- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    isPullLoadMore = YES;
	[super loadView];
    resultList = [NSMutableArray new];
    self.view.backgroundColor = [UIColor clearColor];
    [self startLoadingData];
    
    self.loadingUpText = @"上拉载入更多图片";
	self.loadingReleaseText = @"松开载入图片";
	self.loadingText = @"正在载入...";
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{

    UIImageView* bgView = [T imageViewNamed:@"bg_header_shadow.png"];
    [bgView setBackgroundColor:[UIColor whiteColor]];
    bgView.frame=CGRectMake(0, 0, 320, 10);
    
    [self addSubview:bgView];
    [super viewDidLoad];
//    [self setupFooterRefreshView];
}


- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 10, 320, 416) style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
//	tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    float f=[resultList count]%3;
    if (f==0) {
        return [resultList count]/3;
    }
    else {
        return [resultList count]/3+1;
    }
	
}
- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"AttentionCell";
    AttentionCell *cell = (AttentionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {

        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"AttentionCell" owner:self options:nil];
        cell = [array objectAtIndex:0];
        [cell initAttention];
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        }
    [cell clearData];
    if (resultList.count>indexPath.row*3) {
        [cell.att1 loadData:[resultList objectAtIndex:indexPath.row*3]];
        [cell.att1 addIconBtnTarget:self sel:@selector(onBtnUserIconPressed:)];
    }
    if (resultList.count>indexPath.row*3+1) {
        [cell.att2 loadData:[resultList objectAtIndex:indexPath.row*3+1]];
        [cell.att2 addIconBtnTarget:self sel:@selector(onBtnUserIconPressed:)];
    }
    if (resultList.count>indexPath.row*3+2) {
        [cell.att3 loadData:[resultList objectAtIndex:indexPath.row*3+2]];
        [cell.att3 addIconBtnTarget:self sel:@selector(onBtnUserIconPressed:)];
    }
    //[[cell imageView] setImage:[UIImage imageNamed:[imageNameArray objectAtIndex:indexPath.row]]];
    //[[cell nameLabel] setText:[nameArray objectAtIndex:indexPath.row]];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;

}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)atableView heightForRowAtIndexPath:(NSIndexPath *)indexPath  

{      
    return 145;
}
- (void)startLoadingData
{
    if (currentPage == 0) {
		[self showLoading];
	}
    
    NSString *rTypeStr=@"getAttention";
    if (requestType==2) {
        rTypeStr=@"getFans";
    }
    NSString *url = [NSString stringWithFormat:@"%@/%@?u_fcrid=%@&p=%d&pn=%d",
					 ROOT_URL,rTypeStr,userId, currentPage, AttentionPerPage];
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:NO useStat:YES];
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
    NSArray *shops = [dict objectForKey:@"list"];
    for (NSDictionary *attDict in shops) {
        SBAttention *att = [SBAttention new];
        att.uFcrid=[attDict objectForKey:@"u_fcrid"];
        att.uName=[attDict objectForKey:@"u_name"];
        att.uAvatar=[attDict objectForKey:@"u_avatar"];
        att.shopTotal=[[attDict objectForKey:@"shop_total"] intValue]; 
        [resultList addObject:att];
        [att release];
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
//    [self setupFooterRefreshView];

}


#pragma mark -
- (void)onBtnUserIconPressed:(NSString*)userID
{
	if (userID) {
		HomeViewController* homeVC = [[HomeViewController alloc] initWithUserID:userID];
		[self.navigationController pushViewController:homeVC animated:YES];
		[homeVC release];
	}
}


@end
