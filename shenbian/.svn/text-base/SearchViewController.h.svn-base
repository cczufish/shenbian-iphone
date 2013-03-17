//
//  SearchViewController.h
//  shenbian
//
//  Created by MagicYang on 10-11-22.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSearchBar.h"
#import "SBNavigationController.h"


typedef enum {
	SearchTypeChannel = 0,
	SearchTypeArea    = 1
} SearchType;


@class HttpRequest;
@class SBSearchBar;
@class CacheCenter;
@class SBLocationView;
@interface SearchViewController : SBNavigationController
<SBSearBarDelegate, UITableViewDelegate, UITableViewDataSource> {
	UIView *searchMainView;
	SBSearchBar *searchBar, *nearbyBar;
	UITableView *searchTableView;
	SBLocationView *locationView;
    
	NSMutableArray *resultList;
	HttpRequest *request;
	CacheCenter *cacheCenter;
	SearchType currentSearchType;
}


@end