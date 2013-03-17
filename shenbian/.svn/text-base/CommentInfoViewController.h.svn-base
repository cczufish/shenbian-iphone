//
//  CommentInfoViewController.h
//  shenbian
//
//  Created by MagicYang on 10-11-23.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"


typedef struct {
	NSInteger current;
	NSInteger total;
} PercentCount;


@class HttpRequest;

@interface CommentInfoViewController : SBNavigationController
<UITableViewDelegate, UITableViewDataSource> {
    id delegate;
	UITableView *tableView;
	NSMutableArray *commentList;
	PercentCount index;
	UIButton *preButton, *nxtButton;
	UIView *navigationButton;
	
	HttpRequest *voteRequest;
	NSString *shopId;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSMutableArray *commentList;
@property(nonatomic, assign) PercentCount index;
@property(nonatomic, retain) NSString *shopId;

- (CommentInfoViewController *)initWithDelegate:(id)delegate commentList:(NSMutableArray *)list andIndex:(PercentCount)anIndex;

@end
