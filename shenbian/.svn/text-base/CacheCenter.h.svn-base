//
//  CacheCenter.h
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBObject.h"
#import "SBUser.h"


#define IMG_BASE_URL    [CacheCenter sharedInstance].imagePath
#define CurrentCity     [CacheCenter sharedInstance].currentCity
#define CurrentCityName CurrentCity.name
#define CurrentCityId	CurrentCity.id
#define CurrentAccount  [CacheCenter sharedInstance].account

// Use to cache data fetched from internet

@class Area;
@class SBShopInfo;
@class SBUser;
@interface CacheCenter : NSObject {
	NSUserDefaults *cfg;
	
	NSString *username;
    NSString *apnsToken;
    NSString *imagePath;                // 全局图片URL目录
	Area *currentCity;					// 当前城市
	Area *localCity;					// 用户所在的城市
	NSMutableArray *whatSearchHistory;	// 区域搜索记录
	NSMutableArray *whereSearchHistory;	// 分类搜索记录
	NSMutableArray *shopBrowseHistory;	// 商户浏览记录
	NSArray *hotCityList;
    SBUser *account;
    BOOL promptNotCurrentCity;
}

@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *apnsToken;
@property(nonatomic, copy) NSString *imagePath;
@property(nonatomic, retain) SBUser *account;
@property(nonatomic, retain) Area *currentCity;
@property(nonatomic, retain) Area *localCity;
@property(nonatomic, retain) NSMutableArray *whatSearchHistory;
@property(nonatomic, retain) NSMutableArray *whereSearchHistory;
@property(nonatomic, retain) NSMutableArray *shopBrowseHistory;
@property(nonatomic, assign) BOOL promptNotCurrentCity;


+ (CacheCenter *)sharedInstance;
- (void)restore;

// 登录用户是否已注册APNs
- (BOOL)isRegisterToken;
- (void)recordRegisterToken:(BOOL)flag;
// 第一次使用
- (BOOL)isFirstUsed;
- (void)recordFirstUsed;
//第一次统计（不直接用|isFirstUsed|的原因:
// 1.是由于此处需要网络检查，避免无网络时漏统计
// 2.|isFirstUsed|置1的时候可能还没有发网络请求
- (BOOL)isFirstStat;
- (void)recordFirstStat;

// 最近一次统计日期(字符串形式)
- (void)recordLastStatDate:(NSString *)date;
- (NSString *)lastStatDate;
// 当前是否是热门城市
- (BOOL)isHotCityCurrent;
- (NSArray *)hotCityList;
// 用户名密码
- (void)recordUsername:(NSString *)user;
// APNs token
- (void)recordApnsToken:(NSString *)token;
// BDUSS
- (void)recordBDUSS:(NSString *)bduss;
// 关键字搜索记录（what, where）
- (void)recordWhatSearch:(NSString *)keyword;
- (void)recordWhereSearch:(NSString *)keyword;
// 最近一次拍照的商户
- (void)recordPhotoShop:(SBShopInfo *)shop;
- (SBShopInfo *)lastPhotoShop;
// 最近浏览商户
- (void)recordBrowsedShop:(SBShopInfo *)shop;
- (void)cleanBrowseHistory;

- (void)clearAreaSearchHistory;
- (void)clearChannelSearchHistory;

@end
