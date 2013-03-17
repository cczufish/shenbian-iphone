//
//  SBCommodityPhoto.h
//  shenbian
//
//  Created by xhan on 4/15/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"
/*
 * 每个图片的基本信息
 */

@interface SBCommodityPhotoInfo : NSObject
{
	int totalPhotoCount;
	
	// commodity
	NSString* cid;
	NSString* cname;
	int	      cvoteCount;
	BOOL      isCVoted;
	//shop 
	NSString* sid;
	NSString* sname;
	int		  svoteCount;
	int		  sscore;
	NSString* saddress;
}

@property (nonatomic, readonly) BOOL isCommodity;

@property (nonatomic, assign) int totalPhotoCount;
@property (nonatomic, assign) BOOL isCVoted;
@property (nonatomic, copy) NSString* cid;
@property (nonatomic, copy) NSString* cname;
@property (nonatomic, assign) int	  cvoteCount;
@property (nonatomic, copy) NSString* sid;
@property (nonatomic, copy) NSString* sname;
@property (nonatomic, assign) int	  svoteCount;
@property (nonatomic, assign) int	  sscore;
@property (nonatomic, copy) NSString* saddress;

// return yes if data is valided
- (BOOL)validSelfData;

@end




@class SBCommodityPhotoUser;
@class SBCommodityPhotoCommentList;
@interface SBCommodityPhoto : NSObject {
    // 这里的cid就是 pid
	NSString* cid;
	CGSize cimgsize;
	NSString* comments;
	int voteCount;
	
	SBCommodityPhotoUser* user;
	NSArray* votedUserList;
	
	BOOL isVoted;
	NSString* createdAt; //1分钟前
    
    //comments
    SBCommodityPhotoCommentList* commentList;
}

@property (nonatomic, assign) int voteCount;
//photo owner's comment
@property (nonatomic, copy) NSString *comments;
@property (nonatomic, assign) CGSize cimgsize;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic, retain) SBCommodityPhotoUser* user;
@property (nonatomic, copy) NSArray* votedUserList;
@property (nonatomic, assign) BOOL isVoted;
@property (nonatomic, copy) NSString* createdAt;
@property (nonatomic, readonly) NSString* createdAtFormated;

//大图模式
@property (nonatomic, copy) NSString* imgBigBasePath;

@property (nonatomic, readonly) NSString* photoURLstr;
@property (nonatomic, readonly) NSString* photoBigURLstr;

//other comments
@property (nonatomic, retain) SBCommodityPhotoCommentList* commentList;

@end


@interface SBCommodityPhotoUser : NSObject
{
	/*
	u_name: "双子戒指1"
	u_fcrid: "87ad1015bfe088896d85ee87"
	u_avatar: "aae41bfbc58c65c29f514614"
	}
	*/
	NSString* uid;
	NSString* uiconPath;
	NSString* uname;	
}

@property (nonatomic, copy) NSString* uid;
@property (nonatomic, copy) NSString* uiconPath;
@property (nonatomic, copy) NSString* uname;	

- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix;
@end



@interface SBCommodityPhotoComment : NSObject<HttpRequestDelegate> {
@private

    
    //
    HttpRequest *hcUserIcon;
    BOOL isIconFetched;
}
@property(nonatomic,copy) NSString* commentID;
@property(nonatomic,copy) NSString* userID;
@property(nonatomic,copy) NSString* userAvatarPath;
@property(nonatomic,copy) NSString* userName;
@property(nonatomic,copy) NSString* contents;
@property(nonatomic,copy) NSString* timestamp;
/*
 dict   -{cmt_fcrid:string,cmt_ufcrid:string ....}
 */
- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix;

@property (nonatomic, retain) UIImage *imgUserIcon;
- (void)loadImageResource;
- (void)cancelRequest;

@end


@interface SBCommodityPhotoCommentList : NSObject {
@private
    int totalCount;
    /* SBCommodityPhotoComment objects */
    NSMutableArray* comments;
    int curPage;
    int pn;
    NSString* imgPrefix;
}
- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix;
- (void)addCommentsFrom:(NSDictionary*)dict;
//return last object's timestamp (used in LoadMore features)
- (NSString*)lastTimeStamp;

@property(nonatomic,assign) int totalCount;
@property(nonatomic,retain) NSMutableArray* comments;
@property(nonatomic,assign) int curPage;
@property(nonatomic,assign) int pn;
@property(nonatomic,readonly) BOOL isHavingMore;
@end
