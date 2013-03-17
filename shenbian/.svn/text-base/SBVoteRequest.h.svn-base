//
//  SBVoteRequest.h
//  shenbian
//
//  Created by xu xhan on 5/23/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"

typedef enum{
    SBVoteRequestTypePhoto = 1,
    SBVoteRequestTypeCommodity = 2,
    SBVoteRequestTypeShop = 3
}SBVoteRequestType;

@interface SBVoteRequest : HttpRequest
{
    id withObj;
}
@property(nonatomic,retain)id withObj;

- (void)voteForType:(SBVoteRequestType)type item:(NSString*)itemID action:(BOOL)isAdd;

- (void)voteForTypeCommodityItem:(NSString*)itemID shopID:(NSString*)shopID  action:(BOOL)isAdd;

//private
- (void)_vote:(SBVoteRequestType)type item:(NSString*)itemID shopID:(NSString*)shopID  action:(BOOL)isAdd;

@end
