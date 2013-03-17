//
//  SBLocation.h
//  shenbian
//
//  Created by MagicYang on 10-12-24.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBLocation : NSObject {
	NSString *x;
	NSString *y;
	CGFloat latitude;
	CGFloat longitude;
	NSString *address;
	NSString *cityName;
	NSString *area;
	NSInteger cityId;
}
@property(nonatomic, retain) NSString *area;
@property(nonatomic, retain) NSString *cityName;
@property(nonatomic, retain) NSString *address;
@property(nonatomic, retain) NSString *x;
@property(nonatomic, retain) NSString *y;
@property(assign) CGFloat latitude;
@property(assign) CGFloat longitude;
@property(assign) NSInteger cityId;

@end
