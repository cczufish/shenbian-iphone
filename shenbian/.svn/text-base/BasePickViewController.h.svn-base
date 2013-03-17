//
//  BasePickViewController.h
//  shenbian
//
//  Created by MagicYang on 4/29/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"
#import "SBSearchBar.h"
#import "UIAdditions.h"
#import "HttpRequest+Statistic.h"


typedef enum {
    RequestTypeDefault = 0,
    RequestTypeSuggest = 1,
    RequestTypeSearch  = 2
} RequestType;


@class SBSearchBar;
@class HttpRequest;
@interface BasePickViewController : SBTableViewController {
    SBSearchBar *searchBar;
    HttpRequest *request;
    RequestType requestType;
    NSMutableArray *list;
    
    NSUInteger totalCount, currentPage;
}

- (void)cleanAll;
- (void)showDefault;
- (void)doSuggest;
- (void)doSearch;

@end
