//
//  SBCommodityList.m
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBCommodityList.h"
#import "SDImageCache.h"
#import "Utility.h"
////////////////////////////////////////////////////////////////

@implementation SBCommodityList

@synthesize countTotal = _totalCount, array = _arrayList, currentPage = _currentPageIndex, contentOffsetY;
@synthesize hasMore;

- (id)init{
	self = [super init];
	_arrayList = [[NSMutableArray alloc] init];
	_currentPageIndex = 0;
	_totalCount = 0;
	return self;
}

- (void)dealloc{
	VSSafeRelease(_arrayList);
	[super dealloc];
}

- (void)resetData
{
    [_arrayList removeAllObjects];
	_currentPageIndex = 0;
	_totalCount = 0;
    contentOffsetY = 0;
}

- (void)addObject:(id)obj{
	[_arrayList addObject:obj];
}
- (SBCommodity*)objectAtIndex:(NSUInteger)index{
	return [_arrayList objectAtIndex:index];
}
- (NSUInteger)count{
	return [_arrayList count];
}
+ (id)list{
	return [[[self alloc] init] autorelease];
}

- (SBCommodity*)lastCommodity
{
    return [_arrayList lastObject];
}

@end


////////////////////////////////////////////////////////////////
@implementation SBCommodity

@synthesize imgUserIcon,imgCover;
@synthesize pid, cid, ccoverURLstr, cname, cvote, ccmt, ccount, cvote_i, cdetail, cimageSize, sid, sname, uid, uname, uiconPath, isVIP, distance, createdAt, like;

- (id)initWithDict:(NSDictionary*)dict
{
	self = [super init];
    
	return self;
}

- (id)initWithDict:(NSDictionary*)dict imagePrefix:(NSString*)str
{
	self = [self init];
    imagePrefix = [str copy];
    _dict = dict;
    cid = [[_dict objectForKey:@"c_fcrid"] copy];    	
    ccoverURLstr = [[NSString stringWithFormat:@"%@%@.jpg", imagePrefix, [_dict objectForKey:@"c_cover"]] copy];
    cname = [[_dict objectForKey:@"c_name"] copy];
    cvote = [[_dict objectForKey:@"c_vote"] copy];
    ccmt = [[dict objectForKey:@"cmt_total"] copy];
    
    cdetail = [[_dict objectForKey:@"c_detail"] copy];
    cimageSize = CGSizeMake([[_dict objectForKey:@"p_xlen"] intValue], [[_dict objectForKey:@"p_ylen"] intValue]);
    ccount = [[_dict objectForKey:@"c_count"] intValue];
    
    sid = [[_dict objectForKey:@"s_fcrid"] copy];
    sname = [[_dict objectForKey:@"s_name"] copy];
    
    uid = [[_dict objectForKey:@"u_fcrid"] copy];
    uname = [[_dict objectForKey:@"u_name"] copy];
    
    // Old API, it will be removed when 
//    if ([[_dict objectForKey:@"u_avatar"] length] > 0) {
//        uiconPath = [[NSString stringWithFormat:@"%@%@.jpg", imagePrefix, [_dict objectForKey:@"u_avatar"]] copy];
//    }
    // New API, add in 2.0.2 update
    uiconPath = [[_dict objectForKey:@"u_head"] copy];
    
    isVIP = [[_dict objectForKey:@"u_vip"] boolValue];
	
//    distance = [[_dict objectForKey:@"distance"] copy];
    distance = [[_dict objectForKey:@"distance_show"] copy];
    
    createdAt = [[_dict objectForKey:@"length_time"] copy];
    
    pid = [[_dict objectForKey:@"c_cover"] copy];
	
	//	喜欢数
	like = [[_dict objectForKey:@"p_vote"] copy];
	
/*
	like = @"3";	//	test code
//*/
	
    _dict = nil;
	return self;
}

- (id)initWithAlbumItem:(NSDictionary*)dict uname:(NSString*)uname_ uiconPath:(NSString*)iconPath uicon:(UIImage*)icon imagePrefix:(NSString*)str uid:(NSString*)uid_
{
    self = [super init];
    if (self) {
        id pid_ = VSDictV(dict, @"p_fcrid");
        id cname_ = VSDictV(dict, @"p_name");        
        id sname_ = VSDictV(dict, @"s_name");
        id comments_ = VSDictV(dict, @"p_detail");
        id cmtcount = VSDictV(dict, @"cmt_total");
        id pxlen = VSDictV(dict, @"p_xlen");
        id pylen = VSDictV(dict, @"p_ylen");
        id time  = VSDictV(dict, @"p_time");
        id _like = VSDictV(dict, @"p_vote");
		
        imagePrefix = [str copy];
        self.pid = pid_;
        
        ccoverURLstr = [[NSString stringWithFormat:@"%@%@.jpg", imagePrefix, pid] copy];
        cname = [cname_ copy];
        sname = [sname_ copy];
        cdetail = [comments_ copy];
        cimageSize = CGSizeMake([pxlen intValue], [pylen intValue]);
        ccmt = [cmtcount copy];
        createdAt = [time copy];
        like = [_like copy];
		
        uid = [uid_ copy];
        uname = [uname_ copy];
        uiconPath = [iconPath copy];
        self.imgUserIcon = icon;
        
    }

    return self;
}

- (id)initWithFeedItem:(NSDictionary*)dict uname:(NSString*)uname_ uiconPath:(NSString*)iconPath uicon:(UIImage*)icon imagePrefix:(NSString*)str uid:(NSString*)uid_
{
    self = [super init];
    if (self) {
        like = [[dict objectForKey:@"p_vote"] copy];    //喜欢数
        pid=[[dict objectForKey:@"p_fcrid"] copy];      //菜 加密图片id
        cname = [[dict objectForKey:@"c_name"] copy];   //菜名
        sname=[[dict objectForKey:@"s_name"] copy]; 
        cdetail=[[dict objectForKey:@"c_detail"] copy];   //传图时的说明文字
        createdAt=[[dict objectForKey:@"p_time"] copy]; //传图的时间
        cvote=[[dict objectForKey:@"c_vote"] copy]; 
        imagePrefix=[str copy ];
        ccoverURLstr = [[NSString stringWithFormat:@"%@%@.jpg", imagePrefix, pid] copy];
        uname = [[dict objectForKey:@"u_name"] copy];
        uiconPath=[[dict objectForKey:@"u_head"] copy]; 
        uid=[[dict objectForKey:@"u_fcrid"] copy]; 
        like=[[dict objectForKey:@"p_vote"] copy]; 
        ccmt=[[dict objectForKey:@"cmt_total"] copy];     
        cimageSize = CGSizeMake([[dict objectForKey:@"p_xlen"] intValue], [[dict objectForKey:@"p_ylen"] intValue]);
    }
    
    return self;
}
- (void)dealloc{
    VSSafeRelease(pid);
    VSSafeRelease(cid);
    VSSafeRelease(ccoverURLstr);
    VSSafeRelease(cname);
    VSSafeRelease(cvote);
    VSSafeRelease(ccmt);
    VSSafeRelease(cdetail);
    VSSafeRelease(sid);
    VSSafeRelease(sname)
    VSSafeRelease(uid);
    VSSafeRelease(uname);
    VSSafeRelease(uiconPath);
    VSSafeRelease(distance);
    VSSafeRelease(createdAt);
    
	VSSafeRelease(imagePrefix);
	VSSafeRelease(_dict);
	VSSafeRelease(imgCover);
	VSSafeRelease(imgUserIcon);
    
    CancelRequest(bcImgRequest);
    CancelRequest(userImgRequest);
	
	
	[super dealloc];
}



- (int)cvote_i{
    return [self.cvote intValue];
}



#pragma mark -
#pragma mark HttpRequest & Delegate

- (void)loadImageResource
{

	if (!imgUserIcon && !isIconFetched) {
		UIImage *img = [[SDImageCache sharedImageCache] imageFromKey:self.uiconPath];
		if (img) {
			self.imgUserIcon = img;
		}else {
			if (!userImgRequest) {
				userImgRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:NUM(1)];
			}
			[userImgRequest requestGET:self.uiconPath];			
		}

	}	
	
	if (!imgCover && !isImgFetched) {
		UIImage *img = [[SDImageCache sharedImageCache] imageFromKey:self.ccoverURLstr];
		if (img) {
			self.imgCover = img;
		}else {
			if (!bcImgRequest) {
				bcImgRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:[NSNumber numberWithInt:0]];
				[bcImgRequest requestGET:self.ccoverURLstr];
			}				
		}
	}
	

}
- (void)cancelRequest
{
	[bcImgRequest cancel];
	[userImgRequest cancel];
	VSSafeRelease(bcImgRequest);
	VSSafeRelease(userImgRequest);
}

- (void)requestSucceeded:(HttpRequest*)req {
	int type = [req.extraData intValue];
	if (type == 1) {
		if (req.statusCode == 200) {
			UIImage* icon = [UIImage imageWithData:req.recievedData];
            self.imgUserIcon = [Utility clipImage:icon toSize:CGSizeMake(72, 72)];
			[[SDImageCache sharedImageCache] storeImage:icon imageData:UIImagePNGRepresentation(self.imgUserIcon) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
		}
        
		[userImgRequest release];
		userImgRequest = nil;
        isIconFetched = YES;
	} else if (type == 0) {
		if (req.statusCode == 200) {
			self.imgCover = [UIImage imageWithData:req.recievedData];
			[[SDImageCache sharedImageCache] storeImage:imgCover imageData:UIImagePNGRepresentation(imgCover) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
		}
		[bcImgRequest release];
		bcImgRequest = nil;
        isImgFetched = YES;
	} else {
//		assert(@"No");
	}
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error 
{
	int type = [req.extraData intValue];
	if (type == 1) {
		[userImgRequest release];
		userImgRequest = nil;
        isIconFetched = YES;
	} else if (type == 0) {
		[bcImgRequest release];
		bcImgRequest = nil;
        isImgFetched = YES;
	}
}



@end

