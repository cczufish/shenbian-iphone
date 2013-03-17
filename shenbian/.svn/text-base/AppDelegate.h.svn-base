//
//  AppDelegate.h
//  shenbian
//
//  Created by MagicYang on 3/31/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AdvertisementController.h"


#define Stat(_format_, ...) [[AppDelegate sharedDelegate] recordAction:_format_, ##__VA_ARGS__]

BOOL hasAlertGPSEnabled;

@class VSTabBarController;
@class MainViewController;
@class SBAppVersionControl;
@class StatService;
@interface AppDelegate : NSObject <UIApplicationDelegate,UITabBarControllerDelegate> {
    UIWindow *_window;
    VSTabBarController *_tabBarController;
    UINavigationController *discoveryNavCtl, *mainNavCtl, *homeNavCtl, *moreNavCtl;
    BOOL isSearchFirstTab;
    SBAppVersionControl* versionControl;
	AdvertisementController *adController;
    StatService *statService;
    
    BOOL isAppRunning;
}

@property (nonatomic, retain) UIWindow *window;

+ (AppDelegate*)sharedDelegate;

// Stat interface for all user actions
- (void)recordAction:(NSString *)format, ...;

//switch Discovery tab and show LatestTab
- (void)showLatestTab;
- (void)layoutControllersHighlightDiscover;
- (void)layoutControllersHighlightSearch;

@end


