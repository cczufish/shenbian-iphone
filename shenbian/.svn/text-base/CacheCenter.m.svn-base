//
//  CacheCenter.m
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import "CacheCenter.h"
#import "AppDelegate.h"
#import "SBShopInfo.h"
#import "Notifications.h"
#import "SFHFKeychainUtils.h"
#import "SBApiEngine.h"

// NSUserDefaults键
#define kHasBeenFirstUsed     @"kHasBeenFirstUsed"
#define kHasBeenFirstStat     @"kHasBeenFirstStat"
#define kLastUsedDate         @"kLastUsedDate"
#define kPromptNotCurrentCity @"kPromptNotCurrentCity"
#define kUsername             @"kUsername"
#define kBDUSS                @"kBDUSS"
#define kCurrentCityId        @"kCurrentCityId"
#define kCurrentCityName      @"kCurrentCityName"
#define kAreaSearchHistory    @"kAreaSearchHistory"
#define kChannelSearchHistory @"kChannelSearchHistory"
#define kShopBrowseHistory    @"kShopBrowseHistory"
#define kPhotoShopId          @"kPhotoShopId"
#define kPhotoShopName        @"kPhotoShopName"
#define kPhotoShopType        @"kPhotoShopType"
#define KeyChainService       @"KeyChainService"
#define kAPNsToken            @"kAPNsToken"
#define kHasRegisterToken     @"kHasRegisterToken"


// Shop字段
#define ShopID      @"id"
#define ShopName    @"name"
#define ShopAddress @"address"
#define ShopScore   @"score"

#define MaxHistoryCount 30  // 最多保留的浏览记录数


static CacheCenter *instance = nil;

@interface CacheCenter(PrivateMethods)

- (void)saveShopBrowseHistory;
- (void)restoreShopBrowseHistory;

@end


@implementation CacheCenter

@synthesize account;
@synthesize imagePath, username, apnsToken;
@synthesize currentCity, localCity;
@synthesize whatSearchHistory, whereSearchHistory;
@synthesize shopBrowseHistory;
@synthesize promptNotCurrentCity;

- (void)restore {
	cfg = [NSUserDefaults standardUserDefaults];
    
	self.username = [cfg objectForKey:kUsername];
    self.apnsToken = [cfg objectForKey:kAPNsToken];
    [SBApiEngine setupBDUSScookies:[cfg objectForKey:kBDUSS]];
    
	if ([cfg objectForKey:kCurrentCityName]) {
		Area *city = [Area new];
		city.id   = [[cfg objectForKey:kCurrentCityId] intValue];
		city.name = [cfg objectForKey:kCurrentCityName]; 
		self.currentCity = city;
		[city release];
	}
    
	[whatSearchHistory addObjectsFromArray:[cfg arrayForKey:kAreaSearchHistory]];
	[whereSearchHistory addObjectsFromArray:[cfg arrayForKey:kChannelSearchHistory]];
	[self restoreShopBrowseHistory];
}

+ (id)allocWithZone:(NSZone *)zone {
	NSAssert(instance == nil, @"Duplicate alloc a singleton class");
	return [super allocWithZone:zone];
}

- (id)init {
	if ((self = [super init])) {
		whatSearchHistory = [NSMutableArray new];
		whereSearchHistory = [NSMutableArray new];
		shopBrowseHistory = [NSMutableArray new];
	}
	return self;
}

+ (CacheCenter *)sharedInstance {
	@synchronized([CacheCenter class]) {
		if (!instance) {
			instance = [[CacheCenter alloc] init];
		}
	}
	return instance;
}

- (void)dealloc {
    [account release];
	[username release];
    [apnsToken release];
	[currentCity release];
	[whatSearchHistory release];
	[whereSearchHistory release];
	[shopBrowseHistory release];
	[hotCityList release];
	[super dealloc];
}


- (BOOL)promptNotCurrentCity
{
    return [[cfg objectForKey:kPromptNotCurrentCity] boolValue];
}

- (void)setPromptNotCurrentCity:(BOOL)flag
{
    [cfg setObject:NUM(flag) forKey:kPromptNotCurrentCity];
	[cfg synchronize];
}

#pragma mark -
#pragma mark Public methods
- (BOOL)isFirstUsed
{
    return ![[cfg objectForKey:kHasBeenFirstUsed] boolValue];
}

- (void)recordFirstUsed
{
    [cfg setObject:NUM(1) forKey:kHasBeenFirstUsed];
	[cfg synchronize];
}

- (BOOL)isFirstStat
{
    return ![[cfg objectForKey:kHasBeenFirstStat] boolValue];
}

- (void)recordFirstStat
{
    [cfg setObject:NUM(1) forKey:kHasBeenFirstStat];
	[cfg synchronize];
}

- (BOOL)isRegisterToken
{
    return [[cfg objectForKey:kHasRegisterToken] boolValue];
}

- (void)recordRegisterToken:(BOOL)flag
{
    [cfg setObject:NUM(flag) forKey:kHasRegisterToken];
	[cfg synchronize];
}

- (void)recordLastStatDate:(NSString *)date
{
    [cfg setObject:date forKey:kLastUsedDate];
    [cfg synchronize];
}

- (NSString *)lastStatDate
{
    return [cfg objectForKey:kLastUsedDate];
}

- (NSArray *)hotCityList {
	if (!hotCityList) {
		NSString *path = [[NSBundle mainBundle] pathForResource:@"hotcity" ofType:@"plist"];
		NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
		NSMutableArray *list = [NSMutableArray array];
		for (NSString *name in [dict allKeys]) {
			Area *city = [Area new];
			city.id = [[dict objectForKey:name] intValue];
			city.name = name;
			[list addObject:city];
			[city release];
		}
		hotCityList = [list retain];
	}
	return hotCityList;
}

- (BOOL)isHotCityCurrent {
	return [[self hotCityList] containsObject:currentCity];
}

- (void)setCurrentCity:(Area *)city {
	if ([currentCity isEqual:city]) {
		return;
	}
	[currentCity release];
	currentCity = [city retain];
	
	[cfg setObject:NUM(currentCity.id) forKey:kCurrentCityId];
	[cfg setObject:currentCity.name forKey:kCurrentCityName];
	[cfg synchronize];
    
	[Notifier postNotificationName:kCityChanged object:nil];
}

- (void)recordUsername:(NSString *)user {
	self.username = user;
	[cfg setObject:username forKey:kUsername];
	[cfg synchronize];
}

- (void)recordApnsToken:(NSString *)token {
	self.apnsToken = token;
	[cfg setObject:apnsToken forKey:kAPNsToken];
	[cfg synchronize];
}

- (void)recordBDUSS:(NSString *)bduss
{
    if (bduss) {
        [SBApiEngine setupBDUSScookies:bduss];
        [cfg setObject:bduss forKey:kBDUSS];
        [cfg synchronize];
    } else {
        [SBApiEngine deleteBDUSSCookie];
        [cfg removeObjectForKey:kBDUSS];
    }
}

- (void)recordKeyword:(NSString *)keyword inContainer:(NSMutableArray *)container {
	for (NSString *kw in container) {
		if ([keyword isEqualToString:kw]) {
			[container removeObject:kw];
			break;
		}
	}
	
	if ([container count] >= MaxHistoryCount) {
		[container removeLastObject];
	}
	[container insertObject:keyword atIndex:0];
}

- (void)recordWhatSearch:(NSString *)keyword {
	[self recordKeyword:keyword inContainer:whatSearchHistory];
	[cfg setObject:whatSearchHistory forKey:kAreaSearchHistory];
	[cfg synchronize];
}

- (void)recordWhereSearch:(NSString *)keyword {
	[self recordKeyword:keyword inContainer:whereSearchHistory];
	[cfg setObject:whereSearchHistory forKey:kChannelSearchHistory];
	[cfg synchronize];
}

- (void)recordPhotoShop:(SBShopInfo *)shop
{
    [cfg setObject:shop.shopId forKey:kPhotoShopId];
    [cfg setObject:shop.strName forKey:kPhotoShopName];
    [cfg setObject:[NSNumber numberWithBool:shop.isCommodityShop] forKey:kPhotoShopType];
    [cfg synchronize];
}

- (SBShopInfo *)lastPhotoShop
{
    if ([cfg objectForKey:kPhotoShopId] && [cfg objectForKey:kPhotoShopName]) {
        SBShopInfo *shop = [SBShopInfo new];
        shop.shopId = [cfg objectForKey:kPhotoShopId];
        shop.strName = [cfg objectForKey:kPhotoShopName];
        shop.isCommodityShop = [[cfg objectForKey:kPhotoShopType] boolValue];
        return [shop autorelease];
    }
    return nil;
}

- (void)clearAreaSearchHistory {
	[whatSearchHistory removeAllObjects];
	[cfg setObject:whatSearchHistory forKey:kAreaSearchHistory];
	[cfg synchronize];
}

- (void)clearChannelSearchHistory {
	[whereSearchHistory removeAllObjects];
	[cfg setObject:whereSearchHistory forKey:kChannelSearchHistory];
	[cfg synchronize];
}

- (void)recordBrowsedShop:(SBShopInfo *)shop {
	for (SBShopInfo *shopInfo in shopBrowseHistory) {
		if ([shopInfo isEqual:shop]) {
			[shopBrowseHistory removeObject:shopInfo];
			break;
		}
	}
	
	if ([shopBrowseHistory count] >= MaxHistoryCount) {
		[shopBrowseHistory removeLastObject];
	}
	SBShopInfo *shopInfo = [SBShopInfo new];
	shopInfo.shopId = shop.shopId;
	shopInfo.strName = shop.strName;
	shopInfo.strAddress = shop.strAddress;
	shopInfo.intScoreTotal = shop.intScoreTotal;
	[shopBrowseHistory insertObject:shop atIndex:0];
	[shopInfo release];
	
	[self saveShopBrowseHistory];
}

- (void)cleanBrowseHistory {
	[shopBrowseHistory removeAllObjects];
	[self saveShopBrowseHistory];
}

- (void)saveShopBrowseHistory {
	NSMutableArray *historyList = [NSMutableArray array];
	for (SBShopInfo *shopInfo in shopBrowseHistory) {
		NSMutableDictionary *dict = [NSMutableDictionary dictionary];
		if (shopInfo.shopId) {
			[dict setObject:shopInfo.shopId forKey:ShopID];
		}
		if (shopInfo.strName) {
			[dict setObject:shopInfo.strName forKey:ShopName];
		}
		if (shopInfo.strAddress) {
			[dict setObject:shopInfo.strAddress forKey:ShopAddress];
		}
		[dict setObject:[NSNumber numberWithFloat:shopInfo.intScoreTotal] forKey:ShopScore];
		[historyList addObject:dict];
	}
	[cfg setObject:historyList forKey:kShopBrowseHistory];
}

- (void)restoreShopBrowseHistory {
	[shopBrowseHistory removeAllObjects];
	NSArray *historyList = [cfg objectForKey:kShopBrowseHistory];
	for (NSDictionary *dict in historyList) {
		SBShopInfo *shop = [SBShopInfo new];
		shop.shopId = [dict objectForKey:ShopID];
		shop.strName = [dict objectForKey:ShopName];
		shop.strAddress = [dict objectForKey:ShopAddress];
		shop.intScoreTotal = [[dict objectForKey:ShopScore] intValue];
		[shopBrowseHistory addObject:shop];
		[shop release];
	}
}


@end
