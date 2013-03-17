//
//  CouponInfoViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-20.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"


typedef enum {
	InfoRequest = 0,
	SMSRequest  = 1
} RequestType;


@class HttpRequest;
@class SBCoupon;
@class LoadingView;

@interface CouponInfoViewController : SBNavigationController<UITableViewDelegate, UITableViewDataSource> {
	UITableView *tableView;
    LoadingView *loadingView;
    
    HttpRequest *request;
	NSMutableDictionary *smsRequests;
	NSMutableArray *couponList;
    
	NSString *shopId;	
	NSString *phoneNumber;
	NSString *selectedCouponId;
}

@property(nonatomic, retain) NSString *shopId;
@property(nonatomic, retain) NSString *phoneNumber;
@property(assign) BOOL displayShop;
@property(nonatomic, retain) NSString *selectedCouponId;

- (CouponInfoViewController *)initWithShopId:(NSString *)shopId;

@end
