//
//  BadgeListVC.m
//  shenbian
//
//  Created by xhan on 5/17/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "BadgeListVC.h"
#import "HttpRequest+Statistic.h"
#import "BadgeDetailVC.h"
#import "SBBadge.h"
#import "SBApiEngine.h"
#import "CacheCenter.h"
#import "LoadingView.h"

@implementation BadgeListVC

- (void)showLoading {
	if (!loadingView) {
		loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:@""];
	}
	[self.view addSubview:loadingView];
}

- (void)hideLoading {
	[loadingView removeFromSuperview];
}

- (id)initWithUserID:(NSString*)ufcrid
{
    self = [super init];    
    if (self) {
        self.hidesBottomBarWhenPushed = YES;
        userID = [ufcrid copy];
        badgesList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    VSSafeRelease(userID);
    VSSafeRelease(badgesList);
    VSSafeRelease(listView);
    [super dealloc];
}


#pragma mark - View lifecycle

- (void)loadView
{
    [super loadView];
    
    self.title = @"我的徽章";
    self.view.backgroundColor = [UIColor clearColor];
    listView = [[BadgeListView alloc] initWithFrame:vsr(0, 0, 320, 0)];
    listView.badgeDelegate = self;
    [self addSubview:listView];
}

- (void)viewDidAppear:(BOOL)animated
{
	NSString *session = [NSString stringWithFormat:@"home_intobadge?u_fcry=%@", userID];
	Stat(session);
	
    [super viewDidAppear:animated];
    if ([badgesList count] == 0) {
        [self loadBadgeList];
    }else{
        [listView reloadData:badgesList];
    }
}


- (void)viewDidUnload
{
    VSSafeRelease(listView);
    [super viewDidUnload];
}


#pragma mark - actions

- (void)loadBadgeList
{
    if (!httpClient) {
        [self showLoading];
        httpClient = [[HttpRequest alloc] init];
        httpClient.delegate = self;
        BOOL isMyself = [CurrentAccount.uid isEqualToString:userID] ? 1 : 0;
        NSString *url = [NSString stringWithFormat:@"%@/getBadgeList?myself=%d&u_fcrid=%@", 
                         ROOT_URL, isMyself, userID];
        [httpClient requestGET:url useStat:YES];
    }
}

#pragma mark badge delegate
- (void)badgeListView:(BadgeListView *)view badgeClicked:(SBBadge *)badge atIndex:(int)index
{
    BadgeDetailVC *vc = [[BadgeDetailVC alloc] initWithBadge:badge];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
}

#pragma mark - 

- (void)requestSucceeded:(HttpRequest *)request
{
    [badgesList removeAllObjects];
    NSError* error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    NSArray* badges = VSDictV(dict,@"list");
    for (NSDictionary* item in badges) {
        SBBadge* badge = [[SBBadge alloc] initWithRemoteDict:item];
		badge.userId = userID;
        [badgesList addObject:badge];
        [badge release];
    }
    
    [listView reloadData:badgesList];
    Release(httpClient);
    [self hideLoading];
}
- (void)requestFailed:(HttpRequest *)request error:(NSError *)error
{
    Release(httpClient);
    [self hideLoading];
}

@end
