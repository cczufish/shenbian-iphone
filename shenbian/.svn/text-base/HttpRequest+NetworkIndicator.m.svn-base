//
//  HttpRequest+NetworkIndicator.m
//  VOAListening
//
//  Created by MagicYang on 10-7-28.
//  Copyright 2010 personal. All rights reserved.
//

#import "HttpRequest+NetworkIndicator.h"

static int ConnectionCount = 0;

@implementation HttpRequest(NetworkIndicator)

+ (void)setNetworkActivityIndicator:(NetworkActivityIndicatorStatus)status {
	ConnectionCount = ConnectionCount + status;
	if(ConnectionCount > 0) {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
	} else {
		[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
		
		if(ConnectionCount < 0)		// assure the ConnectionCount to be >= 0
			ConnectionCount = 0;
	}
}

@end
