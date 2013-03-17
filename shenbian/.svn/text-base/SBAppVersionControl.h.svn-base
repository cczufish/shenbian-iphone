//
//  SBAppVersionControl.h
//  shenbian
//
//  Created by xu xhan on 5/28/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"


@protocol SBAppVersionControlDelegate;

@interface SBAppVersionControl : NSObject
{
    NSString* currentVersion;
    HttpRequest* hcVersionCheck;
    id<SBAppVersionControlDelegate> delegate;
}

@property(readonly) NSString* currentVersion;
@property(assign)   id delegate;

- (void)freezeApp:(NSString*)message;

- (void)checkForUpdateAtLocalfile;
- (void)checkForUpdateOnline;

///// private
- (NSComparisonResult)_versionComapreFrom:(NSString*)v1 to:(NSString*)v2;
- (NSString*)_localUpdateInfoPath;
- (NSString*)_latestVersionFromDict:(NSDictionary*)dict;
- (NSString*)_detailsFromDict:(NSDictionary*)dict;
- (BOOL)_isExpiredFromDict:(NSDictionary*)dict;
@end


@protocol SBAppVersionControlDelegate <NSObject>
@required
// isLocal => 区分是本地调用 or http请求
- (void)appVersionControl:(SBAppVersionControl*)control newVersionFound:(NSString*)version details:(NSString*)message isExpired:(BOOL)isExpired isLocal:(BOOL)isLocal;
@end