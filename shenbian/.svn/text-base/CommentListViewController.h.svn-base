//
//  CommentListViewController.h
//  shenbian
//
//  Created by MagicYang on 10-11-23.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"


@class HttpRequest;
@class SBShopInfo;
@interface CommentListViewController : SBTableViewController
<UITableViewDelegate, UITableViewDataSource> {
	NSMutableArray *commentList;	

	SBShopInfo *shopInfo;
	NSInteger totalCount, currentPage;
	
	HttpRequest *request;
	
	BOOL hasTabbar;
}

@property(nonatomic, retain) SBShopInfo *shopInfo;
@property(assign) BOOL hasTabbar;

- (CommentListViewController *)initCommentListControllerWithShop:(SBShopInfo *)aShopInfo;

@end
