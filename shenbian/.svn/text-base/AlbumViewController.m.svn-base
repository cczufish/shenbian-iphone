//
//  AlbumViewController.m
//  shenbian
//
//  Created by MagicYang on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "AlbumViewController.h"
#import "HttpRequest+Statistic.h"
#import "Utility.h"
#import "SBAlbum.h"
#import "SBCommodityList.h"
#import "CustomCell.h"
#import "AlbumCellView.h"
#import "SBImageDataSource.h"
#import "CommodityPhotoDetailVC.h"
#import "SBApiEngine.h"


#define PhotoCountPerRequest 30

@implementation AlbumViewController

@synthesize shopId;

- (AlbumViewController *)initWithShopId:(NSString *)shopID
{
    self = [super init];
    if (self) {
        self.shopId = shopID;
    }
    return self;
}

- (void)dealloc
{
    [shopId release];
    [super dealloc];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"morepic_into?s_fcry=%@", shopId);
	[super viewDidAppear:animated];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    CancelRequest(request);
}

- (void)initTableView
{
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStylePlain];
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
}

- (void)requestAlbum
{
    // http://client.shenbian.com/iphone/getShopAlbums?s_fcrid=xxxxx&p=int&pn=int
    NSString *url = [NSString stringWithFormat:@"%@/getShopAlbums?s_fcrid=%@&p=%d&pn=%d", ROOT_URL, shopId,currentPage, PhotoCountPerRequest];
    request =[[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestGET:url useStat:YES];
}

- (void)startLoadingData {
	[self requestAlbum];
}

- (void)loadView {
	isPullLoadMore = YES;
	[super loadView];
    self.title = @"商户相册";
    self.view.backgroundColor = [UIColor clearColor];
    
    albumList = [NSMutableArray new];
	[self requestAlbum];
	
	self.loadingUpText = @"上拉载入更多图片";
	self.loadingReleaseText = @"松开载入图片";
	self.loadingText = @"正在载入...";
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [albumList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [AlbumCellView heightOfCell:nil];    // fixed height
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
	if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		CustomCellView *cellView = [[AlbumCellView alloc] initWithFrame:cell.frame andDelegate:self];
		((CustomCell *)cell).cellView = cellView;
		[cellView release];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
	}
	
    SBAlbumRow *ar = [albumList objectAtIndex:indexPath.row];
	[((CustomCell *)cell) setDataModel:ar];
    return cell;
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest *)req error:(NSError *)error {
    [super noMoreData];
    Release(request);
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)requestSucceeded:(HttpRequest*)req {
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    totalCount = [[dict objectForKey:@"albums_total"] intValue];
    NSMutableArray *albums = [NSMutableArray arrayWithArray:[dict objectForKey:@"albums"]]; 
    
    SBAlbumRow *lastAR = [albumList lastObject];
    NSInteger count = [[lastAR albumRow] count];
    if (count > 0) {    // 最后一行的剩余格子填充
        NSInteger emptyCount = PHOTO_COUNT_PER_ROW - count;
        for (int i = 0; i < emptyCount; i++) {
            SBPhoto *photo = [[SBPhoto alloc] initWithDictionary:[albums objectAtIndex:0]];
            [lastAR addPhoto:photo];
            [photo release];
            [albums removeObjectAtIndex:0];
        }
    }
    
    NSInteger row = [albums count] / 3;
    NSInteger left = [albums count] % 3;
    row = left == 0 ? row : row + 1;
    for (int i = 0; i < row; i++) {
        SBAlbumRow *ar = [SBAlbumRow new];
        for (int j = 0; j < PHOTO_COUNT_PER_ROW; j++) {
            NSInteger index = i * PHOTO_COUNT_PER_ROW + j;
            if (index < [albums count]) {
                NSDictionary *d = [albums objectAtIndex:index];
                SBPhoto *photo = [[SBPhoto alloc] initWithDictionary:d];
                [ar addPhoto:photo];
                [photo release];
            } else {
                break;
            }
        }
        [albumList addObject:ar];
        [ar release];
    }
    if ([albumList count] * 3 < totalCount) {
        [super addPullLoadMore];
    } else {
        [super noMoreData];
    }
    // record current page
    currentPage++;
    [tableView reloadData];

    Release(request);
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (NSInteger)indexOfPhoto:(SBPhoto *)photo toList:(NSArray **)photoList
{
    int i = 0;
    NSInteger index = 0;
    NSMutableArray *arr = [NSMutableArray new];
    for (SBAlbumRow *ar in albumList) {
        for (SBPhoto *p in [ar albumRow]) {
            if ([p isEqual:photo]) {
                index = i;
            }
            SBCommodity *commodity = [SBCommodity new];
            commodity.pid = p.photoId;
            [arr addObject:commodity];
            [commodity release];
            i++;
        }
    }
    *photoList = arr;
    return index;
}

- (void)showPhoto:(SBPhoto *)photo
{
    NSArray *photoList = NULL;
    NSInteger index = [self indexOfPhoto:photo toList:&photoList];
	Stat(@"morepic_click?r=%d", index);
    CommodityPhotoDetailVC *controller = [[CommodityPhotoDetailVC alloc] initWithCommdityArray:photoList currentItemIndex:index displayType:CommodityPhotoDetailTypeNone];
    controller.isNonCommodity = YES;
	controller.from = CommodityPhotoSourceFromShopAlbum;
    [photoList release];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

@end
