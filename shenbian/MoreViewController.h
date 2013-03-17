//
//  MoreViewController.h
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerViewController.h"
#import "BrowseHistoryViewController.h"
#import "SBTableViewController.h"
#import "VSTabBarController.h"
#import "AdvertisementController.h"

@class HttpRequest;

@interface MoreViewController : SBTableViewController
<SBPickerDelegate, UIActionSheetDelegate>
{
    NSArray* _dataSource;
	UILabel* _cityLabel;
	int historyCount;
	UIButton* loginButton;
    
    HttpRequest *request;
	
	AdvertisementController *adController;
	
    BOOL isSync;
}

@property (nonatomic, retain) NSArray* _dataSource;
@property (nonatomic, retain) UILabel* cityLabel;
@property (nonatomic, retain) UIButton* loginButton;

@end
