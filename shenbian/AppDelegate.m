//
//  AppDelegate.m
//  shenbian
//
//  Created by MagicYang on 3/31/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "DiscoveryViewController.h"
#import "HomeViewController.h"
#import "MoreViewController.h"

#import "PhotoController.h"
#import "LoginController.h"
#import "VSTabBarController.h"
#import "VSTabBarController+Swip.h"

#import "SBTabBar.h"
#import "SBGuideView.h"

#import "SDImageCache.h"
#import "LocationService.h"
#import "CacheCenter.h"
#import "AlertCenter.h"

#import "SBVersionUpdateController.h"
#import "StatService.h"
#import "Notifications.h"


#import "CommodityPhotoDetailVC.h"
#import "SBCommodityList.h"

@implementation AppDelegate


@synthesize window=_window;

+ (AppDelegate*)sharedDelegate
{
    return (AppDelegate*)[UIApplication sharedApplication].delegate;
}

- (void)recordAction:(NSString *)format, ...
{
    va_list args;
    va_start(args, format);
    NSString *action = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    [statService recordAction:action atTime:[[NSDate date] timeIntervalSince1970]];
//	DLog(@"%@", action);
    [action release];
}

- (void)showLatestTab
{
    _tabBarController.selectedIndex = 0;
    DiscoveryViewController* discoveryVC =  [[discoveryNavCtl viewControllers] objectAtIndex:0];
    [discoveryVC selectLatestTab];
}

#define APN_TYPE_UPDATE          9999
#define APN_TYPE_PIC_CMT         1031
#define APN_TYPE_PIC_CMT_REPLY   1032
- (void)processRemoteNotificationWithInfo:(NSDictionary *)userInfo
{
    NSDictionary *dict = [userInfo objectForKey:@"ext"];
    NSInteger type = [[dict objectForKey:@"type"] intValue];
    switch (type) {
        case APN_TYPE_UPDATE:
        {
            NSURL *appStore = [NSURL URLWithString:kAppStoreURL];
            [[UIApplication sharedApplication] openURL:appStore];
        } break;
        case APN_TYPE_PIC_CMT:
        case APN_TYPE_PIC_CMT_REPLY:
        {
            _tabBarController.selectedIndex = [[_tabBarController viewControllers] indexOfObject:discoveryNavCtl];
            SBCommodity *commodity = [SBCommodity new];
            commodity.pid = [dict objectForKey:@"p_fcrid"];//@"74b69d18ca058e4542a9adc2";
            CommodityPhotoDetailVC *controller = [[CommodityPhotoDetailVC alloc] initWithCommdity:commodity displayType:CommodityPhotoDetailTypeCommodityOnly];
            controller.from = CommodityPhotoSourceFromNotification;
            [discoveryNavCtl pushViewController:controller animated:NO];
            [commodity release];
            [controller release];
        } break;
    }
}

#pragma mark -Handle takePicture buttons

- (void)onBtnTakePhoto:(id)sender
{
    Stat(@"photobutton_click");
    Stat(@"find_bottom?tab=拍照");
    [[PhotoController singleton] clean];
	[[PhotoController singleton] showActionSheet];
}

#pragma mark - tabbar controller delegates && LoginController delegate
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    BOOL result = YES;
    if (viewController == homeNavCtl) {
        LoginController* loginC = [LoginController sharedInstance];
        if (![loginC isLogin]) {
            loginC.delegate = self;
            loginC.loginSuccessSEL = @selector(onLoginFromHomeTabSuccess:);
            [loginC showLoginView];
            result = NO;
        }
    } else if (viewController == discoveryNavCtl) {
        Stat(@"find_bottom?tab=发现");
    } else if (viewController == mainNavCtl) {
        Stat(@"find_bottom?tab=搜索");
    } else if (viewController == moreNavCtl) {
        Stat(@"find_bottom?tab=更多");
    }
    return result;
}

- (void)onLoginFromHomeTabSuccess:(LoginController*)loginC
{
    loginC.delegate = nil;
    _tabBarController.selectedIndex = 2;
}

#pragma mark -others

- (void)loadAllControllers
{
    if (!discoveryNavCtl) {
		DiscoveryViewController *discovery = [DiscoveryViewController new];
		discovery.title = @"百度身边";
		discoveryNavCtl = [[VSNavigationController alloc] initWithRootViewController:discovery];
		[discovery release];
	}
    
	if (!mainNavCtl) {
		MainViewController *main = [MainViewController new];
		main.title = @"搜索";
		mainNavCtl = [[VSNavigationController alloc] initWithRootViewController:main];
		[main release];
	}

	if (!homeNavCtl) {
		HomeViewController *home = [[HomeViewController alloc] initWithUserID:nil];
		home.title = @"我";
        home.isMainAccount = YES;
		homeNavCtl = [[VSNavigationController alloc] initWithRootViewController:home];
		[home release];
	}
    
	if (!moreNavCtl) {
		MoreViewController *more = [MoreViewController new];
		more.title = @"更多";
		moreNavCtl = [[VSNavigationController alloc] initWithRootViewController:more];
		[more release];
	}
    
    SBTabBar* tabbar = [SBTabBar new];
    [tabbar cameraBtnAddTarget:self action:@selector(onBtnTakePhoto:)];
    [_tabBarController setupTabBar:tabbar
                   viewControllers:VSArray(discoveryNavCtl, mainNavCtl, homeNavCtl, moreNavCtl)];
    _tabBarController.tabBarHeight = 44;
    _tabBarController.selectedIndex = 0;
    [tabbar release];
}

// Discover放首位 (变态)
- (void)layoutControllersHighlightDiscover
{
    if (isSearchFirstTab) {
        [_tabBarController exchangeControllersBetween:0 : 1];
        isSearchFirstTab = NO;
        _tabBarController.selectedIndex = 0;
    }
}

// Search放首位 (变态)
- (void)layoutControllersHighlightSearch
{
    if (!isSearchFirstTab) {
        [_tabBarController exchangeControllersBetween:0 : 1];
        isSearchFirstTab = YES;
        _tabBarController.selectedIndex = 0;
    }
}

- (void)setupApplicationBackground
{
    UIImageView *bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 480)];
    bg.image = PNGImage(@"bg");
    [_window addSubview:bg];
    [bg release];
}

- (void)setupTabbarController
{
    _tabBarController = [[VSTabBarController alloc] init];
	_tabBarController.delegate = self;
    [self loadAllControllers];
	[PhotoController singleton].rootVC = _tabBarController;
    [_window addSubview:_tabBarController.view];
}

- (void)cityChanged
{
    if ([[CacheCenter sharedInstance] isHotCityCurrent]) {
		[self layoutControllersHighlightDiscover];
	} else {
		[self layoutControllersHighlightSearch];
	}
}


#pragma mark-
#pragma mark UIApplicationDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // init global vars
    hasAlertGPSEnabled = NO;
    
    // Notifications
    // 当前城市变化 ——> 更新tabbar
    [Notifier addObserver:self selector:@selector(cityChanged) name:kCityChanged object:nil];
    // 获取到token ——> 发送token到shenbian's server
    [Notifier addObserver:self selector:@selector(registerNotification) name:kLoginSucceeded object:nil];
    
    // 初始化UI
    _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [_window makeKeyAndVisible];
    [self setupApplicationBackground];  // 全局背景图
    [self setupTabbarController];       // Tabbar和它的Controller们
    
    // 读取配置
    [[CacheCenter sharedInstance] restore];
    
    // 自动登录
    [[LoginController sharedInstance] autoLogin];
    
    // 注册PushNotification
    if ([[CacheCenter sharedInstance].apnsToken length] == 0) {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
    // 新手引导(仅用于第一次显示)
    if ([[CacheCenter sharedInstance] isFirstUsed]) {
        [SBGuideView showGuide];
        [[CacheCenter sharedInstance] recordFirstUsed];
    }

	UIViewController *homeVC = [[[_tabBarController viewControllers] objectAtIndex:0] topViewController];
	adController = [[AdvertisementController alloc] initWithFrame:vsr(0, 330, 320, 40)
                                                      andDelegate:homeVC     
                                                      andDuration:10.0f
                                                           andUrl:nil];
	[adController performSelector:@selector(loadAdvertisement) withObject:nil afterDelay:3.0f];
    
    
    if (launchOptions) {
        NSDictionary *userInfo = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        if (userInfo) {
            // 直接调用processRemoteNotificationWithInfo:方法tabbar隐藏不掉,原因和push的原理有关
            [self performSelector:@selector(processRemoteNotificationWithInfo:) withObject:userInfo afterDelay:0.01];
        }
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    isAppRunning = NO;
    
    [[HttpRequestCacheCenter sharedInstance] distoryCacheData]; // 销毁缓存数据
    
#ifdef DEBUG
    [[SDImageCache sharedImageCache] clearDisk]; // DEBUG模式不缓存图片
#endif
    
    Stat(@"close");
    [statService writeStatToDisk];
    [statService release];
    
    // 清零Badge
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    isAppRunning = YES;
    
    // Statistics
    statService = [StatService new];
    [statService sendStatToServer];
    // TODO: Init stat object here, not in StatService init
    Stat(@"open");
    
	// TODO: 检查新版本
	[[SBVersionUpdateController sharedInstance] checkUpdateForVersion:AppVersion 
														   andChannel:kChannel 
														  andDelegate:self];
}

- (void)versionWillUpdate:(NSString *)url {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
}

- (void)versionUpdateDidFinished {
	//	切换当前所在城市放在版本更新检查完成之后进行
    [CacheCenter sharedInstance].promptNotCurrentCity = YES;
    [[LocationService sharedInstance] startLocation];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    
}

- (void)dealloc
{	
    [_window release];
    [_tabBarController release];    
    [discoveryNavCtl release];
    [mainNavCtl release];
    [homeNavCtl release];
    [moreNavCtl release];
	[adController release];
	[statService release];
    [super dealloc];
}



#pragma mark-
#pragma mark Remote Notification Delegate
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // 应用在运行时不处理消息
    if (isAppRunning) return;
    
    [self processRemoteNotificationWithInfo:userInfo];
}

- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)devToken 
{
    NSString *tokenString = [[NSString alloc] initWithFormat:@"%@", devToken];
    // 去掉token中的括号和空格
    NSString *token = [tokenString stringByReplacingOccurrencesOfString:@"<" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@">" withString:@""];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    [[CacheCenter sharedInstance] recordApnsToken:token];
    [tokenString release];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    DLog(@"token error = %@", error);
}

- (void)registerNotification
{
    NSString *token = [CacheCenter sharedInstance].apnsToken;
    if ([token length] > 0) {
        if (![[CacheCenter sharedInstance] isRegisterToken]) {
            NSString *url = [NSString stringWithFormat:@"%@/openimsg", ROOT_URL];
            HttpRequest *request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
            [request requestPOST:url parameters:[NSDictionary dictionaryWithObject:token forKey:@"token"]]; 
        }
    }
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest *)request
{
    [[CacheCenter sharedInstance] recordRegisterToken:YES];
    [request release];
}

- (void)requestFailed:(HttpRequest *)request error:(NSError *)error
{
    [[CacheCenter sharedInstance] recordRegisterToken:NO];
    [request release];
}

@end
