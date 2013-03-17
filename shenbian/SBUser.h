//
//  SBUser.h
//  shenbian
//
//  Created by MagicYang on 5/13/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HttpRequest;
@interface SBUser : NSObject {
    NSString *uid;
    NSString *name;
    NSString *imgUrl;
    UIImage *img;
    NSUInteger level;
    NSUInteger photoCount, beenCount, badgeCount;
    NSInteger mammon;
    BOOL isWeiboBind;
    HttpRequest *request;
    //添加关注数，粉丝数字段 by dailu
    NSUInteger attentionCount;
    NSUInteger funsCount;
    
}

@property(nonatomic, retain) NSString *uid;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, retain) NSString *imgUrl;
@property(nonatomic, retain) UIImage *img;
@property(nonatomic, assign) NSUInteger level;
@property(nonatomic, assign) NSUInteger photoCount;
@property(nonatomic, assign) NSUInteger beenCount;
@property(nonatomic, assign) NSUInteger badgeCount;
@property(nonatomic, assign) NSInteger mammon;
@property(nonatomic, assign) BOOL isWeiboBind;
@property(nonatomic, assign) BOOL isVIP;
@property(nonatomic, assign) NSUInteger attentionCount;
@property(nonatomic, assign) NSUInteger funsCount;
- (void)cleanProfile;

+ (void)drawUserAvatarWithImage:(UIImage *)image atRect:(CGRect)rect  andIsVIP:(BOOL)isVIP;

@end
