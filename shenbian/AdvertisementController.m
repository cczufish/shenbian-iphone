    //
//  AdvertisementController.m
//  shenbian
//
//  Created by Leeyan on 11-7-14.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "AdvertisementController.h"
#import "Utility.h"
#import "HttpRequest+Statistic.h"

@interface AdvertisementController ()

- (void)advertisementLoaded;

@end

@implementation AdvertisementController

- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate andDuration:(CGFloat)_duration andUrl:(NSString *)_url {
	if ((self = [super init])) {
		frame = _frame;
		delegate = _delegate;
		duration = _duration;
		url = _url;
	}
	return self;
}

#pragma mark -
#pragma mark Advertisement
- (void)loadAdvertisement {
	CancelRequest(request);
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];

	NSString *adURL = nil == url ? AD_URL : url;

	[request requestGET:adURL useStat:YES];
}

- (void)requestFailed:(HttpRequest *)req {
	Release(request);
}

- (void)requestSucceeded:(HttpRequest *)req {
	NSDictionary *dict = [Utility parseData:req.recievedData];
	if (nil == adModel) {
		adModel = [[SBAdvertisement alloc] init];
	}
	adModel.imgUrl = SETNIL([dict objectForKey:@"img"], @"");
	adModel.jumpUrl = SETNIL([dict objectForKey:@"id"], @"");
	adModel.type = SETNIL([dict objectForKey:@"type"], @"");
	adModel.text = SETNIL([dict objectForKey:@"text"], @"");
	
	if (![adModel.jumpUrl isEmpty] && ![adModel.imgUrl isEmpty]) {
		[self advertisementLoaded];
	}
	
    Release(request);
}


-(void) doHildAdView:(int)a andName:(NSString*)name{

    
}

- (void)advertisementLoaded {
	[adView release];
	adView = [[SBAdvertisementView alloc] initWithFrame:frame
											 andAdModel:adModel];
	
	[adView showAdOn:(UIViewController *)delegate];
	if (duration > 0.0f) {
		//	广告延迟时间
		[adView performSelector:@selector(hideAd) withObject:nil afterDelay:duration];
	}
}




- (void)dealloc {
	Release(adModel);
	Release(adView);
	CancelRequest(request);
	
    [super dealloc];
}


@end
