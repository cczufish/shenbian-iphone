//
//  ShopMapInfoViewController.h
//  shenbian
//
//  Created by MagicYang on 10-11-25.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import "LocationService.h"

@class LoadingView;
@interface ShopMapInfoViewController : SBNavigationController<UIWebViewDelegate> {
	UIWebView *webView;
	BaiduLocation location;
	NSString *shopName;
	LoadingView *loadingView;
}

@property(nonatomic, assign) BaiduLocation location;
@property(nonatomic, retain) NSString *shopName;

- (ShopMapInfoViewController *)initWithLocation:(BaiduLocation)aLocation;

@end
