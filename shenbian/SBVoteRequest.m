//
//  SBVoteRequest.m
//  shenbian
//
//  Created by xu xhan on 5/23/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBVoteRequest.h"
#import "AlertCenter.h"
@implementation SBVoteRequest
@synthesize withObj;

- (void)voteForType:(SBVoteRequestType)type item:(NSString*)itemID action:(BOOL)isAdd
{
    //SBVoteRequestTypeCommodity 需要额外的shopID
    if (type == SBVoteRequestTypeCommodity) {
        NSAssert(NO, @"call voteForTypeCommodityItem instead");        
    }
    [self _vote:type item:itemID shopID:nil action:isAdd];
    
}
- (void)voteForTypeCommodityItem:(NSString*)itemID shopID:(NSString*)shopID  action:(BOOL)isAdd
{
#ifdef DEBUG
//    NSAssert(shopID, @"itemID should not be nil");
    if (!shopID) {
        Alert(@"DEBUG", @"shop id should not be nil in Voting commodity!");
        return;
    }
    
#endif
    [self _vote:SBVoteRequestTypeCommodity item:itemID shopID:shopID action:isAdd];
}

- (void)_vote:(SBVoteRequestType)type item:(NSString*)itemID shopID:(NSString*)shopID  action:(BOOL)isAdd
{
#ifdef DEBUG
//    NSAssert(itemID, @"itemID should not be nil");
    if (!itemID) {
        Alert(@"DEBUG", @"main id should not be nil in Voting!");
        return;
    }
#endif
    NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:4];
    [dict setObject:NUM(type) forKey:@"t"];
    NSString* key = nil;
    if (type == SBVoteRequestTypePhoto) {
        key = @"p_fcrid";
    }else if(type == SBVoteRequestTypeCommodity){
        key = @"c_fcrid";
    }else if(type == SBVoteRequestTypeShop){
        key = @"s_fcrid";
    }
    [dict setObject:itemID forKey:key];
    if (shopID) {
        [dict setObject:shopID forKey:@"s_fcrid"];
    }
    [dict setObject:NUM(isAdd) forKey:@"c"];
    
    [self requestPOST:NSStringADD(ROOT_URL, @"/vote") 
           parameters:dict];
}

- (void)dealloc
{
    VSSafeRelease(withObj);
    [super dealloc];
}
@end
