//
//  LocationService.h
//  shenbian
//
//  Created by MagicYang on 10-12-23.
//  Copyright 2010 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "SBLocation.h"


// Baidu Location
typedef struct{
	double x;
	double y;
} BaiduLocation;


@class HttpRequest;

@interface LocationService : NSObject<CLLocationManagerDelegate, UIAlertViewDelegate> {
	CLLocationManager *locationManager;
	BOOL _isLocating; // 标识是否正在定位
    BOOL hasAbandonOnce; // 标识是否已丢弃第一次定位的数据
    
    SBLocation *_location;
    HttpRequest *request;
}
@property(nonatomic, readonly) BOOL isLocating;

+ (LocationService *)sharedInstance;

- (void)startLocation;
- (void)stopLocation;
- (SBLocation *)currentLocation;
- (NSInteger)currentCityId;
- (void)getBaiduLocationLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id)del;

@end