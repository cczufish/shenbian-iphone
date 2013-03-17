//
//  AdWebPageController.m
//  shenbian
//
//  Created by Leeyan on 11-8-1.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "AdWebPageController.h"
#import "SBNavigationController.h"
#import "VSTabBarController.h"
#import "TKAlertCenter.h"
#import "ShopInfoViewController.h"

@interface AdWebPageController (Private) 

@end



@implementation AdWebPageController

@synthesize webView = m_webView;

- (id)initWithFrame:(CGRect)_frame andDelegate:(id)_delegate {
    self = [super init];
	if (self) {
		frame = _frame;
		delegate = _delegate;
	}
	
	return self;
}

- (void)doBack {
	if (m_webView.loading) {
		[m_webView stopLoading];
	}
	[delegate.sender.vstabBarController dismissModalViewControllerAnimated:YES];
	[delegate doBack];
}

- (void)loadURL:(NSString *)_url title:(NSString *)_title {
	m_url = _url;
	SBNavigationController *sbnc = [[SBNavigationController alloc] init];
	sbnc.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"取消"
																			  andAction:@selector(doBack)
																			 inDelegate:self];
	sbnc.navigationItem.title = _title;	//	@"活动详情"
	UIWebView *webView = [[UIWebView alloc] initWithFrame:frame];	//vsr(0, 0, 320, 416)
	
	webView.dataDetectorTypes = UIDataDetectorTypeNone;
	
	webView.delegate = self;
	
	[sbnc addSubview:webView];
	
	[self showLoadingOnView:sbnc.view];
	
	[webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_url]]];
						  //[NSURL URLWithString:self.adModel.jumpUrl]]];
	[m_webView release];
	m_webView = [webView retain];
	
	[webView release];
	
	UINavigationController *nc = [[UINavigationController alloc]
								  initWithRootViewController:sbnc];
	[delegate.sender showModalViewController:nc animated:YES];
    [nc release];
	[sbnc release];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
	[self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    if ([error code] != -999) {
        TKAlert(@"载入失败，无法打开网页");
    }
    [self hideLoading];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
	
	NSURL *url = [request URL];
	
	if ([[url absoluteString] isEqualToString:m_url]) {
		return YES;
	}
	
	//	url = [NSURL URLWithString:@"shenbian://gotoShop?id=c9e24a2762a0afd619301f72"];	//	test code
	
	NSString *scheme = [url scheme];
	
	if ([scheme isEqualToString:@"shenbian"]) {
		//	符合身边协议的链接
		NSString *action = [url host];
		SEL actionSelector = NSSelectorFromString([NSString stringWithFormat:@"%@:", action]);
		if ([self respondsToSelector:actionSelector]) {
			NSString *query = [url query];
			NSArray *sep = [query componentsSeparatedByString:@"&"];
			
			NSMutableDictionary *dictParam = [NSMutableDictionary dictionary];
			for (NSString *param in sep) {
				NSArray *sp = [param componentsSeparatedByString:@"="];
				[dictParam setObject:[sp objectAtIndex:1] forKey:[sp objectAtIndex:0]];
			}
			[self performSelector:actionSelector withObject:dictParam afterDelay:0.1f];
		}
	} else if ([scheme isEqualToString:@"http"]) {
		//	http地址请求
		[[UIApplication sharedApplication] openURL:url];
	}
	
	return NO;
}

- (void)gotoShop:(NSDictionary *)params {
	NSString *shopId = [params objectForKey:@"id"];
	
	[self doBack];
	
	ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shopId];
	controller.hidesBottomBarWhenPushed = YES;
	[delegate.sender.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)showLoadingOnView:(UIView *)view {
	if (!loadingView) {
		loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:@""];
	}
	[view addSubview:loadingView];
//	[self performSelector:@selector(hideLoading) withObject:nil afterDelay:5.0f];
}

- (void)hideLoading {
	[loadingView removeFromSuperview];
}

- (void)dealloc {
	if (self.webView.loading) {
		[self.webView stopLoading];
	}
	[m_webView release];
	[loadingView release];
	
	[super dealloc];
}


@end
