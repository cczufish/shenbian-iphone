//
//  SBApiEngine.h
//  shenbian
//
//  Created by xhan on 4/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString* const SBApiEngineError;

@class SBCommodityPhotoInfo, SBCommodityPhoto;

@interface SBApiEngine : NSObject {

}

/* return an array of SBCommodityPhoto objects ,info returns an autorelease object too*/
+ (NSArray*)parseImageDetailInfo:(NSData*)data to:(SBCommodityPhotoInfo**)info error: (NSError**)error; 

+ (NSArray*)parseMorePhotos:(NSDictionary*)dict;

+ (NSDictionary*)parseHttpData:(NSData*)data error:(NSError**)error;
+ (NSDictionary*)parseHttpData:(NSData*)data error:(NSError**)error ifSystemRequest:(BOOL)isr;
+ (NSDictionary*)headersFromCookieByBDUSS:(NSString*)bduss;

+ (NSString*)localDescriptionOfErrorCode:(int)error;

//+ (BOOL)isUserAuthFailedByErrorCode:(int)error;
+ (BOOL)isUserNotActived:(int)error;

//+ (void)onUserAuthFailed:(int)error;

+ (void)setupBDUSScookies:(NSString*)abudss;
+ (void)deleteBDUSSCookie;
+ (NSString *)getBDUSSCookie;

+ (BOOL)isEmailAddress:(NSString *)email;
+ (NSString *)iconvString:(NSString *)string from:(NSStringEncoding)inEncoding to:(NSStringEncoding)outEncoding;

@end
