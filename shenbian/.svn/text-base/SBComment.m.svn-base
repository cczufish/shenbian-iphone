//
//  Comment.m
//  shenbian
//
//  Created by MagicYang on 10-11-25.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBComment.h"
#import "Utility.h"
#import "HttpRequest+Statistic.h"
#import "SDImageCache.h"
#import "CacheCenter.h"


@implementation SBComment

@synthesize cmtId;
@synthesize userId;
@synthesize userName;
@synthesize userImgUrl;
@synthesize uLevel;
@synthesize content;
@synthesize createdTime;
@synthesize totalScore;
@synthesize detailScore;
@synthesize usefulCount;
@synthesize userImg;
@synthesize fltAverage;
@synthesize recommend;
@synthesize isContentTrunc;

- (void)dealloc {
	CancelRequest(imgRequest);
	
	[cmtId release];
	[userId release];
	[userName release];
	[userImgUrl release];
	[content release];
	[detailScore release];
	[userImg release];
	[recommend release];
	[super dealloc];
}

- (SBComment *)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.cmtId = [dict objectForKey:@"cmt_fcrid"];
        self.userId = [dict objectForKey:@"cmt_ufcrid"];
        self.userName = [dict objectForKey:@"cmt_uname"];
        self.userImgUrl = [NSString stringWithFormat:@"%@/%@", IMG_BASE_URL, [dict objectForKey:@"cmt_uavatar"]];
        self.uLevel = [[dict objectForKey:@"cmt_ugrade"] intValue];
        self.createdTime = [[dict objectForKey:@"cmt_time"] intValue];
        self.totalScore = [[dict objectForKey:@"cmt_rate"] intValue] * 2;
        self.fltAverage = [[dict objectForKey:@"cmt_average"] floatValue];
        self.content = [dict objectForKey:@"cmt_content_show"] ?
		[dict objectForKey:@"cmt_content_show"] : [dict objectForKey:@"cmt_content"];
        self.recommend = [dict objectForKey:@"cmt_recommendation"];
        self.detailScore = [dict objectForKey:@"cmt_subrate"];
    }
    return self;
}

- (NSString *)contentForList {
	return nil;
}

- (NSString *)createdDate {
	NSDate *date = [NSDate dateWithTimeIntervalSince1970:createdTime];
	return [Utility stringWithDate:date];
}

- (void)setUserImgUrl:(NSString *)url {
	if ([userImgUrl isEqual:url]) {
		return;
	}
	[userImgUrl release];
	userImgUrl = [[url stringByAppendingString:@".jpg"] retain];
    
	UIImage *img = [[SDImageCache sharedImageCache] imageFromKey:userImgUrl];
	if (img) {
		self.userImg = img;
	} else {
		if (userImgUrl) {
			CancelRequest(imgRequest);
			imgRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
			[imgRequest requestGET:userImgUrl];
		}
	}
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
	if (req.statusCode == 200) {
		self.userImg = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:userImg imageData:UIImagePNGRepresentation(userImg) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
	}
	
	[imgRequest release];
	imgRequest = nil;
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	[imgRequest release];
	imgRequest = nil;
}


#pragma mark -
#pragma mark For test
// 填充测试数据
- (void)setTestData {
	self.userName = @"蓝色季节";
	self.uLevel = 4;
	self.totalScore = 4;
	self.createdTime = [[NSDate date] timeIntervalSince1970];
	self.fltAverage = 10;
	self.usefulCount = 26;
	self.content = @"终于去了长草已久的将太，下载了点评的券。没想到中午去吃也有那么多人，有钱人还真是多...点了三拼的寿司，叫薯愿，有CBD卷，飞跃CBD和秋天的童话，三拼88块，双拼77块 \
	终于去了长草已久的将太，下载了点评的券。没想到中午去吃也有那么多人，有钱人还真是多...点了三拼的寿司，叫薯愿，有CBD卷，飞跃CBD和秋天的童话，三拼88块，双拼77块";
	self.recommend = @"推荐: 小牛柳, 黄桃布丁";
	self.detailScore = [NSDictionary dictionaryWithObjectsAndKeys:
						[NSNumber numberWithFloat:3.0], @"口味",
						[NSNumber numberWithFloat:4.5], @"上菜速度",
						[NSNumber numberWithFloat:5.0], @"服务", nil];
}

@end
