//
//  StatService.m
//  shenbian
//
//  Created by MagicYang on 7/29/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "StatService.h"
#import "JSON.h"
#import "UIDevice+Hardware.h"
#import "Utility.h"
#import "CacheCenter.h"
#import "Notifications.h"
#import "LocationService.h"
#import "HttpRequest.h"


#define MaxSessionCount 5000

static NSString *NormalDisplay = @"320x480";
static NSString *RetinaDisplay = @"640x960";
static NSString *LOGFILE       = @"session.log";
static NSString *LOGDIRECTORY  = @"log";
static NSString *BOOL_1        = @"1";
static NSString *BOOL_0        = @"0";
static NSString *VersionPath   = @"CFBundleShortVersionString";


@implementation StatService

/////////////////////////////////////////////////////////////////////////////////
+ (NSString *)deviceModel
{
    return [UIDevice platform];
}

+ (NSString *)displayModel
{
    return [[UIDevice platform] isEqualToString:iPhone4] ? RetinaDisplay : NormalDisplay;
}

+ (NSString *)systemVersion
{
    return [[UIDevice currentDevice] systemVersion];
}

+ (NSString *)appVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:VersionPath];
}

+ (NSString *)imei
{
    return [[UIDevice currentDevice] uniqueIdentifier];
}

+ (NSString *)isFirstUsed
{
    NSString *isFirstUsed;
    CacheCenter *cc = [CacheCenter sharedInstance];
    if ([cc isFirstStat]) {
        isFirstUsed = BOOL_1;
        [cc recordFirstStat];
    } else {
        isFirstUsed = BOOL_0;
    }
    return isFirstUsed;
}

+ (NSString *)isUsedToday
{
    NSString *isUsedToday;
    CacheCenter *cc = [CacheCenter sharedInstance];
    NSString *lastDate = [cc lastStatDate];
    NSString *today    = [Utility stringWithDate:[NSDate date]];
    if ([lastDate isEqualToString:today]) {
        isUsedToday = BOOL_0;
    } else {
        isUsedToday = BOOL_1;
        [cc recordLastStatDate:today];
    }
    return isUsedToday;
}

//////////////////////////////////////////////////////////////////////////////////////////

- (NSString *)logPath
{
    return [Utility filePathWithName:LOGFILE andDirectory:LOGDIRECTORY];
}

- (id)init
{
    self = [super init];
    if (self) {
        stat = [UserActionStat new];
        stat.xda_d = IMEI;
        stat.xda_v = AppVersion;
        stat.xda_s = DisplayModel;
        stat.xda_m = DeviceModel;
        stat.xda_c = kChannel;
        stat.xda_ov = OSVersion;
        stat.xda_fa = FirstUsed;
        stat.xda_fd = UsedToday;
        stat.u_fcry = @"";
        stat.x = @"0";
        stat.y = @"0";
        [Notifier addObserver:self selector:@selector(gotUserID) name:kLoginSucceeded object:nil];
        [Notifier addObserver:self selector:@selector(getLocationSuccessed:) name:kLocationSuccessed object:nil];
    }
    return self;
}

- (void)dealloc
{
    CancelRequest(request);
    [Notifier removeObserver:self name:kLoginSucceeded object:nil];
    [Notifier removeObserver:self name:kLocationSuccessed object:nil];
    [stat release];
    [super dealloc];
}

- (void)gotUserID
{
    stat.u_fcry = CurrentAccount.uid;
}

- (void)getLocationSuccessed:(NSNotification *)notification 
{
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    stat.x = location.x;
    stat.y = location.y;
}

- (NSString *)readStatFromDisk
{
    // TODO: 读取前做文件大小检查，防止hack
    if ([[NSFileManager defaultManager] fileExistsAtPath:[self logPath]]) {
        return [NSString stringWithContentsOfFile:[self logPath] encoding:NSUTF8StringEncoding error:NULL];
    } else {
        return nil;
    }
}

- (void)sendStatToServer
{
    // TODO: 开线程处理以下工作
    NSString *log = [self readStatFromDisk];
    log = [log stringByReplacingOccurrencesOfString:@"&" withString:@"%26"];
    if (log) {
        request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
        NSString *url = [NSString stringWithFormat:@"%@/stat", ROOT_URL];
        [request requestPOST:url body:[NSString stringWithFormat:@"log=%@", log]];
        [[NSFileManager defaultManager] removeItemAtPath:[self logPath] error:NULL];
    }
}

// 固定属性
- (NSArray *)fixedKeys
{
    return [NSArray arrayWithObjects:@"xda_d", @"xda_v", @"xda_s", @"xda_m", @"xda_c", @"xda_ov", @"xda_fd",@"xda_fa", @"u_fcry", @"x", @"y", nil];
}

- (void)writeStatToDisk
{
    SBJsonStreamWriter *writer = [SBJsonStreamWriter new];
    writer.humanReadable = NO;
    NSMutableDictionary *dict = [NSMutableDictionary new];
    for (NSString *key in [self fixedKeys]) {
        id value = [stat valueForKey:key];
        if (key != nil && value != nil) {
            [dict setObject:value forKey:key];
        }
    }
    
    if (stat.actions != nil) {
        [dict setObject:stat.actions forKey:@"actions"];
    }
    
    [writer writeObject:dict];
    [dict release];
    
    NSData *data = [writer dataToHere];
    [writer release];
    
    [data writeToFile:[self logPath] atomically:NO];
    
    // TODO:Remove below codes
    NSString *str = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"str = %@", str);
    [str release];
}

- (void)recordAction:(NSString *)act atTime:(NSTimeInterval)time
{    
    if (![stat addAction:act atTime:time]) {
        // TODO: do not write to disk, and remove all actions from memery
    }
}


#pragma mark-
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest *)req
{
    Release(request);
}

- (void)requestFailed:(HttpRequest *)req error:(NSError *)error
{
    Release(request);
}

@end


@implementation UserActionStat
@synthesize xda_d, xda_v, xda_s, xda_m, xda_c, xda_ov, xda_fd, xda_fa, u_fcry, x, y;

@synthesize actions = _actions;

- (id)init
{
    self = [super init];
    if (self) {
        _actions = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [xda_d release];
    [xda_v release];
    [xda_s release];
    [xda_m release];
    [xda_c release];
    [xda_ov release];
    [xda_fd release];
    [xda_fa release];
    [u_fcry release];
    [x release]; [y release];
    [_actions release];
    [super dealloc];
}

- (BOOL)addAction:(NSString *)action atTime:(NSTimeInterval)time
{
    if ([_actions count] > MaxSessionCount) {
        return NO;
    } else {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              action, @"c_act", 
                              [NSNumber numberWithInt:(int)time], @"act_time", nil];
        [_actions addObject:dict];
        return YES;
    }
}

@end