//
//  ShopInfo.m
//  shenbian
//
//  Created by MagicYang on 10-11-22.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBShopInfo.h"
#import "SBComment.h"


@implementation SBShopInfo

@synthesize showDetails;
@synthesize showCoupon;
@synthesize isCommodityShop;
@synthesize shopId;
@synthesize intCityId;
@synthesize intScoreTotal;
@synthesize fltAverage;
@synthesize intCmtCount;
@synthesize been;
@synthesize fltPositionX;
@synthesize fltPositionY;
@synthesize intStatus;
@synthesize distance;
@synthesize intBeenCount;
@synthesize intCommodityCount;

@synthesize moreInfo;
@synthesize strName;
@synthesize arrScore;
@synthesize arrCouponList;
@synthesize arrCmtList;
@synthesize arrTel;
@synthesize strAddress;
@synthesize strRecommendName;
@synthesize arrRecommend;
@synthesize tagList;
@synthesize commodityList;
@synthesize intPicCount;

- (id)init
{
    self = [super init];
    if (self) {
        self.showCoupon = YES;
    }
    return self;
}

- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[SBShopInfo class]]) {
		return [((SBShopInfo *)object).shopId isEqualToString:self.shopId];
	}
	return NO;
}

- (void)dealloc {
	[shopId release];
	[strName release];
	[arrScore release];
	[arrCouponList release];
	[arrCmtList release];
	[arrTel release];
	[strAddress release];
	[strRecommendName release];
	[arrRecommend release];
	[tagList release];
	[commodityList release];
    [distance release];
    
	[super dealloc];
}

- (NSString *)recommendString {
	NSMutableString *recommend = [NSMutableString string];
	for (NSString *recmd in arrRecommend) {
		if ([recmd length] == 0) {	// Fix空串Bug
			continue;
		}
		
		[recommend appendFormat:@"%@ | ", recmd];
	}
	
	if ([recommend length] == 0) {	// Fix空串Bug
		return nil;
	}
	
	return [recommend substringToIndex:[recommend length] - 2];
}

- (NSString *)firstTag {
	NSArray *tags = [tagList componentsSeparatedByString:@" "];
	if ([tags count] > 0) {
		return [tags objectAtIndex:0];
	}
	return nil;
}

- (BOOL)hasRecommend {
	BOOL hasContent = NO;
	for (NSString *str in self.arrRecommend) {
		if ([str length] > 0) {
			hasContent = YES;
			break;
		}
	}
	
	return [self.strRecommendName length] > 0 && hasContent;
}

// 填充测试数据
- (void)setTestData {
	self.strName = @"三佰瑞冻酸奶店(什刹海店)";
	self.intScoreTotal = 4;
	self.arrScore = [NSDictionary dictionaryWithObjectsAndKeys:
					 [NSNumber numberWithFloat:3.5], @"口味",
					 [NSNumber numberWithFloat:4.5], @"服务",
					 [NSNumber numberWithFloat:2.0], @"上菜速度", nil];
	self.intCmtCount = 10;
	self.intPicCount = 3;
	self.fltAverage = 10.0;
	self.strRecommendName = @"推荐菜";
	self.arrRecommend = [NSArray arrayWithObjects:@"碳香红豆补丁奶茶",
						 @"黄金百香果", @"芦荟皇家丝袜奶茶", @"抹茶牛奶烧",
						 @"金香芒果", @"提拉米苏", @"玉米牛奶", nil];
	self.arrCouponList = [NSArray arrayWithObjects:
						  [NSDictionary dictionaryWithObjectsAndKeys:@"[体验活动]开业酬宾，买一百送一百", @"strTopic", nil],
						  [NSDictionary dictionaryWithObjectsAndKeys:@"[体验活动]开业酬宾，买一百送一百", @"strTopic", nil],
						  [NSDictionary dictionaryWithObjectsAndKeys:@"[体验活动]开业酬宾，买一百送一百", @"strTopic", nil], nil];
	
	self.arrTel = [NSArray arrayWithObjects:@"010-51901730", @"010-51901730", nil];
	self.strAddress = @"海淀区中关村大街15号中关村广场购物中心B2楼";

	SBComment *cmt = [SBComment new];
	cmt.userName = @"蓝色季节";
	cmt.content = @"刚玩这边的店环境都很好，夏天晚上的时候出来散步逛街吹风是再好不过了，也没有什么喧哗的人群，圣酷石的东西奶味超重，不过要就华夫饼干...";
	cmt.totalScore = 4.0;
	self.arrCmtList = [NSArray arrayWithObjects:cmt, nil];
	[cmt release];
}

@end
