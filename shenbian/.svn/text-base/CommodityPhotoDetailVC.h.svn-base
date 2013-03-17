//
//  CommodityPhotoDetailVC.h
//  shenbian
//
//  Created by xhan on 4/15/11.
//  Copyright 2011 百度. All rights reserved.
//


#import "SBNavigationController.h"
#import "VSPageView.h"
#import "DatasourceDiscovery.h"
#import "SBVoteRequest.h"
#import "MBProgressHUD.h"

typedef enum{
	CommodityPhotoDetailTypeNone  , //nothing on the headerBar
	CommodityPhotoDetailTypeCommodityOnly,
	CommodityPhotoDetailTypeShopOnly ,
	CommodityPhotoDetailTypeBoth 
}CommodityPhotoDetailType;

typedef enum{
	CommodityPhotoSourceFromError        = -1,
	CommodityPhotoSourceFromDiscovery    = 1,
	CommodityPhotoSourceFromShopInfo     = 2,
	CommodityPhotoSourceFromShopAlbum    = 3,
	CommodityPhotoSourceFromUserAlbum    = 4,
    CommodityPhotoSourceFromNotification = 5
}CommodityPhotoSourceFrom;

@class SBCommodityPhoto,SBCommodityPhotoInfo, WTFButton;
@class PhotoWrapperView, CommodityPhotoSingleView, PhotoHeaderView;
@class CAAnimation, SBCommodity, DatasourceDiscovery,PictureDetailToolbar;
@class DiscoveryViewController, WeiBoShareCommentsView,SBCommodityPhotoComment;
@class HttpRequest;
@interface CommodityPhotoDetailVC : SBNavigationController<HttpRequestDelegate,VSPageViewDelegate,DatasourceDiscoveryDelegate> {
	
	HttpRequest *hcDetails, *hcMorePhoto, *hcWeiboShare, *hcPostComment;
    
	UIView* containerViewCurrent;
	VSPageView* pageView;
	PhotoHeaderView* headerView;
	WTFButton* wtfButton; 
	PictureDetailToolbar* toolbar;
    
	UIButton* btnNavPrevious;
	UIButton* btnNavNext;

	//data models - common
	SBCommodity* commodityMode; // (an commodity contains many photos)
	CommodityPhotoDetailType displayType;
	SBCommodityPhotoComment *m_reply;

	BOOL isShowBtnPreNext;
	
	// data models - current
	SBCommodityPhotoInfo* commodityInfo;
	NSMutableArray* commodityPhotos;
    int pagePhotoRequest;   //default page should be 1!
    
	// data source - shared from DiscoveryViewController
	// non retain values (assign only)
	int curItemIndex;
	DatasourceDiscovery* datasource;
	DiscoveryViewController* discoveryVC;
	
	// data model - for displaying Array of images
	NSArray* commodityArray;
		
	//
	CommodityPhotoSourceFrom from;
    int tab;    //only used when from = 1
    //vote httpclients
    SBVoteRequest *voteCommodity, *votePhoto;
    
    MBProgressHUD *HUD;
    WeiBoShareCommentsView* shareView;
    
    // Add by MagicYang 2011-06-08
    BOOL isNonCommodity;    // 标识是否为非美食图片
    
    // Add by MagicYang 2011-08-04
    // Used for session statistics
    NSInteger currentPicIndex;
}

@property(nonatomic,assign) CommodityPhotoSourceFrom from;
@property(nonatomic,assign) int tab;
@property(assign)BOOL isNonCommodity;

- (id)initWithCommdity:(SBCommodity*)model displayType:(CommodityPhotoDetailType)type;
- (id)initWithCommdity:(SBCommodity*)model
		   displayType:(CommodityPhotoDetailType)type 
			Datasource:(DatasourceDiscovery*)ds 
			previousVC:(DiscoveryViewController*)vc;
- (id)initWithCommdityArray:(NSArray*)commodityAry 
           currentItemIndex:(int)index
                displayType:(CommodityPhotoDetailType)type;

/////// private methods //////////
- (void)setupSubViewBymodel;
- (void)loadImageDetails;
- (void)loadImageDetailsForModel:(SBCommodity*)model;
- (void)loadMoreImages;
- (void)shareCurrentPhoto2weibo:(NSString*)comments;


- (void)setupHeaderViewBytype;
- (void)setupPhotoContentView;
- (void)setupNavigationBarButtons;
- (void)setupWTFbuttons;
- (void)_showLoadMorePhotoIndicator:(BOOL)isShow;

- (void)onBtnPreviousPressed:(id)s;
- (void)onBtnNextPressed:(id)s;
- (void)onBtnShopFieldPressed:(id)s;

- (void)updateBtnPreNextStatus;

- (CAAnimation*)transationPushUp:(BOOL)isPushUP;

- (void)loadViewForModel:(SBCommodity*)model;

- (BOOL)isHavingMorePhotos;

- (void)dismissShareAndModalPostingView;

- (void)postComment:(NSString*)comment replyTo:(SBCommodityPhotoComment*)model;

- (BOOL)_isHaveRecommandButton;

- (SBCommodityPhoto*)_currentPhoto;

- (BOOL)isNotLoginAndShowLogin;

@end
