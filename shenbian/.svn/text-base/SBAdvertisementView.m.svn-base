//
//  SBAdvertisementView.m
//  shenbian
//
//  Created by Leeyan on 11-6-20.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBAdvertisementView.h"
#import "SBNavigationController.h"
#import "VSTabBarController.h"
#import "UIButton+RemoteImage.h"
#import "LoginController.h"
#import "SBApiEngine.h"
#import "TKAlertCenter.h"
#import "ShopInfoViewController.h"

#import "AdWebPageController.h"
#import "AdShopController.h"
#import "AdActivityController.h"

@interface SBAdvertisementView ()

- (void)normalAdLaunch;
- (void)shopAdLaunch;
- (void)activityAdLaunch;

@end



@implementation SBAdvertisementView

@synthesize adModel, sender = m_sender, webView = m_webView;

- (id)initWithFrame:(CGRect)frame andAdModel:(SBAdvertisement *)model{
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.adModel = model;
		self.frame = frame;
    }
    return self;
}

- (void)showAdOn:(UIViewController *)viewController {
	self.sender = viewController;
	[self setImageWithURL:[NSURL URLWithString:self.adModel.imgUrl]];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image {
	[super webImageManager:imageManager didFinishWithImage:image];
	if (nil != image) {
		[self addTarget:self
				 action:@selector(onAdTouched)
	   forControlEvents:UIControlEventTouchUpInside];
		[self.sender.view addSubview:self];
		if ([self.sender respondsToSelector:@selector(advertisementLoadSuccess:)]) {
			[self.sender performSelector:@selector(advertisementLoadSuccess:) withObject:self];
		}
	} else if ([self.sender respondsToSelector:@selector(advertisementLoadFailed:)]) {
		[self.sender performSelector:@selector(advertisementLoadFailed:) withObject:self];
	}

}

- (void)hideAd {
	if ([self.sender respondsToSelector:@selector(advertisementWillHide:)]) {
		[self.sender performSelector:@selector(advertisementWillHide:) withObject:self];
		return;
	}
	[UIView beginAnimations:@"hideAd" context:nil];
	[UIView setAnimationDuration:0.75f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDone:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:self cache:YES];
	
	self.origin = CGPointMake(0, 372);
	
	[UIView commitAnimations];
}

- (void)animationDone:(NSString *)animationID finished:(BOOL)finished context:(void *)context {
	if ([animationID isEqualToString:@"hideAd"]) {
		[self removeFromSuperview];
	}
	
	if ([self.sender respondsToSelector:@selector(advertisementDidHided)]) {
		[self.sender performSelector:@selector(advertisementDidHided)];
	}
}

- (void)onAdTouched {
	if (nil == self.adModel.jumpUrl) {
		return;
	}
	
//	self.adModel.text = @"8";	//	test code
//	self.adModel.type = @"3";
//	self.adModel.jumpUrl = @"http://s.baidu.com/event/mobile/1.html";
//	self.adModel.type = @"1";
	
//	self.adModel.type = @"2";
//	self.adModel.jumpUrl = @"c9e24a2762a0afd619301f72";
    
	switch ([self.adModel.type intValue]) {
		case kAdTypeNormal:
			[self normalAdLaunch];
			break;
		case kAdTypeShop:
			[self shopAdLaunch];
			break;
		case kAdTypeActivity:
			[self activityAdLaunch];
			break;
		default:
			break;
	}
}

- (void)normalAdLaunch
{
//	[self advLauch:nil];
    Stat(@"banner_into?act_id=%@", self.adModel.text);
    
	AdWebPageController *webpageController = [[AdWebPageController alloc] initWithFrame:vsr(0, 0, 320, 416)
																			andDelegate:self];
	[webpageController loadURL:self.adModel.jumpUrl title:@"活动详情"];
	[adContrainer release];
	adContrainer = [webpageController retain];
	[webpageController release];
}

- (void)shopAdLaunch {
	NSString *shopId = self.adModel.jumpUrl;
	
//	[self pushShop:shopId];
	AdShopController *shopController = [[AdShopController alloc] initWithShopId:shopId
																	andDelegate:self];
	[shopController gotoShop];
	[adContrainer release];
	adContrainer = [shopController retain];
	[shopController release];
}

- (void)activityAdLaunch {
//	[self advLauch:self];
    Stat(@"banner_into?act_id=%@", self.adModel.text);
    
	NSString *activityId = self.adModel.text;
	AdActivityController *activityController = [[AdActivityController alloc] 
												initWithFrame:vsr(0, 0, 320, 416)
												andActivityId:activityId
												  andDelegate:self];
	[activityController loadURL:self.adModel.jumpUrl title:@"活动详情"];
	[adContrainer release];
	adContrainer = [activityController retain];
	[activityController release];
}

- (void)pushShop:(NSString *)shopId {
	ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shopId];
	controller.hidesBottomBarWhenPushed = YES;
	[self.sender.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)doBack {
//	[adContrainer release];
//	if (self.webView.loading) {
//		[self.webView stopLoading];
//	}
//	[self.sender.vstabBarController dismissModalViewControllerAnimated:YES];
//	self.webView = nil;
//	CancelRequest(enrollStatusRequest);
//	CancelRequest(enrollRequest);
}



- (void)dealloc {
	self.adModel = nil;
	self.webView.delegate = nil;
	self.webView = nil;
	[adContrainer release];
	
    [super dealloc];
}


@end
