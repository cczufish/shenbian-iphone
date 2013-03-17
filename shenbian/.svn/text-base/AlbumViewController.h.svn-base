//
//  AlbumViewController.h
//  shenbian
//
//  Created by MagicYang on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"


@class HttpRequest;

@interface AlbumViewController : SBTableViewController {
    NSMutableArray *albumList;
    NSInteger totalCount, currentPage;
    HttpRequest *request;
    NSString *shopId;
}

@property(nonatomic, copy) NSString *shopId;

- (AlbumViewController *)initWithShopId:(NSString *)shopID;

@end
