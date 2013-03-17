//
//  SBSuggestion.h
//  shenbian
//
//  Created by MagicYang on 4/14/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SBSuggestion

@end


@interface SBSuggestKeyword : NSObject<SBSuggestion> {
    NSString *keyword;
    NSInteger count;
}

@property(nonatomic, retain) NSString *keyword;
@property(nonatomic, assign) NSInteger count;

@end



@interface SBSuggestShop : NSObject<SBSuggestion> {
    NSString *shopId;
    NSString *shopName;
    NSString *shopAddress;
    NSString *distance; // 单位:米
    BOOL isCommodityShop;  // 标识是否为美食 
}

@property(nonatomic, assign) BOOL isCommodityShop;
@property(nonatomic, copy) NSString *shopId;
@property(nonatomic, copy) NSString *shopName;
@property(nonatomic, copy) NSString *shopAddress;
@property(nonatomic, copy) NSString *distance;

@end

