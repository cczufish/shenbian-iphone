//
//  Coupon.m
//  shenbian
//
//  Created by MagicYang on 10-12-21.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBCoupon.h"
#import "Utility.h"


@implementation SBCoupon

@synthesize couponId;
@synthesize type;
@synthesize topic;
@synthesize content;
@synthesize startTime;
@synthesize endTime;
@synthesize shopList;
@synthesize hasSMS;
@synthesize showAll;


- (void)dealloc {
	[couponId release];
	[topic release];
    [type release];
	[content release];
	[shopList release];
	[super dealloc];
}

- (SBCoupon *)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.couponId  = [dict objectForKey:@"fcrid"];
        self.topic     = [dict objectForKey:@"title"];
        self.content   = [dict objectForKey:@"context"];
        self.startTime = [[dict objectForKey:@"begintime"] intValue];
        self.endTime   = [[dict objectForKey:@"endtime"] intValue];
        self.hasSMS    = [[dict objectForKey:@"s_tel"] boolValue];
    }
    return self;
}

+ (NSInteger)typeWithName:(NSString *)typeName {
	if ([typeName isEqualToString:@"优惠券"]) {
		return 1;
	} else if ([typeName isEqualToString:@"折扣信息"]) {
		return 2;
	} else if ([typeName isEqualToString:@"活动"]) {
		return 3;
	} else {
		return 0; // Nothing
	}
}

- (NSString *)startTimeString {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTime];
	return [Utility stringWithDate:date];
}

- (NSString *)endTimeString {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:endTime];
	return [Utility stringWithDate:date];
}

@end


@implementation CouponList

@synthesize couponId;
@synthesize downloadCount;
@synthesize interestingCount;
@synthesize type;
@synthesize topic;
@synthesize shopName;
@synthesize shopScore;
@synthesize shopTag;

- (void)dealloc {
	[couponId release];
	[topic release];
	[shopName release];
	[shopTag release];
	[super dealloc];
}

@end