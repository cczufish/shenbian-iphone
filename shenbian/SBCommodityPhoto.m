//
//  SBCommodityPhoto.m
//  shenbian
//
//  Created by xhan on 4/15/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBCommodityPhoto.h"
#import "Utility.h"
#import "CacheCenter.h"
#import "SDImageCache.h"

@implementation SBCommodityPhotoInfo

@synthesize totalPhotoCount, cid, cname, cvoteCount, isCVoted;
@synthesize sid, sname, svoteCount, sscore, saddress;

- (BOOL)isCommodity
{
    return [cid length] > 0;
}

- (void)dealloc{
	VSSafeRelease(cid);
	VSSafeRelease(cname);
	VSSafeRelease(sid);
	VSSafeRelease(sname);
	VSSafeRelease(saddress);
	[super dealloc];
}

- (BOOL)validSelfData
{
	return YES;
	//TODO: add validate method
}
@end



@implementation SBCommodityPhoto

@synthesize cid, cimgsize, comments, voteCount;
@synthesize createdAt,isVoted,votedUserList,user;
@synthesize imgBigBasePath,commentList;

- (void)dealloc {
	VSSafeRelease(cid);
	VSSafeRelease(comments);
	VSSafeRelease(createdAt);
	VSSafeRelease(votedUserList);
	VSSafeRelease(user);
	VSSafeRelease(commentList);
	[super dealloc];
}

- (NSString*)photoBigURLstr
{
    if (self.imgBigBasePath) {
        return [[self.imgBigBasePath stringByAppendingPathComponent:cid] stringByAppendingString:@".jpg"];
    }
    return [[IMG_BASE_URL stringByAppendingPathComponent:cid] stringByAppendingString:@".jpg"];
}

- (NSString*)photoURLstr
{
    return [[IMG_BASE_URL stringByAppendingPathComponent:cid] stringByAppendingString:@".jpg"];
    
}

- (NSString*)createdAtFormated
{
	return [Utility userFriendlyTimeFromUTC:[self.createdAt integerValue]];
}

@end


@implementation SBCommodityPhotoUser

@synthesize uid,uiconPath,uname;

- (void)dealloc{
	VSSafeRelease(uid);
	VSSafeRelease(uiconPath);
	VSSafeRelease(uname);
	[super dealloc];
}

- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix
{
	self = [super init];
	self.uid = [dict objectForKey:@"u_fcrid"];
    
    if ([[dict objectForKey:@"u_avatar"] length] > 0) {
        self.uiconPath = [NSString stringWithFormat:@"%@%@.jpg",prefix,
                          [dict objectForKey:@"u_avatar"]];
    }
	self.uname = [dict objectForKey:@"u_name"];	
	return self;
}


@end



@implementation SBCommodityPhotoComment

@synthesize commentID,userID,userName,userAvatarPath,contents,imgUserIcon,timestamp;

- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix
{
    self = [super init];
    self.commentID = VSDictV(dict, @"cmt_fcrid");
    self.userID    = VSDictV(dict, @"cmt_ufcrid");
    self.userName  = VSDictV(dict, @"cmt_uname");
    self.userAvatarPath = [NSString stringWithFormat:@"%@%@.jpg",prefix,
                           [dict objectForKey:@"cmt_uavatar"]];
    self.contents  = VSDictV(dict, @"cmt_content_show") ? 
						VSDictV(dict, @"cmt_content_show") : VSDictV(dict, @"cmt_content");
    self.timestamp = VSDictV(dict, @"cmt_time");
    return self;
}
- (void)dealloc
{
    CancelRequest(hcUserIcon);
    VSSafeRelease(imgUserIcon);
    
    VSSafeRelease(commentID);
    VSSafeRelease(userID);
    VSSafeRelease(userName);
    VSSafeRelease(userAvatarPath);
    VSSafeRelease(contents);
    VSSafeRelease(timestamp);
    [super dealloc];
}

- (void)loadImageResource
{
    if (!imgUserIcon && !isIconFetched) {
        UIImage *img = [[SDImageCache sharedImageCache] imageFromKey:self.userAvatarPath];
		if (img) {
			self.imgUserIcon = img;
		}else {
			if (!hcUserIcon) {
				hcUserIcon = [[HttpRequest alloc] init];
                hcUserIcon.delegate = self;
			}
			[hcUserIcon requestGET:self.userAvatarPath];			
		}
    }
}
- (void)cancelRequest
{
    CancelRequest(hcUserIcon);
}

- (void)requestSucceeded:(HttpRequest*)req 
{
    if (req.statusCode == 200) {
        UIImage* icon = [UIImage imageWithData:req.recievedData];

        self.imgUserIcon = icon;
        [[SDImageCache sharedImageCache] storeImage:icon imageData:UIImagePNGRepresentation(self.imgUserIcon) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
    }
    

    CancelRequest(hcUserIcon);
    isIconFetched = YES;
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error 
{
    CancelRequest(hcUserIcon);
    isIconFetched = YES;
}

@end


@implementation SBCommodityPhotoCommentList

@synthesize totalCount,comments,curPage,pn;

- (id)initWithDict:(NSDictionary*)dict imgPrefix:(NSString*)prefix
{
    self = [super init];
    imgPrefix = [prefix copy];
    totalCount = [VSDictV(dict, @"cmt_total") intValue];
    NSArray* commentsAry = VSDictV(dict, @"cmt_list");
    comments = [[NSMutableArray alloc] init];
    for (NSDictionary*dict in commentsAry) {
        id comment = [[SBCommodityPhotoComment alloc] initWithDict:dict imgPrefix:prefix];
        [comments addObject:comment];
        [comment release];
    }
    pn = MessageCountPerPage;
    return self;
}

- (void)addCommentsFrom:(NSDictionary*)dict
{
    NSArray* commentsAry = VSDictV(dict, @"cmt_list");
    for (NSDictionary*dict in commentsAry) {
        id comment = [[SBCommodityPhotoComment alloc] initWithDict:dict imgPrefix:imgPrefix];
        [comments addObject:comment];
        [comment release];
    }
}

- (void)dealloc
{
    VSSafeRelease(imgPrefix);
    VSSafeRelease(comments);
    [super dealloc];
}

- (BOOL)isHavingMore
{
    return comments.count < totalCount;
}

- (NSString*)lastTimeStamp
{
    return [(SBCommodityPhotoComment*)[comments lastObject] timestamp];
}
@end