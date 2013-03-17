//
//  ShopInfoViewController.h
//  shenbian
//
//  Created by MagicYang on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import <MessageUI/MessageUI.h>
#import "HttpRequest+Statistic.h"

typedef enum {
	SectionCoupon    = 1,   //优惠
    SectionContact   = 2,   //电话地址
    SectionCommondity= 3,   //菜单
	SectionComment   = 4,   //点评
    SectionPicCount  = 5
} SectionType;


@class SBShopInfo;
@class LoadingView;
@class HttpRequest;
@class SBVoteRequest;
@interface ShopInfoViewController : SBNavigationController<
UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate,
MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,HttpRequestDelegate> {	
	UITableView *tableView;
    LoadingView *loadingView;
    
    SBShopInfo *shopInfo;
	NSMutableArray *sections;
    
    HttpRequest *request;
    SBVoteRequest *hcVoteShop;
}

- (id)initWithShopId:(NSString *)shopId;

@end
