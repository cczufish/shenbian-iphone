//
//  ShopMapInfoViewController.m
//  shenbian
//
//  Created by MagicYang on 10-11-25.
//  Copyright 2010 personal. All rights reserved.
//

#import "ShopMapInfoViewController.h"
#import "LoadingView.h"


@implementation ShopMapInfoViewController

@synthesize location;
@synthesize shopName;


- (ShopMapInfoViewController *)initWithLocation:(BaiduLocation)aLocation {
	if ((self = [super init])) {
		self.location = aLocation;
	}
	return self;
}

- (void)dealloc {
	[webView release];
	[shopName release];
    [super dealloc];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	Release(webView);
	Release(loadingView);
}

- (void)loadView {
	[super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    
	self.title = @"地图";
	self.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"取消" andAction:@selector(back:) inDelegate:self];
	
	CGRect rect = self.view.frame;
	webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
	webView.delegate = self;
	webView.backgroundColor = [UIColor clearColor];
	NSString *map = [NSString stringWithContentsOfFile:ResourcePath(@"map", @"html") encoding:NSUTF8StringEncoding error:nil];
	[webView loadHTMLString:map baseURL:nil];
	[self addSubview:webView];
	
	loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
	[self addSubview:loadingView];
}

- (void)webViewDidFinishLoad:(UIWebView *)web {
//	location.x = 116.404;
//	location.y = 39.915;
//	shopName = @"天安门";
//	NSLog(@"x = %lf, y = %lf", location.x, location.y);
	NSString *js = [NSString stringWithFormat:@"javascript:map(%lf, %lf, '%@');", location.x, location.y, shopName];
	[web stringByEvaluatingJavaScriptFromString:js];
	
	[loadingView removeFromSuperview];
}

- (void)back:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end
