//
//  SBPickerViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import "LoadingView.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "SBObject.h"


@protocol SBPickerDelegate;

@interface SBPickerViewController : SBNavigationController<UITableViewDelegate, UITableViewDataSource> {
	id<SBPickerDelegate> delegate;
	UITableView *tableView;
	LoadingView *loadingView;
	HttpRequest *request;
	
	BOOL hasCancelButton;
	BOOL hasTabbar;
}

@property(assign) id<SBPickerDelegate> delegate;
@property(assign) BOOL hasCancelButton;
@property(assign) BOOL hasTabbar;

- (id)initWithDelegate:(id)del;

- (void)_loadDataSource;
- (void)_dataSourceReady;

@end



@protocol SBPickerDelegate
@required
- (void)pickerController:(id)controller pickData:(id)data;
- (void)pickerControllerCancelled:(id)controller;
@end