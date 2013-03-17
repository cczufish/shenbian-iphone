//
//  HttpRequest+NetworkIndicator.h
//  VOAListening
//
//  Created by MagicYang on 10-7-28.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"


typedef enum  {
	NetworkActivityIndicatorShow = 1,
	NetworkActivityIndicatorHide = -1
} NetworkActivityIndicatorStatus;

@interface HttpRequest (NetworkIndicator)

+ (void)setNetworkActivityIndicator:(NetworkActivityIndicatorStatus)status;

@end
