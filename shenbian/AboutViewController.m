    //
//  AboutViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-29.
//  Copyright 2010 personal. All rights reserved.
//

#import "AboutViewController.h"


#define SBSite @"s.baidu.com"

@implementation AboutViewController

- (void)loadView {
	[super loadView];

	self.title = @"关于我们";
	
	UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	imgView.image = PNGImage(@"aboutus_bg");
//	[[[self.view subviews] objectAtIndex:0] removeFromSuperview];
	[self addSubview:imgView];
	[imgView release];
	

	UILabel *label0 = [[UILabel alloc] initWithFrame:CGRectMake(95, 283, 200, 20)];
	label0.backgroundColor = [UIColor clearColor];
	label0.font = [UIFont systemFontOfSize:18];
	label0.text = SBSite;
	label0.textColor = [UIColor colorWithRed:0.412 green:0.659 blue:0.871 alpha:1];
	[self addSubview:label0];
	
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
	button.backgroundColor = [UIColor clearColor];
	[button setFrame:label0.frame];
	[button addTarget:self action:@selector(accessWebsite:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:button];
	[label0 release];
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(110, 325, 200, 20)];
	label1.backgroundColor = [UIColor clearColor];
	label1.font = [UIFont systemFontOfSize:18];
    
    NSString* version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]; 

	label1.text = version;
	[self addSubview:label1];
	[label1 release];
}

- (void)accessWebsite:(id)sender {
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@", SBSite]]];
}

- (void)viewDidLoad {
	[super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"aboutus_into");
}

@end
