//
//  StatService.h
//  shenbian
//
//  Created by MagicYang on 7/29/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 渠道号
 0001a --- s.baidu.com
 0001b --- waps.baidu.com
 0002b --- mo.baidu.com
 0003b --- 天空wap站
 0003a --- 天空
 1001a --- 91
 1002a --- 威锋网
 1003a --- 同步推
 1111a --- app store
 7000a --- shouji.baidu.com
 0009a --- 新浪微盘
 1009a --- 泡椒
 1382a --- 腾讯
 */
#define kChannel @"1111a"
#define DeviceModel [StatService deviceModel]
#define DisplayModel [StatService displayModel]
#define OSVersion [StatService systemVersion]
#define AppVersion [StatService appVersion]
#define IMEI [StatService imei]
#define FirstUsed [StatService isFirstUsed]
#define UsedToday [StatService isUsedToday]

@class UserActionStat;
@class HttpRequest;
@interface StatService : NSObject {
    UserActionStat *stat;
    HttpRequest *request;
}

// Information for some 

// 设备型号
+ (NSString *)deviceModel;
// 屏幕尺寸
+ (NSString *)displayModel;
// 操作系统版本
+ (NSString *)systemVersion;
// 当前版本
+ (NSString *)appVersion;
// IMEI码
+ (NSString *)imei;
 // App被第一次使用
+ (NSString *)isFirstUsed;
 // App当天被第一次使用
+ (NSString *)isUsedToday;

// Session stat functions
- (void)sendStatToServer;
- (void)writeStatToDisk;
- (void)recordAction:(NSString *)action atTime:(NSTimeInterval)time;

@end


@interface UserActionStat : NSObject {
    NSString *xda_d;  // IMEI
    NSString *xda_v;  // Client version
    NSString *xda_s;  // Screen display 320x480 ? 680x960
    NSString *xda_m;  // Device model
    NSString *xda_c;  // Channel
    NSString *xda_ov; // OS version
    NSString *xda_fd; // First use app today
    NSString *xda_fa; // First use app
    NSString *u_fcry; // Login User fcrid
    NSString *x, *y;  // x, y when user use it
    NSMutableArray *_actions; // NSArray contains dictionary with keys:c_act, act_time
}
@property(nonatomic, copy) NSString *xda_d;
@property(nonatomic, copy) NSString *xda_v;
@property(nonatomic, copy) NSString *xda_s;
@property(nonatomic, copy) NSString *xda_m;
@property(nonatomic, copy) NSString *xda_c;
@property(nonatomic, copy) NSString *xda_ov;
@property(nonatomic, copy) NSString *xda_fd;
@property(nonatomic, copy) NSString *xda_fa;
@property(nonatomic, copy) NSString *u_fcry;
@property(nonatomic, copy) NSString *x, *y;
@property(nonatomic, readonly) NSArray *actions;

- (BOOL)addAction:(NSString *)action atTime:(NSTimeInterval)time;

@end
