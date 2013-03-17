//
//  SBLocation.m
//  shenbian
//
//  Created by MagicYang on 10-12-24.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBLocation.h"


@implementation SBLocation

@synthesize area;
@synthesize cityName;
@synthesize address;
@synthesize x, y;
@synthesize latitude, longitude;
@synthesize cityId;

- (void)dealloc {
	[area release];
	[cityName release];
	[address release];
	[x release];
	[y release];
	[super dealloc];
}

@end
