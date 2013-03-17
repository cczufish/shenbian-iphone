//
//  LocationService.m
//  shenbian
//
//  Created by MagicYang on 10-12-23.
//  Copyright 2010 百度. All rights reserved.
//

#import "LocationService.h"
#import "Notifications.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "SBObject.h"
#import "CacheCenter.h"
#import "SBApiEngine.h"
#import "AlertCenter.h"
#import "StatService.h"

#ifdef RD_TEST
#import "Utility.h"
#endif

#define TIMEOUT 15


static LocationService *instance = nil;

@implementation LocationService
@synthesize isLocating = _isLocating;

+ (id)allocWithZone:(NSZone *)zone {
	NSAssert(instance == nil, @"Duplicate alloc a singleton class");
	return [super allocWithZone:zone];
}

+ (LocationService *)sharedInstance {
	@synchronized([LocationService class]) {
		if (!instance) {
			instance = [[LocationService alloc] init];
		}
	}
	return instance;
}

- (id)init {
	if ((self = [super init])) {
		locationManager = [[CLLocationManager alloc] init];
		locationManager.delegate = self;
		locationManager.desiredAccuracy = kCLLocationAccuracyBest;
		locationManager.distanceFilter = 10;   // 移动10米重新更新一次位置,如果为None则会不停地定位
	}
	return self;
}

- (void)dealloc {
	[locationManager release];
	[_location release];
	CancelRequest(request);
	[super dealloc];
}

- (void)updateLocationTimeout {
//	[locationManager stopUpdatingHeading];
	[Notifier postNotificationName:kLocationFailed object:nil];
}


#pragma mark -
#pragma mark Public methods
- (void)startLocation {
	if (_isLocating) return;
    
	[locationManager startUpdatingLocation];
	[self performSelector:@selector(updateLocationTimeout) withObject:nil afterDelay:TIMEOUT];
	_isLocating = YES;
}

- (void)stopLocation {
	[locationManager stopUpdatingLocation];
    CancelRequest(request);
	_isLocating = NO;
}

- (SBLocation *)currentLocation 
{
    if (!_location) {
        [self startLocation];
    }
    
    return _location;
}

- (NSInteger)currentCityId
{
    if (_location) {
        return _location.cityId;
    } else {
        return CurrentCity.id;
    }
}

- (void)getBaiduLocationLatitude:(CGFloat)latitude longitude:(CGFloat)longitude delegate:(id)del {
	NSString *url = [NSString stringWithFormat:@"%@/getLocation?x=%f&y=%f&xda_did=%@", ROOT_URL, latitude, longitude, IMEI];
	request = [[HttpRequest alloc] initWithDelegate:del andExtraData:nil];
	[request requestGET:url useStat:YES];   // 不使用request缓存
	
}


#pragma mark -
#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
	[NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationTimeout) object:nil];
    
    // 忽略缓存的location信息(官方解决方案)
    NSTimeInterval interval = [newLocation.timestamp timeIntervalSinceNow];
    if (abs(interval) >= 10) {
		return;
	}
    
	[locationManager stopUpdatingLocation]; // 如果获取GPS信息成功则停止更新（省电）
    
	CGFloat latitude   = newLocation.coordinate.latitude;
	CGFloat longitude  = newLocation.coordinate.longitude;

    if (!_location) {
        _location = [SBLocation new];
    }

	_location.latitude = latitude;
	_location.longitude = longitude;
	
	if (latitude != 0 || longitude != 0) {	// 如果经纬度都为0,则没有定位成功(比如连上没有通过准入的百度WIFI)
        if (hasAbandonOnce) {
            // 处理第二次定位的数据
            hasAbandonOnce = NO;
            CancelRequest(request);
#ifdef RD_TEST
			NSString *locationStr = [NSString stringWithFormat:@"x=%f, y=%f", latitude, longitude];
			Alert(@"Location", locationStr);
#endif
            // http://client.shenbian.com/iphone/getLocation?x=fload&y=fload
//            NSString *url = [NSString stringWithFormat:@"%@/getLocation?x=%f&y=%f&xda_did=%@", ROOT_URL, latitude, longitude, IMEI];
//            request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
//            [request requestGET:url useStat:YES];   // 不使用request缓存
			[self getBaiduLocationLatitude:latitude longitude:longitude delegate:self];
        } else {
            // 丢掉第一次定位的数据（可能定位不准确）
            _isLocating = NO;
            [self startLocation];
            hasAbandonOnce = YES;
        }
	} else {
		[Notifier postNotificationName:kLocationFailed object:nil];
	}
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    Stat(@"locate_result?suc=0");
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(updateLocationTimeout) object:nil];
    
	DLog(@"locationManager didFailWithError%@", error);
    if ([error code] != kCLErrorLocationUnknown) {
		[Notifier postNotificationName:kLocationFailed object:error];
    }
	
	_isLocating = NO;
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Stat(@"locate_result?suc=0");
    
	_isLocating = NO;
	Release(request);
	[Notifier postNotificationName:kLocationFailed object:nil];
}

- (void)requestSucceeded:(HttpRequest*)req {
    Stat(@"locate_result?suc=1");
    
	_isLocating = NO;
	NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    if (!_location) {
        _location = [SBLocation new];
    }
    _location.address  = [dict objectForKey:@"addr"];
    _location.cityId   = [[dict objectForKey:@"city_code"] intValue];
    _location.cityName = [dict objectForKey:@"city"];
    _location.area     = [dict objectForKey:@"street"];
    _location.x        = [dict objectForKey:@"bdx"];
    _location.y        = [dict objectForKey:@"bdy"];
    [Notifier postNotificationName:kLocationSuccessed object:nil];
    Release(request);
    
#ifdef RD_TEST
    NSString *path = [Utility filePathWithName:@"GPS.log" andDirectory:@"log"];
    CLLocation *realLocation = locationManager.location;
    NSString *latitude  = [NSString stringWithFormat:@"%f", realLocation.coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", realLocation.coordinate.longitude];
    NSString *time      = [Utility stringWithDate:[NSDate date] andFormatter:[Utility dateFormatterWithString:@"yyyy-MM-dd HH:mm:ss"]];
    NSDictionary *logInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                             latitude,           @"latitude",
                             longitude,          @"longitude",
                             _location.area,     @"area",
                             _location.cityName, @"city",
                             _location.address,  @"address",
                             time,               @"time", nil];
    NSMutableArray *logList = [NSMutableArray array];
    [logList addObjectsFromArray:[NSArray arrayWithContentsOfFile:path]];
    [logList addObject:logInfo];
    [logList writeToFile:path atomically:NO];
#endif
}


@end
