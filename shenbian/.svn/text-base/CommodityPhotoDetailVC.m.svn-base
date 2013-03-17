    //
//  CommodityPhotoDetailVC.m
//  shenbian
//
//  Created by xhan on 4/15/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CommodityPhotoDetailVC.h"
#import "SBImageDataSource.h"
#import "SDWebImageManager.h"
#import "SBPhotoScrollViewController.h"

#import "DiscoveryViewController.h"
#import "ShopInfoViewController.h"
#import "PhotoController.h"
#import "HomeViewController.h"
#import "LoginController.h"
#import "VSTabBarController.h"
#import "WeiboBindController.h"

#import "HttpRequest+Statistic.h"
#import "SBApiEngine.h"
#import "LocationService.h"
#import "SBLocation.h"
#import "CacheCenter.h"
#import "TKAlertCenter.h"

#import "PhotoHeaderView.h"
#import "VSEffectLabel.h"
#import "PictureDetailTitleView.h"
#import "PictureDetailToolbar.h"
#import "WTFButton.h"
#import "PhotoWrapperView.h"
#import "CommodityPhotoSingleView.h"
#import "SBTriggleButton.h"
#import "WeiBoShareCommentsView.h"

#import "SBCommodityList.h"
#import "SBCommodityPhoto.h"
#import "SBUser.h"
#import "VSCommentView.h"


#define RemoveAndCleanSubView(_v_) if(_v_){	[_v_ removeFromSuperview];VSSafeRelease(_v_);}

#define CommodityPhotoDetailVC_PN 10

@interface CommodityPhotoDetailVC (Private)

- (void)showShopInfo;
- (BOOL)_isHaveRecommandButton;
- (SBCommodityPhoto*)_currentPhoto;
- (BOOL)isNotLoginAndShowLogin;

@end


@implementation CommodityPhotoDetailVC

@synthesize from, tab;
@synthesize isNonCommodity;

- (id)initWithCommdity:(SBCommodity*)model displayType:(CommodityPhotoDetailType)type
{
	return [self initWithCommdity:model displayType:type Datasource:nil previousVC:nil];
}

- (id)initWithCommdity:(SBCommodity*)model 
		   displayType:(CommodityPhotoDetailType)type 
			Datasource:(DatasourceDiscovery*)ds 
			previousVC:(DiscoveryViewController*)vc
{
	self = [super init];
    if (self) {
        self.from = CommodityPhotoSourceFromError;
        self.hidesBottomBarWhenPushed = YES;
        commodityMode = [model retain];
        displayType = type;
        datasource = ds;	//non retain value
        discoveryVC = vc;
        isShowBtnPreNext = datasource.currentList.array.count > 0 ;
        [datasource addDelegate:self];
        if (discoveryVC) {
            curItemIndex = [datasource.currentList.array indexOfObject:commodityMode];
        }
    }
	return self;	
}

- (id)initWithCommdityArray:(NSArray*)commodityAry currentItemIndex:(int)index displayType:(CommodityPhotoDetailType)type
{
	self = [super init];
	self.hidesBottomBarWhenPushed = YES;
	self.from = CommodityPhotoSourceFromError;
	displayType = type;
	isShowBtnPreNext = commodityAry.count > 0 ;
	commodityArray = [commodityAry retain];
	commodityMode = [[commodityAry objectAtIndex:index] retain];
	curItemIndex = index;
	return self;	
}

- (id)init{
	[NSException raise:@"call initWith... instead" format:@""];
	return nil;
}

- (void)viewDidLoad {
	if (from == CommodityPhotoSourceFromError) {
		[NSException raise:@"from should be set after init" format:@""];
	}
    [super viewDidLoad];
	self.navigationItem.title = @"图片详情";
	if (isShowBtnPreNext) {
		[self setupNavigationBarButtons];
	}
	
	self.view.backgroundColor = [UIColor whiteColor];
	[self updateBtnPreNextStatus];
    
    toolbar = [[PictureDetailToolbar alloc] initWithDelegate:self];
    [self.view addSubview:toolbar];
    
    [self loadImageDetails];
    
    if ([[LoginController sharedInstance] isLogin]) {
        Stat(@"picdetail_into?p_fcry=%@&i_fcry=%@&is_login=1&s_fcry=%@&u_fcry=%@", 
             commodityMode.pid, commodityMode.cid, commodityMode.sid, CurrentAccount.uid);
    } else {
        Stat(@"picdetail_into?p_fcry=%@&i_fcry=%@&is_login=0&s_fcry=%@",
             commodityMode.pid, commodityMode.cid, commodityMode.sid);
    }
}


- (void)viewDidUnload {
    [super viewDidUnload];
    
    Release(toolbar);
}


- (void)dealloc {
	if(discoveryVC){
		[discoveryVC showCellAtIndex:curItemIndex];
		discoveryVC = nil;
	}
    
	CancelRequest(hcPostComment);
    CancelRequest(hcWeiboShare);
	CancelRequest(hcDetails);
	CancelRequest(hcMorePhoto);
    CancelRequest(voteCommodity);
    CancelRequest(votePhoto);
    
	VSSafeRelease(commodityArray);
	VSSafeRelease(commodityMode);


    VSSafeRelease(toolbar);

	VSSafeRelease(containerViewCurrent);
	VSSafeRelease(pageView);
	VSSafeRelease(headerView);

	VSSafeRelease(wtfButton);
	VSSafeRelease(btnNavPrevious);
	VSSafeRelease(btnNavNext);
	
	VSSafeRelease(shareView);
	[datasource removeDelegate:self],datasource = nil;

	VSSafeRelease(m_reply);
	
    [super dealloc];
}


#pragma mark -

- (void)updateBtnPreNextStatus
{
	if(!isShowBtnPreNext) return;
		
	if (datasource) {
		SBCommodityList* list = datasource.currentList ;
		BOOL enablePre = NO, enableNext = NO;
		
		enablePre = curItemIndex != 0;
		enableNext = (curItemIndex <  list.array.count - 1) || list.hasMore;
		btnNavPrevious.enabled = enablePre;
		btnNavNext.enabled = enableNext;		
	}else if (commodityArray){
		BOOL enablePre = NO, enableNext = NO;
		enablePre = curItemIndex != 0;
		enableNext = curItemIndex < commodityArray.count -1;
		btnNavPrevious.enabled = enablePre;
		btnNavNext.enabled = enableNext;
	}
}



- (void)setupNavigationBarButtons
{
	const int btnWidth = 42;
	const int btnHeight = 30;
	UIView* containerV_ = [[UIView alloc] initWithFrame:CGRectMake(0, 0, btnWidth* 2, btnHeight)];
	btnNavPrevious = [[T createBtnfromPoint:ccp(0,0)
								   imageStr:@"btnNavPrevious.png"
									 target:self
								   selector:@selector(onBtnPreviousPressed:)] retain];
	btnNavNext     = [[T createBtnfromPoint:ccp(btnWidth,0)
								   imageStr:@"btnNavNext.png"
									 target:self
								   selector:@selector(onBtnNextPressed:)] retain];
	[containerV_ addSubview:btnNavPrevious];
	[containerV_ addSubview:btnNavNext];
	
	UIBarButtonItem* item = [[UIBarButtonItem alloc] initWithCustomView:containerV_];
	[containerV_ release];
	self.navigationItem.rightBarButtonItem = item;
	[item release];
	
}

- (void)setupHeaderViewBytype
{
    
	RemoveAndCleanSubView(headerView);

    headerView = [[PhotoHeaderView alloc] inityWithInfo:commodityInfo from:from];
    [headerView addTargetForShopInfo:self action:@selector(onBtnShopFieldPressed:)];
     
    [containerViewCurrent addSubview:headerView];
}


- (void)setupPhotoContentView
{
	RemoveAndCleanSubView(pageView);
	pageView = [[VSPageView alloc] initWithFrame:CGRectMake(0, headerView.bottom - 3 , 320, 460 - 44 - headerView.bottom + 5)];
	[containerViewCurrent addSubview:pageView];
	pageView.pageDelegate = self;
	pageView.pageCount = commodityPhotos.count;
}

- (void)setupWTFbuttons
{
	RemoveAndCleanSubView(wtfButton);

    if ([self _isHaveRecommandButton]) {
        wtfButton = [[WTFButton alloc] init];
        wtfButton.origin = ccp(10, 5);
        [containerViewCurrent addSubview:wtfButton];
        [wtfButton setVoted:commodityInfo.isCVoted];
        [wtfButton setVoteNum:[commodityInfo cvoteCount]];
        [wtfButton addTarget:self action:@selector(onBtnCommodityVoted:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupSubViewBymodel
{
	RemoveAndCleanSubView(containerViewCurrent);
	
	containerViewCurrent = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 480 - 64 - 47)];
	[containerViewCurrent setBackgroundColor:UIColor.whiteColor];
	[self addSubview:containerViewCurrent];
	[self setupHeaderViewBytype];
	[self setupPhotoContentView];
	[self setupWTFbuttons];
    SBCommodityPhoto* photo = [self _currentPhoto];    
    [toolbar updateLikeButtonWithState:photo.isVoted];// set like status
    
	[containerViewCurrent sendSubviewToBack:pageView];
    [self.view bringSubviewToFront:toolbar];
}

#pragma mark - inner

- (BOOL)isHavingMorePhotos
{
    return commodityInfo.totalPhotoCount > [commodityPhotos count];
}

#pragma mark pageView delegaets

- (UIView*)pageView:(VSPageView*)pageview viewForPageAtIndex:(NSInteger)index
{
    //last item
    if (index == [commodityPhotos count] - 1) {
        if ([self isHavingMorePhotos]) {
            [self loadMoreImages];
        }
    }
    
    CommodityPhotoSingleView* view = [[CommodityPhotoSingleView alloc] initWithPhoto:[commodityPhotos objectAtIndex:index] type:PhotoHeaderViewTypeCommodity];
    [view.photoWrapperView addAction:self
                         userInfoSel:@selector(onBtnUserInfo:) 
                      likedPeopleSel:@selector(onBtnUserLikedItem:)
                         bigImageSel:@selector(onBtnBigImageClicked:)];
    int h = from == CommodityPhotoSourceFromShopAlbum ? 325 + 42 : 325;
    view.size = CGSizeMake(320, h); // 325px为手工测算高度
    return [view autorelease];
}

- (void)pageView:(VSPageView *)pageview indexChanged:(NSInteger)index
{
    SBCommodityPhoto* photo = [self _currentPhoto];
    [toolbar updateLikeButtonWithState:photo.isVoted];
	commodityMode.uname = ((SBCommodityPhoto *)[commodityPhotos objectAtIndex:index]).user.uname;
    
    // session log
    if (currentPicIndex < index) { // Next picture
        Stat(@"picdetail_changeitem？m=1&p_fcry=%@", photo.cid);
    } else {
        Stat(@"picdetail_changeitem？m=0&p_fcry=%@", photo.cid);
    }
    currentPicIndex = index;
    // session log
}

- (void)_showLoadMorePhotoIndicator:(BOOL)isShow
{
    const int IndicatorTag = 658312;

    if (isShow && ![pageView viewWithTag:IndicatorTag]) {
        UIActivityIndicatorView* indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicatorView.top = 100;
        //TODO: test purpose, should change position later
        indicatorView.left = pageView.contentSize.width - 10;
        indicatorView.tag = IndicatorTag;
        [pageView addSubview:indicatorView];
        [indicatorView startAnimating];
        [indicatorView release];
    }
    
    if (!isShow && [pageView viewWithTag:IndicatorTag]) {
        [[pageView viewWithTag:IndicatorTag] removeFromSuperview];
    }
}

#pragma mark - buttons actions



- (void)onBtnCommodityVoted:(WTFButton*)btn
{
    if ([self isNotLoginAndShowLogin]) {
        return;
    }  

    if (!voteCommodity) {
        voteCommodity = [[SBVoteRequest alloc] init];
        voteCommodity.delegate = self;
    }
    wtfButton.enabled = NO;
    NSString* sid = commodityInfo.sid;
    NSString* cid = commodityInfo.cid;
    [voteCommodity voteForTypeCommodityItem:cid
                                     shopID:sid
                                     action:!wtfButton.isVoted];
}


- (void)onBtnUserInfo:(SBCommodityPhoto*)photo
{
    NSString* userID = photo.user.uid;
    if (!userID) return;
  //  VSLog(@"UID %@", userID);
    HomeViewController* vc = [[HomeViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    Stat(@"picdetail_clickportrait?u_fcry=%@", userID);
}

/*  喜欢图片的用户 icon */
- (void)onBtnUserLikedItem:(SBCommodityPhotoUser*)user
{
    NSString* userID = user.uid;
    if (userID) {
        HomeViewController* vc = [[HomeViewController alloc] initWithUserID:userID];
        [self.navigationController pushViewController:vc animated:YES];
        [vc release];
    }
}

- (void)onBtnBigImageClicked:(SBCommodityPhoto *)photo
{
    Stat(@"picdetail_bigpic");
    
	UIImage *img = [[SDWebImageManager sharedManager] imageWithURL:[NSURL URLWithString:photo.photoBigURLstr]];
    if (img) {
        SBImageDataSource *dataSource = [[SBImageDataSource alloc] initWithImages:[NSArray arrayWithObject:img]];
        SBPhotoScrollViewController *controller = [[SBPhotoScrollViewController alloc] initWithDataSource:dataSource andStartWithPhotoAtIndex:0];
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
        [self showModalViewController:navController animated:NO];
        [dataSource release];
        [controller release];
        [navController release];
    }
}

- (void)onBtnAddPhoto
{
    PhotoController* control = [PhotoController singleton];
    
    //add current commodity's info
    NSString* sid =  commodityInfo.sid;
    NSString* sname = commodityInfo.sname;
    NSString* cname = commodityInfo.cname;

    //TODO: need an delegate to handle this button's enable state
    if (sid && sname) {
        control.commodity = isNonCommodity ? @"" : cname; // Edit by MagicYang
        control.shopId = sid;
        control.shopName = sname;
        [control showActionSheet];
    }
}

- (void)onBtnSharePhoto
{
    Stat(@"sinashare_into");
    
    LoginController* loginC = [LoginController sharedInstance];
    if (![loginC isLogin]) {
        [loginC showLoginView];
        return;
    }
    
    if (!loginC.isWeiboBind) {
        [[WeiboBindController sharedInstance] showBindView];
        return;
    }
    
    if (!shareView) {
        shareView = [[WeiBoShareCommentsView alloc] initWithDelegate:self];
    }
    
    NSString *nickName = commodityMode.uname ? commodityMode.uname : @"";
    NSString *shopName = commodityInfo.sname ? commodityInfo.sname : @"";
    NSString *foodName = commodityInfo.cname ? commodityInfo.cname : @"";
    NSString *text = commodityInfo.cid ? 
                    [NSString stringWithFormat:@"我喜欢@%@ 在『%@』分享的美食\"%@\"", nickName, shopName, foodName] : 
                    [NSString stringWithFormat:@"我喜欢@%@ 在『%@』分享的照片", nickName, shopName];
    UITextView *tv = [shareView valueForKey:@"textView"];
    tv.text = text;
    
    [shareView showInMainWindow];
}

- (void)onAddComment
{
    if ([self isNotLoginAndShowLogin]) {
        return;
    }
    
	[VSCommentView showWithComment:@"" 
					   andDelegate:self 
						  onCommit:@selector(commentDidReceived:andExtra:)
						  onCancel:@selector(commentDidCancelled)
						  andExtra:NUM(1)];
//    WeiBoShareCommentsView* commentsView = [[WeiBoShareCommentsView alloc] initWithDelegate:self];
//    [commentsView showInMainWindow];
//    [commentsView release];
    
    SBCommodityPhoto *photo = [self _currentPhoto];
    Stat(@"piccmt_into?p_fcry=%@", photo.cid);
}

- (void)onTrigglelikeBtnClicked
{
    if ([self isNotLoginAndShowLogin]) {
        return;
    }else{
        if (!votePhoto) {
            votePhoto = [[SBVoteRequest alloc] init];
            votePhoto.delegate = self;
        }
    }
    
    LoginController* loginC = [LoginController sharedInstance];
    if (![loginC isLogin]) {
        [loginC showLoginView];
    } else {
        if (!votePhoto) {
            votePhoto = [[SBVoteRequest alloc] init];
            votePhoto.delegate = self;
        }
        SBCommodityPhoto *photo = [self _currentPhoto];
        votePhoto.withObj = photo;
        //        photo.isVoted = !photo.isVoted;
        [votePhoto voteForType:SBVoteRequestTypePhoto item:photo.cid action:!photo.isVoted];
    }
}

- (void)postComment:(NSString*)comment replyTo:(SBCommodityPhotoComment*)model
{    
    if (!hcPostComment) {
        hcPostComment = [[HttpRequest alloc] init];
        hcPostComment.delegate = self;
    }
    
    SBCommodityPhoto* photo = [self _currentPhoto];
    if (!photo || !photo.cid || [comment length]==0) {
        return;
    }
    
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:5];
    [dict setValue:photo.cid forKey:@"p_fcrid"];
    
    
    [dict setValue:SETNIL(model.userID, @"") forKey:@"u_fcrid_re"];
    [dict setValue:SETNIL(model.commentID, @"") forKey:@"cmtid_re"];
    [dict setValue:comment forKey:@"content"];
    
	VSSafeRelease(m_reply);
	m_reply = [model retain];
	
    [hcPostComment requestPOST:NSStringADD(ROOT_URL, @"/addPicCmt") 
                    parameters:dict
                       useStat:YES];
}

- (void)dismissShareAndModalPostingView
{
    [HUD hide:YES];
    VSSafeRelease(HUD);
    [shareView dismiss];
    VSSafeRelease(shareView);
}

#pragma mark - CommentCell Delegates

- (void)onCellViewReplyClicked:(SBCommodityPhotoComment*)comment
{
    if ([self isNotLoginAndShowLogin]) {
        return;
    }
    
    Stat(@"piccmt_reply?u_fcry=%@", comment.userID);
    
    SBUser* currentUser = CurrentAccount;
    if ([comment.userID isEqualToString:currentUser.uid]) {
        TKAlert(@"不能自己评论自己哦");
        return;
    }

	[VSCommentView showWithComment:[NSString stringWithFormat:@"回复 %@: ",comment.userName]
					   andDelegate:self 
						  onCommit:@selector(replyDidReceived:andExtra:)
						  onCancel:@selector(replyDidCancelled)
						  andExtra:comment];
	
//    WeiBoShareCommentsView* commentsView = [[WeiBoShareCommentsView alloc] initWithDelegate:self];
//    commentsView.withOjbAssign = comment;
//    [commentsView setValue:[NSString stringWithFormat:@"回复 %@: ",comment.userName]
//                forKeyPath:@"textView.text"];
//    [commentsView showInMainWindow];
//    [commentsView release];    
}

- (void)onCellViewUserIconClicked:(SBCommodityPhotoComment*)comment
{
    NSString* userID = comment.userID;
    if (!userID) return;

    HomeViewController* vc = [[HomeViewController alloc] initWithUserID:userID];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}


#pragma mark - WeiBoShareCommentsView Delagates

- (void)weiboShareView:(WeiBoShareCommentsView*)view cancelBtnPressed:(NSString*)content
{
    Stat(@"sinashare_cancel");
    
    [view dismiss];
    if (view == shareView) {
        VSSafeRelease(shareView);
    }

}

- (void)weiboShareView:(WeiBoShareCommentsView*)view confirmBtnPressed:(NSString*)content
{
    Stat(@"sinashare_commit");
    
    if (view == shareView) {
        if ([content length] > 140) {
            TKAlert(@"不能超过140字!");
            return;
        }
        if (content && [content length] >0) {
            [self shareCurrentPhoto2weibo:content];
        }
    } else {
        if ([content length] > 300) {
            TKAlert(@"不能超过300字!");
            return;
        }
        //post comment
        SBCommodityPhotoComment* comment = view.withOjbAssign;        
        
        [self postComment:content replyTo:comment];
        view.withOjbAssign = nil;
        [view dismiss];
    }
}

- (void)commentDidReceived:(NSString *)comment andExtra:(id)extra {
    Stat(@"piccmt_commit");
    
	if ([comment length] > 300) {
		TKAlert(@"错误:文字超过300字!");
		return;
	}
	
	if ([extra intValue] == 1) {		
		[self postComment:comment replyTo:nil];		
	}
}

- (void)commentDidCancelled
{
    Stat(@"piccmt_cancel");
}


- (void)replyDidReceived:(NSString *)comment andExtra:(id)extra {
    Stat(@"piccmt_replycommit");
    
	if ([comment length] > 300) {
		TKAlert(@"错误:文字超过300字!");
		return;
	}
	
	//post comment
	SBCommodityPhotoComment* reply = (SBCommodityPhotoComment *)extra;
	[self postComment:comment replyTo:reply];	
}

- (void)replyDidCancelled
{
    Stat(@"piccmt_replycancel");
}

#pragma mark - http actions

- (void)shareCurrentPhoto2weibo:(NSString*)comments
{
    //show posting modal view
    HUD = [[MBProgressHUD alloc] initWithView:self.vstabBarController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"传输中...";
    [HUD show:YES];
    
    if (!hcWeiboShare) {
        hcWeiboShare = [[HttpRequest alloc] init];
        hcWeiboShare.delegate = self;
    }
    NSString* url = NSStringADD(ROOT_URL, @"/share");
    NSDictionary* params = VSDictOK(commodityMode.pid,@"p_fcrid",
                                    comments,@"text");
    
    [hcWeiboShare requestPOST:url parameters:params useStat:YES];
}

- (void)loadMoreImages
{
    if (!hcMorePhoto) {
        hcMorePhoto = [[HttpRequest alloc] init];
        hcMorePhoto.delegate = self;
    }
    NSString* cid = commodityInfo.cid;
    NSString* sid = commodityInfo.sid;
    if (cid && sid) {
        NSString* url = [NSString stringWithFormat:@"%@/getMorePictureList?f=%d&c_fcrid=%@&s_fcrid=%@&p=%d&pn=%d",ROOT_URL,from,cid,sid,pagePhotoRequest,CommodityPhotoDetailVC_PN];
        [self _showLoadMorePhotoIndicator:YES];
        [hcMorePhoto requestGET:url useStat:YES];
    }else{
        VSLogERROR(@"cid or sid not exists");
    }
}

- (void)loadImageDetails
{
    // 禁用分享
    [toolbar enableShareButton:NO];
	[self loadImageDetailsForModel:commodityMode];
}

- (void)loadImageDetailsForModel:(SBCommodity*)model
{
    CancelRequest(hcMorePhoto);
    CancelRequest(voteCommodity);
    CancelRequest(votePhoto);
	if (!hcDetails) {
		hcDetails = [[HttpRequest alloc] init];
		hcDetails.delegate = self;
	}
    
	[hcDetails cancel];
    pagePhotoRequest = 1;
	if(commodityMode != model){
		[commodityMode release];
		commodityMode = [model retain];
	}
    VSSafeRelease(commodityInfo);
	
	NSString* cid = SETNIL(model.cid,@"");
	NSString* sid = SETNIL(model.sid,@"");
	NSString* pid = SETNIL(model.pid,@"");
	
    /* rules 
     当f=1|2时，必须传递c_fcrid,s_fcrid
     f=1且是最新时，传递p_fcrid
     */
    int cityID;
    cityID = [[LocationService sharedInstance] currentLocation].cityId;
    if (!cityID) {
        cityID = CurrentCityId;
    }
    NSString* url = [NSString stringWithFormat:@"%@%@?c_fcrid=%@&s_fcrid=%@&p_fcrid=%@&f=%d&city_id=%d&pn=%d",ROOT_URL,@"/getpicturedetail",cid,sid,pid,from,cityID,CommodityPhotoDetailVC_PN];
    //from DiscoveryModule ,should add tab value
    if (from == 1) {
        url = [url stringByAppendingFormat:@"&t=%d",tab];
    }
    
	[hcDetails requestGET:url useStat:YES];
}

#pragma mark -
#pragma mark HttpRequest delegate

- (void)requestSucceeded:(HttpRequest *)request
{
	if (request == hcDetails) {
		NSError* error = nil;
		VSSafeRelease(commodityInfo);
		VSSafeRelease(commodityPhotos);
		NSArray* photos = [SBApiEngine parseImageDetailInfo:request.recievedData to:&commodityInfo error:&error];
		
		if (error) {
            TKAlert(NSStringADD(@"获取信息失败", [error localizedDescription]));
			return;
		}
		
        // 启用分享
        [toolbar enableShareButton:YES];
        
		[commodityInfo retain];
		commodityPhotos = [[NSMutableArray alloc] init];
		[commodityPhotos addObjectsFromArray:photos];
        
		commodityMode.uname = ((SBCommodityPhoto *)[commodityPhotos objectAtIndex:0]).user.uname;
		
		[self setupSubViewBymodel];
        Release(hcDetails);
        return;
	}
    
    if (request == hcMorePhoto) {
        [self _showLoadMorePhotoIndicator:NO];
        NSError* error = nil;
        NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
        if (error) {
            [self requestFailed:request error:error];
        }else{
            NSArray* morePhotos = [SBApiEngine parseMorePhotos:dict];
            if ([morePhotos count] >0 ) {
                pagePhotoRequest++;
                [commodityPhotos addObjectsFromArray:morePhotos];
                pageView.pageCount = commodityPhotos.count;
            }
        }
        Release(hcMorePhoto);
        return;
    }
    
    if (request == hcWeiboShare) {
        NSError* error = nil;
        [SBApiEngine parseHttpData:request.recievedData
                             error:&error];
        if (error) {
            [self requestFailed:request error:error];
        }else{
            [self dismissShareAndModalPostingView];
            TKAlert(@"分享成功!");
        }
        return;
    }
    
    NSError* error = nil;
    if ([SBApiEngine parseHttpData:request.recievedData
                             error:&error]) {
        if (error) {
            [self requestFailed:request error:error];
            return;
        }
    }
    
    if (request == hcPostComment) {
        // Add new comment to view immediately
        NSDictionary *dict = [SBApiEngine parseHttpData:request.recievedData
                             error:&error];
        NSString *prefix = [NSString stringWithFormat:@"%@/view/pic/item/", ROOT_URL];
        SBCommodityPhotoComment *cmt = [[SBCommodityPhotoComment alloc] initWithDict:dict imgPrefix:prefix];
        cmt.userID = CurrentAccount.uid;
		if (m_reply) {
			cmt.contents = [NSString stringWithFormat:@"回复%@：%@", m_reply.userName, cmt.contents];
		}
		[[self _currentPhoto].commentList.comments insertObject:cmt atIndex:0];
        [cmt release];
        for (UIView *subview in [pageView subviews]) {
            if ([subview isKindOfClass:[CommodityPhotoSingleView class]]) {
                [((CommodityPhotoSingleView *)subview) reloadData];
                [((CommodityPhotoSingleView *)subview) updateFooterRefreshView];
            }
        }
        TKAlert(@"发布成功!");
		VSSafeRelease(m_reply);
        return;
    }
    
    if (request == voteCommodity) {
        wtfButton.enabled = YES;
        [wtfButton setVoted:!wtfButton.isVoted];
        commodityInfo.isCVoted = wtfButton.isVoted;
        
        Stat(@"picdetail_voteitem?m=%d&suc=1&errcode=0", commodityInfo.isCVoted);
        
        return;
    }
    
    if (request == votePhoto) {
        SBCommodityPhoto* photo = votePhoto.withObj;
        photo.isVoted = !photo.isVoted;
        
        Stat(@"picdetail_votepic?m=%d&suc=1&errcode=0", photo.isVoted);
        
        //if its the current photo
        if (photo == [self _currentPhoto]) {
            [toolbar updateLikeButtonWithState:photo.isVoted];
        }
        votePhoto.withObj = nil;
        
        return;
    }
    
}

- (void)requestFailed:(HttpRequest *)request error:(NSError *)error
{
    NSDictionary *dict = [SBApiEngine parseHttpData:request.recievedData error:NULL];
    NSInteger errNo = [[dict objectForKey:@"errno"] intValue];
    if (request == hcDetails) {
        self.navigationItem.rightBarButtonItem = nil;
        Release(hcDetails);
        return;
    }
    
    if (request == hcMorePhoto) {
        [self _showLoadMorePhotoIndicator:NO];
        Release(hcMorePhoto);
        return;
    }
    
	if (request == votePhoto) {
        SBCommodityPhoto* photo = votePhoto.withObj;
        Stat(@"picdetail_votepic?m=%d&suc=0&errcode=%d", !photo.isVoted, errNo); // 因为失败，所以要对#isVoted#取非才是实际操作
        votePhoto.withObj = nil;
        return;

    }
    if (request == voteCommodity) {
        Stat(@"picdetail_voteitem?m=%d&suc=1&errcode=0", !commodityInfo.isCVoted); // 因为失败，所以要对#isCVoted#取非才是实际操作
        wtfButton.enabled = YES;
        return;
    }
    
    
    if (request == hcWeiboShare) {
        [self dismissShareAndModalPostingView];
        TKAlert(@"分享微博失败");
        return;
    }
}


#pragma mark -
#pragma mark Memory
- (void)didReceiveMemoryWarning
{
	[pageView cleanCaches];
	[super didReceiveMemoryWarning];
}


#pragma mark - Button actions

- (void)onBtnShopFieldPressed:(id)s
{
    if(! commodityInfo.sid ){
        return;
    }

    ShopInfoViewController* vc = [[ShopInfoViewController alloc] initWithShopId:commodityInfo.sid];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (void)onBtnPreviousPressed:(id)s
{

	curItemIndex -= 1;
	if (curItemIndex < 0) {
		curItemIndex = 0;
		return;
	}	

//	[self.view.layer addAnimation:[self transationPushUp:YES] 
//						   forKey:nil];
	SBCommodity* model = nil;
	if (datasource) {
		model = [datasource.currentList objectAtIndex:curItemIndex];		
	}else if (commodityArray) {
		model = [commodityArray objectAtIndex:curItemIndex];	
	}

	[self loadViewForModel:model];
	
	[self updateBtnPreNextStatus];
    SBCommodityPhoto* photo = [self _currentPhoto];    
    [toolbar updateLikeButtonWithState:photo.isVoted];
    
    Stat(@"picdetail_changepic?m=0&p_fcry=%@", photo.cid);
}

- (void)onBtnNextPressed:(id)s
{	
	curItemIndex += 1;
	if (datasource) {
		if (curItemIndex < datasource.currentList.array.count) {
			SBCommodity* model = [datasource.currentList objectAtIndex:curItemIndex];
//			[self.view.layer addAnimation:[self transationPushUp:NO] 
//								   forKey:nil];
			[self loadViewForModel:model];
		} else {
			if (datasource.currentList.hasMore) {
				curItemIndex -= 1;

                [datasource loadMoreForCurrentList];
			}else {
				curItemIndex -= 1;
			}
		}
	} else if (commodityArray) {
		if (curItemIndex <= commodityArray.count) {
			SBCommodity* model = [commodityArray objectAtIndex:curItemIndex];
//			[self.view.layer addAnimation:[self transationPushUp:NO] 
//								   forKey:nil];
			[self loadViewForModel:model];			
		}else {
			curItemIndex -= 1;
		}

	}


	[self updateBtnPreNextStatus];
    SBCommodityPhoto* photo = [self _currentPhoto];
    [toolbar updateLikeButtonWithState:photo.isVoted];
    
    Stat(@"picdetail_changepic?m=0&p_fcry=%@", photo.cid);
}

- (CAAnimation*)transationPushUp:(BOOL)isPushUP
{
	CATransition *transition = [CATransition animation];
	transition.duration = 0.55;
	transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
	transition.type = kCATransitionPush;
	if (isPushUP) {
		transition.subtype = kCATransitionFromBottom;
	}else {
		transition.subtype = kCATransitionFromTop;
	}

	
	transition.delegate = self;
	return transition;
}


- (void)loadViewForModel:(SBCommodity*)model
{
	[self loadImageDetailsForModel:model];
	
	containerViewCurrent.hidden = YES;
	[containerViewCurrent removeFromSuperview];
	
	[self setupSubViewBymodel];
}

#pragma mark - datasource delegate
- (void)datasource:(DatasourceDiscovery *)ds failedWithError:(NSError *)error
{

}

- (void)datasource:(DatasourceDiscovery *)ds successLoaded:(BOOL)isInit
{
	if (!isInit) {
		// notify loaded more datas
	}
}

// Add by MagicYang
#pragma mark - 
#pragma mark Delegate for UI
- (void)showShopInfo
{
    if(!commodityInfo.sid) {
        return;
    }
    ShopInfoViewController* vc = [[ShopInfoViewController alloc] initWithShopId:commodityInfo.sid];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

- (BOOL)_isHaveRecommandButton
{
    return commodityInfo.isCommodity && from != CommodityPhotoSourceFromShopAlbum;
}

- (SBCommodityPhoto*)_currentPhoto
{
    return [commodityPhotos objectAtIndex:pageView.currentIndex];
}

- (BOOL)isNotLoginAndShowLogin
{
    LoginController* loginC = [LoginController sharedInstance];
    if (![loginC isLogin]) {
        [loginC showLoginView];
        return YES;
    }     
    return NO;
}
@end
