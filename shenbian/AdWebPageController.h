//
//  AdWebPageController.h
//  shenbian
//
//  Created by Leeyan on 11-8-1.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

/**
 *	普通网页广告
 */

#import <Foundation/Foundation.h>
#import "SBAdvertisement.h"
#import "LoadingView.h"
#import "SBAdvertisementView.h"

@interface AdWebPageController : NSObject <UIWebViewDelegate> {
	UIWebView *m_webView;
	LoadingView *loadingView;
	NSString *m_url;
	
	SBAdvertisementView *delegate;
	CGRect frame;
}

@property(nonatomic, readonly) UIWebView *webView;

- (void)doBack;
- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate;
- (void)loadURL:(NSString *)_url title:(NSString *)_title;

- (void)showLoadingOnView:(UIView *)view;
- (void)hideLoading;


@end
