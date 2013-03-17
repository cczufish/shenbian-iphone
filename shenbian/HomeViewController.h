//
//  HomeViewController.h
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"
#import "SBSegmentView.h"

@class SBUser;
@class HttpRequest;
@interface HomeViewController : SBNavigationController
<UITableViewDelegate, UITableViewDataSource> {
    UIView *loginView;
	UIImageView *header;
    UITableView *tableView;
    UILabel *nameView, *mammonView;
    UIImageView *photoView, *levelView, *mammonIcon, *vipIcon;
    BOOL isMainAccount;
    SBUser *user;
    HttpRequest *request, *removeBindRequest;
	HttpRequest	*reportRequest;	//	战报
    HttpRequest *followRequest;
    UIButton *btn_following;
    int attention;
    SBSegmentView *titleTabView;
    UIScrollView *mainScollview;
}

@property(assign) BOOL isMainAccount;

- (id)initWithUserID:(NSString *)uid;
-(void)followUser;


@end
