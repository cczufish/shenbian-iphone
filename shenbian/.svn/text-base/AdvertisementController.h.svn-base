//
//  AdvertisementController.h
//  shenbian
//
//  Created by Leeyan on 11-7-14.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAdvertisement.h"
#import "SBAdvertisementView.h"
#import "HttpRequest.h"

@interface AdvertisementController : NSObject {
	SBAdvertisement *adModel;
	SBAdvertisementView *adView;
	
	id delegate;
	CGRect frame;
	NSString *url;
	
	CGFloat duration;	//	广告展示时间
	CGFloat delay;
	
	HttpRequest *request;
}

- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate andDuration:(CGFloat)_duration andUrl:(NSString *)_url;
- (void)loadAdvertisement;

@end
