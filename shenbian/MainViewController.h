//
//  MainViewController.h
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import "SBPickerViewController.h"


extern BOOL hasAlertGPSEnabled;

@class SBSearchBar;
@class VSTableView;
@class HttpRequest;
@class SBLocationView;
@class LoadingView;

@interface MainViewController : SBNavigationController<UITableViewDelegate, UITableViewDataSource, SBPickerDelegate> {
    SBSearchBar *searchBar;
    VSTableView *tableView;
    LoadingView *loadingView;
    
    NSMutableArray *channelList, *areaList;
    BOOL hasBianmin;   // Indicate whether there is category "便民"
    HttpRequest *request;
    
    BOOL hasLocated;
    
    SBLocationView *locationView;
}

@end