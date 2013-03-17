//
//  SBAppVersionControl.m
//  shenbian
//
//  Created by xu xhan on 5/28/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBAppVersionControl.h"
#import "Utility.h"
#import "AppDelegate.h"

@implementation SBAppVersionControl
@synthesize delegate;

- (void)dealloc{
    
    VSSafeRelease(currentVersion);
    CancelRequest(hcVersionCheck);
    [super dealloc];
}

- (NSString*)currentVersion
{
    
//    return @"1.9.1";
    
    if (!currentVersion) {
        currentVersion = [[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] copy]; 
    }
    return currentVersion;
}

- (void)checkForUpdateAtLocalfile
{
    NSData* data = [NSData dataWithContentsOfFile:[self _localUpdateInfoPath]];
    if (data) {
        NSDictionary* dict = [Utility parseData:data];
        if ([dict isKindOfClass:NSDictionary.class]) {
            NSString* latestVersion = [self _latestVersionFromDict:dict];
            if ([self _versionComapreFrom:latestVersion to:self.currentVersion] ==  NSOrderedDescending) {

                [delegate appVersionControl:self
                            newVersionFound:latestVersion
                                    details:[self _detailsFromDict:dict]
                                  isExpired:[self _isExpiredFromDict:dict]
                                    isLocal:YES];
            }
        }
    }
}


- (void)checkForUpdateOnline
{
    if (!hcVersionCheck) {
        hcVersionCheck = [[HttpRequest alloc] init];
        hcVersionCheck.delegate = self;
    }
    NSString* url = NSStringADD(ROOT_URL, @"/version");
    [hcVersionCheck requestGET:url];
}


- (void)freezeApp:(NSString*)message;
{
    UIWindow* win = [AppDelegate sharedDelegate].window;
    win.userInteractionEnabled = NO;
    
    UIView* v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    v.backgroundColor = [UIColor darkGrayColor];
    v.alpha = 0.7;
    [win addSubview:v];
    [v release];
     
    NSString* title = @"软件已过期";
    NSString* info = SETNIL(message, @"请下载最新版本继续体验");
    UIAlertView* alerView = [[UIAlertView alloc] initWithTitle:title
                                                       message:info
                                                      delegate:nil
                                             cancelButtonTitle:nil
                                             otherButtonTitles:nil];
    [alerView show];
    [alerView release];
}

#pragma mark - private

- (NSString*)_localUpdateInfoPath
{
    return NSStringADD(DOCUMENT_PATH, @"/updateinfo"); 
}

- (NSString*)_latestVersionFromDict:(NSDictionary*)dict
{
    return VSDictV(dict, @"version");
}

- (NSString*)_detailsFromDict:(NSDictionary*)dict
{
    return VSDictV(dict, @"detail");
}


- (NSComparisonResult)_versionComapreFrom:(NSString*)v1 to:(NSString*)v2
{
    NSMutableArray* anotherVer = [NSMutableArray arrayWithArray:[v2 componentsSeparatedByString:@"."]];
	NSMutableArray* selfVer = [NSMutableArray arrayWithArray:[v1 componentsSeparatedByString:@"."]];
	NSMutableArray* shortOne = [anotherVer count] > [selfVer count]?selfVer:anotherVer;
	for (int i = 0; i < abs([anotherVer count]-[selfVer count]); i++) {
		[shortOne addObject:@"0"];
	}
	for (int i = 0; i < [anotherVer count]; i++) {
		if ([[anotherVer objectAtIndex:i] isEqual:[selfVer objectAtIndex:i]]) {
			continue;
		}else {
			if ([[selfVer objectAtIndex:i] intValue] > [[anotherVer objectAtIndex:i] intValue]) {
				return NSOrderedDescending;
			}else {
				return NSOrderedAscending;
			}
		}
	}
	return NSOrderedSame;
}

- (BOOL)_isExpiredFromDict:(NSDictionary*)dict
{
    // two rules to check if app is expired     // just 1.
    // 1. version under (less than) minVersion
//    //2. version inside must need update version
    NSDictionary* info = VSDictV(dict, @"update");
    NSString* minVersion = VSDictV(info, @"miniVersion");
//    NSArray*  updateList = VSDictV(info, @"moreVersion");
    BOOL isExpired = NO;
    if (minVersion) {
        isExpired = ([self _versionComapreFrom:self.currentVersion to:minVersion] == NSOrderedAscending);
    }
//    if (updateList && !isExpired) {
//        for (NSString* version in updateList) {
//            if ([self _versionComapreFrom:self.currentVersion to:version] == NSOrderedSame) {
//                isExpired = YES;
//                break;
//            }
//        }
//    }
    return isExpired;
}

#pragma mark - http delegates

- (void)requestSucceeded:(HttpRequest *)request
{
    NSDictionary* dict = [Utility parseData:request.recievedData];
    if ([dict isKindOfClass:NSDictionary.class] && [self _latestVersionFromDict:dict]) {
        NSString* latestVersion = [self _latestVersionFromDict:dict];
        if ([self _versionComapreFrom:latestVersion to:self.currentVersion] ==  NSOrderedDescending) {
            //write to file
            [request.recievedData writeToFile:[self _localUpdateInfoPath] atomically:NO];
            //
            [delegate appVersionControl:self
                        newVersionFound:latestVersion
                                details:[self _detailsFromDict:dict]
                              isExpired:[self _isExpiredFromDict:dict]
                                isLocal:NO];
        }
    }
}

@end



