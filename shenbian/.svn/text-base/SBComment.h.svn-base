//
//  Comment.h
//  shenbian
//
//  Created by MagicYang on 10-11-25.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HttpRequest;

@interface SBComment : NSObject {
	// 点评ID
	NSString *cmtId;
	// 用户ID
	NSString *userId;
	// 用户姓名
	NSString *userName;
	// 用户头像URL
	NSString *userImgUrl;
	// 用户级别
	NSInteger uLevel;
	// 点评内容
	NSString *content;
	// 点评发布时间
	NSTimeInterval createdTime;
	// 点评分数 (同ShopInfo.intScoreTotal)
	NSInteger totalScore;
	// 各项分数(口味，服务，环境，上菜速度)
	NSDictionary *detailScore;
	// 表示该评论有用的用户数
	NSInteger usefulCount;
	// 人均消费
	CGFloat fltAverage;
	// 推荐菜（美食类商户only）
	NSString *recommend;
	// if YES - 内容被截断
	BOOL isContentTrunc;
	
	HttpRequest *imgRequest;
	UIImage *userImg;
}

@property(nonatomic, retain) NSString *cmtId;
@property(nonatomic, retain) NSString *userId;
@property(nonatomic, retain) NSString *userName;
@property(nonatomic, retain) NSString *userImgUrl;
@property(nonatomic, assign) NSInteger uLevel;
@property(nonatomic, retain) NSString *content;
@property(nonatomic, assign) NSTimeInterval createdTime;
@property(nonatomic, assign) NSInteger totalScore;
@property(nonatomic, retain) NSDictionary *detailScore;
@property(nonatomic, assign) NSInteger usefulCount;
@property(nonatomic, retain) UIImage *userImg;
@property(nonatomic, assign) CGFloat fltAverage;
@property(nonatomic, retain) NSString *recommend;
@property(nonatomic, assign) BOOL isContentTrunc;

- (SBComment *)initWithDictionary:(NSDictionary *)dict;
- (NSString *)contentForList;
- (NSString *)createdDate;
- (void)setTestData;

@end
