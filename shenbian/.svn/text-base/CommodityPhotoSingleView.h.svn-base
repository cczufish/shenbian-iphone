//
//  CommodityPhotoSingleView.h
//  shenbian
//
//  Created by xhan on 4/21/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityPhotoDetailVC.h"
#import "PhotoHeaderView.h"
#import "EGORefreshTableFooterView.h"
#import "HttpRequest+Statistic.h"

@class SBTriggleButton;
@class PhotoWrapperView, SBCommodityPhoto;

@interface CommodityPhotoSingleView : UITableView<UITableViewDataSource,UITableViewDelegate,EGORefreshTableFooterDelegate,HttpRequestDelegate> {
	PhotoWrapperView* photoWrapperView;
	SBCommodityPhoto* photo;
    
    EGORefreshTableFooterView* refreshFooter;
    BOOL isRefreshingFooter;
    HttpRequest* hcLoadMoreComment;
}

@property(nonatomic,readonly) SBCommodityPhoto* photo;
@property(nonatomic,readonly) PhotoWrapperView* photoWrapperView;

- (id)initWithPhoto:(SBCommodityPhoto*)photo type:(PhotoHeaderViewType)type;

- (void)updateFooterRefreshView;
- (void)loadMoreComments;
- (void)finishedHttpClientLoadmore;


@end
