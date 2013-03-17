//
//  DatasourceDiscovery.h
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"

@class SBCommodityList, SBCommodity;

/*
 * 在发现模块 以及 图片详情界面 中使用
 *  当返回 tabs >2 时 说明 
 "热门" <-  增加的, 包含 分类 t = 0
 "附近"					   t = 1
 "最新					   t = 2
 -----------------
 
 subt = 中文
 */
typedef enum {
    MainTab_Hot    = 0,
    MainTab_Nearby = 1,
    MainTab_Newest = 2
} MainTab;

@protocol DatasourceDiscoveryDelegate;

@interface DatasourceDiscovery : NSObject<HttpRequestDelegate> {
	SBCommodityList* currentList;
	NSMutableArray* lists;
	
	NSArray* tabs; // t分类
	NSArray* categories; // "热门"下的子分类
	
	MainTab currentMainTab;
	int currentSubTab;
    int currentCommodityIndex;  // Add by MagicYang
    
	NSString* picPathPrefix;
	
	NSMutableArray* delegates;
	
	HttpRequest* httpClientGlobal;
	HttpRequest* httpClientTab;
    
	int requestTab;
	int requestPage;
	int requestSubTab;
    
    //the must have property
    NSString* cityID;
    
    // Indicate there's more can be load (Get from Server)
    BOOL _hasMore;
}

@property (nonatomic, copy) NSArray *tabs;
@property (nonatomic, copy) NSArray *categories;
@property (nonatomic, copy) NSArray *lists;
@property (nonatomic, copy) NSString* cityID;
@property (nonatomic, readonly) SBCommodityList *currentList;
@property (nonatomic, assign) MainTab currentMainTab;
@property (nonatomic, assign) int currentSubTab;
@property int currentCommodityIndex;
@property (nonatomic, readonly) HttpRequest *httpClientGlobal;
@property (nonatomic, readonly) HttpRequest *httpClientTab;
@property (nonatomic, assign) BOOL hasMore;

////////////////////////////////////
/// modified to support more features

// http:// host.com/getFind?city_id=xxx
- (NSString*)getCommomURLprefix; //  This interface is replaced by 'discover' in v2.0.2, #Commentted by MagicYang#

- (SBCommodityList*)modelAtTab:(int)tab subTab:(int)subtab;

//http request
- (void)loadFirstData;

- (void)loadDataRefreshAtTab:(int)tab subTab:(int)subtab;

- (void)loadDataRefreshForCurrentList;

- (void)loadMoreForTabAt:(int)tab subTab:(int)subtab;

- (void)loadMoreForCurrentList;


- (BOOL)isLatestTab:(int)tab;

- (BOOL)isLatestTabForCurList;

- (SBCommodity *)currentCommodity;

// Added by MagicYang
// 当tab数为3时, "热门" = 0, "附近" = 1, "最新" = 2
// 当tab数为2时,            "附近" = 1, "最新" = 2
// 下面两个函数用于匹配discover接口的参数t与tab index
- (int)mappingIndexWithMainTab:(MainTab)tab;
- (MainTab)mappingMainTabWithIndex:(int)index;
// Added End

////////////////////////////////////


// method to parse init response
- (BOOL)parseHttpResponse:(NSData*)data;

// method to load more by another httpresponse
- (BOOL)parseMoreHttpResponse:(NSData*)data atTab:(int)tab atPage:(int)page;

- (void)resetData;

- (void)addDelegate:(id<DatasourceDiscoveryDelegate>)obj;
- (void)removeDelegate:(id<DatasourceDiscoveryDelegate>)obj;

- (void)setCurrentTabIndex:(int)index category:(int)category;

//private
- (void)_invokeDelegateSuccess:(BOOL)isInit;
- (void)_invokeDelegateFailed:(NSError*)reason;
@end

@protocol DatasourceDiscoveryDelegate <NSObject>

@required
- (void)datasource:(DatasourceDiscovery*)ds successLoaded:(BOOL)isInit;
@optional
- (void)datasource:(DatasourceDiscovery*)ds failedWithError:(NSError*)error;

@end

