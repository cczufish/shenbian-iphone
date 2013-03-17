//
//  HttpRequest+Statistic.m
//  shenbian
//
//  Created by MagicYang on 7/5/11.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "HttpRequest+Statistic.h"
#import "StatService.h"


static NSMutableDictionary *fixedParameter = nil;


@implementation HttpRequest (Statistic)

// 生产统计参数
- (NSDictionary *)statParameters
{
    NSMutableDictionary *statParam = [NSMutableDictionary dictionary];
    
    if (!fixedParameter) {
        fixedParameter = [[NSMutableDictionary alloc] init];
        [fixedParameter setObject:DeviceModel forKey:@"xda_m"];     // 手机型号，”Milestone”
        [fixedParameter setObject:DisplayModel forKey:@"xda_s"];     // 屏幕分辨率(格式320X480)
        [fixedParameter setObject:OSVersion forKey:@"xda_ov"];  // 操作系统版本,(2.3.3)
        [fixedParameter setObject:IMEI forKey:@"xda_did"];          // 手机imei
        [fixedParameter setObject:AppVersion forKey:@"xda_ver"]; // 客户端版本(1.0.3)
        [fixedParameter setObject:kChannel forKey:@"xda_c"];        // 推广渠道 ”如:2000a”
    }
    [statParam addEntriesFromDictionary:fixedParameter];
    [statParam setObject:FirstUsed forKey:@"xda_fa"];    // 第一次打开客户端 1 : 0
    [statParam setObject:UsedToday forKey:@"xda_fd"];    // 今天第一次打开客户端 1 : 0
    
    return statParam;
}


- (NSString *)addStatsToURL:(NSString *)url
{
    NSMutableString *statURL = [NSMutableString string];
    [statURL appendString:url];
    NSRange range = [url rangeOfString:@"?"];
    if (range.location == NSNotFound) { // URL无任何参数
        [statURL appendString:@"?"];
    } else {                            // URL已有参数
        [statURL appendString:@"&"];
    }
    
    NSDictionary *param = [self statParameters];
    int i = 0;
    for (NSString *key in [param allKeys])
    {
        if (i != 0) [statURL appendString:@"&"];
        NSString *value = [param objectForKey:key];
        [statURL appendFormat:@"%@=%@", key, value];
        i++;
    }
    
    return statURL;
}

- (NSDictionary *)addStatsToParameters:(NSDictionary *)param
{
    NSMutableDictionary *allParam = [NSMutableDictionary dictionary];
    [allParam addEntriesFromDictionary:param];
    [allParam addEntriesFromDictionary:[self statParameters]];
    return allParam;
}

- (void)requestGET:(NSString *)url useStat:(BOOL)flag
{
    [self requestGET:url useCache:NO useStat:flag];
}

- (void)requestGET:(NSString *)url useCache:(BOOL)isCache useStat:(BOOL)flag
{
    if (flag) {
        url = [self addStatsToURL:url];
    }
    [self requestGET:url useCache:isCache];
}

- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params useStat:(BOOL)flag
{
    if (flag) {
        params = [self addStatsToParameters:params];
    }
    [self requestPOST:url parameters:params];
}

@end
