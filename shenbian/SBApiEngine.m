//
//  SBApiEngine.m
//  shenbian
//
//  Created by xhan on 4/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBApiEngine.h"
#import "SBCommodityPhoto.h"
#import "JSON.h"
#import "LoginController.h"
#import <VSMCore/NSString+Addition.h>
#import "ErrorCenter.h"

NSString* const SBApiEngineError = @"SBApiEngineError";

@implementation SBApiEngine


+ (NSArray*)parseMorePhotos:(NSDictionary*)dict
{
    //setup photos
	/*
	 cp_fcrid: "951b344d56f97db2d52afc42"
	 cp_xlen: "200"
	 cp_ylen: "150"
	 c_detail: "菜多味道一般"
	 cp_vote: "32"
	 u_name: "双子戒指"
	 u_fcrid: "87ad1015bfe088896d85ee87"
	 u_avatar: "c6ed55ed27b35d982e2e21e6"
	 cu_vote_list: [
	 -{
	 u_name: "双子戒指1"
	 u_fcrid: "87ad1015bfe088896d85ee87"
	 u_avatar: "aae41bfbc58c65c29f514614"
	 }
	 ]
	 is_voted: "0"
	 length_time: "1分钟前"
	 */
    
    NSString* imagePrefix = [dict objectForKey:@"pic_path"];
    NSArray* photos = [dict objectForKey:@"picture"];
	NSMutableArray* returnPhotos = [NSMutableArray arrayWithCapacity:photos.count];
	for (NSDictionary* photoDict in photos) {
		
		SBCommodityPhoto* photo = [[SBCommodityPhoto alloc] init];
		
		photo.cid = [photoDict objectForKey:@"cp_fcrid"];
		photo.cimgsize = CGSizeMake([[photoDict objectForKey:@"cp_xlen"] intValue],
									[[photoDict objectForKey:@"cp_ylen"] intValue]);
		photo.comments = [photoDict objectForKey:@"c_detail"];
		photo.voteCount = [[photoDict objectForKey:@"cp_vote"] intValue];
		photo.isVoted = [[photoDict objectForKey:@"is_voted"] boolValue];
		photo.createdAt = [photoDict objectForKey:@"length_time"];
		photo.imgBigBasePath = imagePrefix;
        
		SBCommodityPhotoUser* user = [[SBCommodityPhotoUser alloc] initWithDict:photoDict imgPrefix:imagePrefix];
		photo.user = user;
		[user release];
		
		NSArray* originVotedUsers = [photoDict objectForKey:@"cu_vote_list"];
		NSMutableArray* votedUsers = [NSMutableArray arrayWithCapacity:originVotedUsers.count];
		for (NSDictionary* d in originVotedUsers) {
			SBCommodityPhotoUser* votedUser = [[SBCommodityPhotoUser alloc] initWithDict:d imgPrefix:imagePrefix];
			[votedUsers addObject:votedUser];
			[votedUser release];
		}
		
		photo.votedUserList = votedUsers;
		
        //comments
        SBCommodityPhotoCommentList* commentList = [[SBCommodityPhotoCommentList alloc] initWithDict:photoDict imgPrefix:imagePrefix];
        photo.commentList = commentList;
        [commentList release];
        
		[returnPhotos addObject:photo];
		[photo release];		
	}
	return returnPhotos;
}


+ (NSArray*)parseImageDetailInfo:(NSData*)data to:(SBCommodityPhotoInfo**)info error: (NSError**)error
{
	if(!info){
		[NSException raise:@"arguments error" format:@"pointer->info should not be empty"];
	}
	
	
    NSDictionary* dict = [self parseHttpData:data error:error];
    if (*error) {
        return nil;
    }
	/*
	 pic_total: "138"
	 -commodity: {
	 c_fcrid: "aaaaaaaaaa"
	 c_name: "蔬菜拼盘"
	 c_vote: "34"
	 }
	 -shop: {
	 s_fcrid: "ebc7ea72e0dd30d3e03b825f"
	 s_name: "海底捞牡丹园店"
	 s_vote: "134"
	 s_score: "4.5"
	 s_addr: "海淀区花园东路2号"
	 }
	 */
	//setup info
	
	*info = [[[SBCommodityPhotoInfo alloc] init] autorelease];
	(*info).totalPhotoCount = [[dict objectForKey:@"pic_total"] intValue];
	
	NSDictionary* commodityInfo = [dict objectForKey:@"commodity"];
    if ([commodityInfo isKindOfClass:NSDictionary.class]) {
        (*info).cid = [commodityInfo objectForKey:@"c_fcrid"];
        (*info).cname = [commodityInfo objectForKey:@"c_name"];
        (*info).cvoteCount = [[commodityInfo objectForKey:@"c_vote"] intValue];
        (*info).isCVoted = [[commodityInfo objectForKey:@"is_voted"] intValue];
    }
	
	NSDictionary* shopInfo = [dict objectForKey:@"shop"];
    if ([shopInfo isKindOfClass:NSDictionary.class]) {
        (*info).sid = [shopInfo objectForKey:@"s_fcrid"];
        (*info).sname = [shopInfo objectForKey:@"s_name"];
        (*info).svoteCount = [[shopInfo objectForKey:@"s_vote"] intValue];
        (*info).sscore = [[shopInfo objectForKey:@"s_score"] intValue];
        (*info).saddress = [shopInfo objectForKey:@"s_addr"];
    }
    
    return [self parseMorePhotos:dict];	
}

+ (NSDictionary*)parseHttpData:(NSData*)data error:(NSError**)error ifSystemRequest:(BOOL)isr
{

    // parse JSON value
	NSString* str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"%@", str);
	NSDictionary* dict = [str JSONValue];
	[str release];
	
	// data validation
	BOOL isContainsError = NO;
    int errorNo = 0;
	if (dict && [dict isKindOfClass:NSDictionary.class]) {
		errorNo = [[dict objectForKey:@"errno"] intValue];
		if (errorNo != 0) {
			isContainsError = YES;
		}        
	} else {
		isContainsError = YES;
	}	
    if (isr) {
            [ErrorCenter showErrorInfo:errorNo];
    }

	if (error && isContainsError) {
        NSString* errorMSG = [self localDescriptionOfErrorCode:errorNo];
        
		*error = [NSError errorWithDomain:SBApiEngineError code:errorNo userInfo:VSDictOK(errorMSG,NSLocalizedDescriptionKey)];		
	}
    return dict;

}
+ (NSDictionary*)parseHttpData:(NSData*)data error:(NSError**)error
{
  return   [self parseHttpData:data error:error ifSystemRequest:YES];

}


+ (NSDictionary*)headersFromCookieByBDUSS:(NSString*)bduss
{
    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:
                            VSDictOK(@".baidu.com",NSHTTPCookieDomain,
                                     @"/",NSHTTPCookiePath,
                                     bduss,NSHTTPCookieValue,
                                     @"BDUSS",NSHTTPCookieName)];
    return [NSHTTPCookie requestHeaderFieldsWithCookies:VSArray(cookie)];
}

#pragma mark -
static NSArray* _gSBError_descriptions;

+ (void)initialize
{
	_gSBError_descriptions = [VSArray(
                       NSLocalizedString(@"提交成功",@"api")   , //0
                       NSLocalizedString(@"系统错误",@"api")	  , // 21001
                       NSLocalizedString(@"定位失败",@"api")  ,   // 21002
                       NSLocalizedString(@"用户未登录百度",@"api") , // 21003
                       NSLocalizedString(@"用户已登录但未激活",@"api"), //21004
                       NSLocalizedString(@"用户昵称输入有误",@"api") , //21005
                       NSLocalizedString(@"用户未完成新浪微博同步设置",@"api") ,//21006
                       NSLocalizedString(@"参数有误",@"api"),  //21007
                       NSLocalizedString(@"当前用户不存在",@"api")) retain]; //21008

}

+ (NSString*)localDescriptionOfErrorCode:(int)error
{
    NSString* errorMsg;
    if (error != 0 ) {
        error = error - 21000;
    }
    if (error <0 || error >= [_gSBError_descriptions count]) {
        errorMsg = NSLocalizedString(@"未知错误",@"api");
    }else{
        errorMsg = [_gSBError_descriptions objectAtIndex:error];
    }
    return errorMsg;
    
}

//+ (BOOL)isUserAuthFailedByErrorCode:(int)error
//{
//    return (error == 21003 || error == 21008);
//}

+ (BOOL)isUserNotActived:(int)error
{
    return (error == 21004);
}

//+ (void)onUserAuthFailed:(int)error
//{
//    LoginController *lc = [LoginController sharedInstance];
//    [lc destroySession];
//    [lc showLoginView];
//}


+ (void)setupBDUSScookies:(NSString*)abudss
{
    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:
                            VSDictOK(ROOT_URL, NSHTTPCookieOriginURL,
                                     @"BDUSS", NSHTTPCookieName, 
                                     abudss,   NSHTTPCookieValue,
                                     @"/",     NSHTTPCookiePath
                                     )];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] 
     setCookie:cookie];
}

+ (void)deleteBDUSSCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] deleteCookie:cookie];
    }
}

+ (NSString *)getBDUSSCookie
{
    NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if ([[cookie name] isEqualToString:@"BDUSS"]) {
            return [cookie value];
        }
    }
    return nil;
}

+ (BOOL) isEmailAddress:(NSString*)email {
    NSString *emailRegex = @"^\\w+((\\-\\w+)|(\\.\\w+))*@[A-Za-z0-9]+((\\.|\\-)[A-Za-z0-9]+)*.[A-Za-z0-9]+$"; 
	
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	
    return [emailTest evaluateWithObject:email];
}

+ (NSString *)iconvString:(NSString *)string from:(NSStringEncoding)inEncoding to:(NSStringEncoding)outEncoding {
	NSData *data = [string dataUsingEncoding:inEncoding allowLossyConversion:YES];
	NSString *output = [[NSString alloc] initWithData:data 
										  encoding:outEncoding];
	return [output autorelease];
}

@end
