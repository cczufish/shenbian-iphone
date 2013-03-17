//
//  Coupon.h
//  shenbian
//
//  Created by MagicYang on 10-12-21.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
	CouponType_YouHuiQuan = 1,
	CouponType_ZheKou     = 2,
	CouponType_HuoDong    = 3
} CouponType;

@interface SBCoupon : NSObject {
	// ID
	NSString *couponId;
	// 优惠类型
	NSString *type;
	// 标题
	NSString *topic;
	// 内容
	NSString *content;
	// 起始时间
	NSInteger startTime, endTime;
	// 适用商户 (ShopInfo数组, 只包含Id, 名字, 地址3个字段)
	NSArray *shopList;
	// 是否可以短信下载
	BOOL hasSMS;
    
    // Is now show detail infomation in UI
    BOOL showAll;
}

@property(nonatomic, retain) NSString *couponId;
@property(nonatomic, retain) NSString *type;
@property(nonatomic, retain) NSString *topic;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, assign) NSInteger startTime;
@property(nonatomic, assign) NSInteger endTime;
@property(nonatomic, retain) NSArray *shopList;
@property(nonatomic, assign) BOOL hasSMS;
@property(nonatomic, assign) BOOL showAll;

- (SBCoupon *)initWithDictionary:(NSDictionary *)dict;
+ (NSInteger)typeWithName:(NSString *)typeName;
- (NSString *)startTimeString;
- (NSString *)endTimeString;

@end


@interface CouponList : NSObject {
	// ID
	NSString *couponId;
	// 下载人数
	NSInteger downloadCount;
	// 感兴趣人数
	NSInteger interestingCount;
	// 优惠类别 (1 优惠券; 2 折扣; 3 活动)
	NSInteger type;
	// 标题
	NSString *topic;
	
	// 商户名
	NSString *shopName;
	// 商户总评分
	CGFloat shopScore;
	// 商户Tag
	NSString *shoptag;
}


@property(nonatomic, retain) NSString *couponId;
@property(nonatomic, assign) NSInteger downloadCount;
@property(nonatomic, assign) NSInteger interestingCount;
@property(nonatomic, assign) NSInteger type;
@property(nonatomic, retain) NSString *topic;
@property(nonatomic, retain) NSString *shopName;
@property(nonatomic, assign) CGFloat shopScore;
@property(nonatomic, retain) NSString *shopTag;

@end

