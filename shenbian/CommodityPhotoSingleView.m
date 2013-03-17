//
//  CommodityPhotoSingleView.m
//  shenbian
//
//  Created by xhan on 4/21/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "CommodityPhotoSingleView.h"
#import "PhotoHeaderView.h"
#import "PhotoWrapperView.h"
#import "SBCommodityPhoto.h"
#import "UIButton+RemoteImage.h"
#import "Utility.h"
#import <QuartzCore/QuartzCore.h>
#import "SBTriggleButton.h"
#import "PhotoCommentCell.h"
#import "CustomCell.h"
#import "SBApiEngine.h"


@implementation CommodityPhotoSingleView
@synthesize  photo,photoWrapperView;


- (id)initWithPhoto:(SBCommodityPhoto*)photo_ type:(PhotoHeaderViewType)type
{
    
    self = [super initWithFrame:CGRectZero style:UITableViewStylePlain];
    if (self) {
        self.width = 320;
        self.directionalLockEnabled = YES;
        self.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.dataSource = self;
        self.delegate = self;
        photo = [photo_ retain];
        photoWrapperView = [[PhotoWrapperView alloc] initWithCommodityPhoto:photo];
        self.tableHeaderView = photoWrapperView;
        
        [self reloadData];
		
        [self updateFooterRefreshView];
    }
    
    
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return photo.commentList.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor whiteColor];
        PhotoCommentCell *cellView = [[PhotoCommentCell alloc] initWithFrame:cell.frame];
        ((CustomCell *)cell).cellView = cellView;
        [cellView release];
    }
    [((CustomCell *)cell) setDataModel:[photo.commentList.comments objectAtIndex:indexPath.row]];   
    return cell;
}

- (float)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

	return [PhotoCommentCell heightOfCell:[photo.commentList.comments objectAtIndex:indexPath.row]];
}

- (void)dealloc {
    CancelRequest(hcLoadMoreComment);
	VSSafeRelease(photo);
	VSSafeRelease(photoWrapperView);
    [super dealloc];
}



- (void)updateFooterRefreshView
{
    if (! photo.commentList.isHavingMore) {
        [refreshFooter removeFromSuperview];
        return;
    }
    if (!refreshFooter) {
		refreshFooter = [[EGORefreshTableFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, 320, self.height)];
		refreshFooter.upText = NSLocalizedString(@"上拉载入更多",@"pull to refresh");
		refreshFooter.releaseText = NSLocalizedString(@"松开载入更多",@"pull to refresh");
		refreshFooter.loadingText = NSLocalizedString(@"正在载入…",@"loading");
		refreshFooter.delegate = self;
        
	}
    [self addSubview:refreshFooter];
    refreshFooter.top = self.contentSize.height;
}

- (void)loadMoreComments
{
    isRefreshingFooter = YES;

    if (!hcLoadMoreComment) {
        hcLoadMoreComment = [[HttpRequest alloc] init];
        hcLoadMoreComment.delegate = self;
    }
    NSString* lastTimestamp = [photo.commentList lastTimeStamp];
    
    NSString* url = [NSString stringWithFormat:@"%@/getMorePicCmt?p_fcrid=%@&pn=%d&cmt_time=%@", ROOT_URL,photo.cid,photo.commentList.pn,lastTimestamp];
    [hcLoadMoreComment requestGET:url useStat:YES];
}

- (void)finishedHttpClientLoadmore
{
	isRefreshingFooter = NO;
	[refreshFooter egoRefreshScrollViewDataSourceDidFinishedLoading:self];	
}

- (void)requestSucceeded:(HttpRequest *)request
{
    NSError* error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData
                         error:&error];
    if (!error) {
        [photo.commentList addCommentsFrom:dict];
        [self reloadData];
        [self updateFooterRefreshView];
    }
    [self finishedHttpClientLoadmore];    
}

- (void)requestFailed:(HttpRequest *)request error:(NSError *)error
{
    [self finishedHttpClientLoadmore];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView{		
    if (photo.commentList.isHavingMore) {
        [refreshFooter egoRefreshScrollViewDidScroll:scrollView];
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{	
    if (photo.commentList.isHavingMore) {	
        [refreshFooter egoRefreshScrollViewDidEndDragging:scrollView];
    }
}

//footer
- (void)egoRefreshTableFooterDidTriggerRefresh:(EGORefreshTableFooterView *)view{
	[self loadMoreComments];
}

- (BOOL)egoRefreshTableFooterDataSourceIsLoading:(EGORefreshTableFooterView *)view{
	return isRefreshingFooter;
}

@end
