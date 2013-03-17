/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>


#define iPhone     @"iPhone"
#define iPhone3G   @"iPhone 3G"
#define iPhone3GS  @"iPhone 3GS"
#define iPhone4    @"iPhone 4"
#define iPod1      @"iPodTouch 1Gen"
#define iPod2      @"iPodTouch 2Gen"
#define iPod3      @"iPodTouch 3Gen"
#define iPad1      @"iPad 1Gen"
#define iPad2      @"iPad 2Gen"

@interface UIDevice (Hardware)
+ (NSString *) platform;
+ (NSUInteger) cpuFrequency;
+ (NSUInteger) busFrequency;
+ (NSUInteger) totalMemory;
+ (NSUInteger) userMemory;
+ (NSUInteger) availableMemory;
+ (NSUInteger) wireMemory;
+ (NSUInteger) activeMemory;
+ (NSUInteger) inactiveMemory;
+ (NSUInteger) moreInfo;
@end