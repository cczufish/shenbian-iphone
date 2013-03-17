//
//  SBAdvertisementView.h
//  shenbian
//
//  Created by Leeyan on 11-6-20.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAdvertisement.h"

@interface SBAdvertisementView : UIButton <UIWebViewDelegate> {
	SBAdvertisement *adModel;
	UIViewController *m_sender;
	UIWebView *m_webView;
	
	BOOL isInEnrolling;
	
	id adContrainer;	//	广告内容的容器，用这个变量来保持，以便于释放
}

@property(nonatomic, retain) SBAdvertisement *adModel;
@property(nonatomic, assign) UIViewController *sender;
@property(nonatomic, retain) UIWebView *webView;

- (id)initWithFrame:(CGRect)frame andAdModel:(SBAdvertisement *)model;
- (void)showAdOn:(UIViewController *)viewController;
- (void)hideAd;
- (void)doBack;

@end
