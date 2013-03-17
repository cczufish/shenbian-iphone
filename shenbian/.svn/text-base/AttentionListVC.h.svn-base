//
//  AttentionListVC.h
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"
#import "EGORefreshTableFooterView.h"
@class EGORefreshTableFooterView;

@interface AttentionListVC : SBTableViewController
{
    NSString *userId;
    NSMutableArray *resultList;
    HttpRequest *request,*hcLoadMore;
    NSInteger currentPage, totalCount;
    UITableView* _tableView;
    EGORefreshTableFooterView* refreshFooter;
    BOOL isRefreshingFooter;
    int requestType;
}
@property(nonatomic, copy) NSString *userId;
- (id)initWithUserID:(NSString*)ufcrid RType:(int)type;
@end
