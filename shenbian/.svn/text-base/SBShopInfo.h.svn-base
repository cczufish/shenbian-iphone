//
//  ShopInfo.h
//  shenbian
//
//  Created by MagicYang on 10-11-22.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBShopInfo : NSObject {
	// 商户ID
	NSString *shopId;
	// 商户名称
	NSString *strName;
	// 城市ID
	NSInteger intCityId;
    // 电话号码
	NSArray *arrTel;
	// 商户地址
	NSString *strAddress;
    // X, Y坐标
	CGFloat fltPositionX, fltPositionY;
    // 人均消费
	CGFloat fltAverage;
    // 商户星级 (取值范围:0－10, 显示采用5分制)
	CGFloat intScoreTotal;
    // 口味 服务 上菜 速度
	NSDictionary *arrScore;
    // 去过人数
    NSInteger intBeenCount;
    // 图片数
	NSInteger intPicCount;
	// 商户状态 (0：未审核, 1：审核通过, 2：审核未通过, 3：暂停营业, 8：封杀，前端任何地方都不可见，相当于删除,9：停止营业)
	NSInteger intStatus;
    // 营业时间,商户别名,特色服务,交通信息,座位数  and so on...
    NSDictionary *moreInfo;
	// 推荐菜 推荐品种 推荐服务(名称)
	NSString *strRecommendName;
	// 推荐菜 推荐品种 推荐服务(内容)
	NSDictionary *arrRecommend;
	// 点评数
	NSInteger intCmtCount;
	// 点评
	NSArray *arrCmtList;
	// 去过
	BOOL been;
	// 优惠信息
	NSArray *arrCouponList;
	// 标签，分类
	NSString *tagList;
	// 离当前位置的距离
	NSString *distance; // 单位:米
	BOOL showDetails;
    BOOL showCoupon; // use for UI
    BOOL isCommodityShop;  // 标识是否为美食
    
    // 菜单（只有美食类商户才有）
    NSArray *commodityList;
    NSInteger intCommodityCount;
}

@property(nonatomic, assign) BOOL showDetails;
@property(nonatomic, assign) BOOL showCoupon;
@property(nonatomic, assign) BOOL isCommodityShop;
@property(nonatomic, assign) NSInteger intCityId;
@property(nonatomic, assign) CGFloat intScoreTotal;
@property(nonatomic, assign) CGFloat fltAverage;
@property(nonatomic, assign) NSInteger intCmtCount;
@property(nonatomic, assign) BOOL been;
@property(nonatomic, assign) CGFloat fltPositionX;
@property(nonatomic, assign) CGFloat fltPositionY;
@property(nonatomic, assign) NSInteger intStatus;
@property(nonatomic, assign) NSInteger intBeenCount;
@property(nonatomic, assign) NSInteger intPicCount;
@property(nonatomic, assign) NSInteger intCommodityCount;

@property(nonatomic, copy) NSString *shopId;
@property(nonatomic, copy) NSString *strName;
@property(nonatomic, copy) NSString *strRecommendName;
@property(nonatomic, copy) NSString *tagList;
@property(nonatomic, copy) NSString *strAddress;
@property(nonatomic, copy) NSString *distance;

@property(nonatomic, retain) NSDictionary *arrScore;
@property(nonatomic, retain) NSArray *arrCouponList;
@property(nonatomic, retain) NSArray *arrCmtList;
@property(nonatomic, retain) NSArray *arrTel;
@property(nonatomic, retain) NSArray *commodityList;
@property(nonatomic, retain) NSDictionary *arrRecommend;
@property(nonatomic, retain) NSDictionary *moreInfo;



- (void)setTestData;
- (NSString *)recommendString;
- (NSString *)firstTag;
- (BOOL)hasRecommend;

@end