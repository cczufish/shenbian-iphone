//
//  AdActivityController.h
//  shenbian
//
//  Created by Leeyan on 11-8-1.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

/**
 *	活动报名页面广告
 */


#import <Foundation/Foundation.h>
#import "AdWebPageController.h"
#import "HttpRequest.h"

#define AD_ACTIVITY_SHOW_ENROLL_BUTTON			@"showButton(1)"
#define AD_ACTIVITY_SHOW_ALREADY_ENROLLED_BUTTON	@"showButton(2)"
#define AD_ACTIVITY_HIDE_BUTTON					@"showButton(0)"

@interface AdActivityController : AdWebPageController {
	NSString *activityId;
	HttpRequest *enrollRequest;
	HttpRequest *enrollStatusRequest;
	
	BOOL isInEnrolling;
}

@property(nonatomic, assign) NSString *activityId;

- (id)initWithFrame:(CGRect)_frame andActivityId:(NSString *)_activityId andDelegate:(id)_delegate;

@end
