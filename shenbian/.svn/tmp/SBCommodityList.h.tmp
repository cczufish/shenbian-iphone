//
//  SBCommodityList.h
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"

////////////////////////////////////////////////////////////////
@class SBCommodity;
@interface SBCommodityList : NSObject {
	int _totalCount;
	// page split
	int _currentPageIndex;
	int _eachPageItemCount;
	NSMutableArray* _arrayList;
        
    //used in tableView
    int contentOffsetY;
}

- (void)addObject:(id)obj;
- (SBCommodity*)objectAtIndex:(NSUInteger)index;
- (NSUInteger)count;
+ (id)list;

- (SBCommodity*)lastCommodity;

// reset all contents to empty
- (void)resetData;

@property(nonatomic,assign) int countTotal;
@property(nonatomic,assign) BOOL hasMore;
@property(nonatomic,readonly) NSMutableArray* array;
@property(nonatomic,assign) int currentPage;
@property(nonatomic,assign) int contentOffsetY;

@end


////////////////////////////////////////////////////////////////
@interface SBCommodity : NSObject<HttpRequestDelegate>
{
	NSString* imagePrefix;
	NSDictionary* _dict;
	UIImage* imgUserIcon;
	UIImage* imgCover;
	
	HttpRequest *userImgRequest;
	HttpRequest *bcImgRequest;
    
    BOOL isIconFetched;
    BOOL isImgFetched;
    
    //ivars
    
}

- (id)initWithDict:(NSDictionary*)dict;
- (id)initWithDict:(NSDictionary*)dict imagePrefix:(NSString*)str;

//uiconPath should be full http stand path
- (id)initWithAlbumItem:(NSDictionary*)dict uname:(NSString*)uname uiconPath:(NSString*)iconPath uicon:(UIImage*)icon imagePrefix:(NSString*)str uid:(NSString*)uid;

- (void)loadImageResource;
- (void)cancelRequest;
- (id)initWithFeedItem:(NSDictionary*)dict uname:(NSString*)uname_ uiconPath:(NSString*)iconPath uicon:(UIImage*)icon imagePrefix:(NSString*)str uid:(NSString*)uid_;

// image storage 
@property (nonatomic, retain) UIImage *imgUserIcon;
@property (nonatomic, retain) UIImage *imgCover;

//commodity properties
@property(nonatomic,copy) NSString* pid;  // picture id
@property(nonatomic,copy) NSString* cid;
@property(nonatomic,readonly) NSString* ccoverURLstr;
@property(nonatomic,readonly) NSString* cname;
@property(nonatomic,readonly) NSString* cvote;
@property(nonatomic,readonly) NSString* ccmt; // 评论数
@property(nonatomic,readonly) NSInteger ccount;
@property(nonatomic,readonly) int cvote_i;
@property(nonatomic,readonly) NSString* cdetail;
@property(nonatomic,readonly) CGSize    cimageSize;
@property(nonatomic,readonly) NSString* like;	//喜欢数


//shop properties
@property(nonatomic,copy) NSString* sid;
@property(nonatomic,readonly) NSString* sname;

//user properties
@property(nonatomic,readonly) NSString* uid;
@property(nonatomic,copy) NSString* uname;
@property(nonatomic,readonly) NSString* uiconPath;
@property(nonatomic,readonly) BOOL isVIP;

//other
@property(nonatomic,readonly) NSString* distance;

@property(nonatomic,readonly) NSString* createdAt;

@end

