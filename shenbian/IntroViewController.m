    //
//  IntroViewController.m
//  shenbian
//
//  Created by Leeyan on 11-5-13.
//  Copyright 2011 百度. All rights reserved.
//

#import "IntroViewController.h"

@implementation IntroViewController


- (void)loadView {
	[super loadView];
	self.title = @"玩转身边";
    self.view.backgroundColor = [UIColor clearColor];

	self.view.backgroundColor = [UIColor whiteColor];
	UIImageView *introImageView = [[UIImageView alloc] initWithImage:PNGImage(@"intro")];
	UIScrollView *v = [[UIScrollView alloc] initWithFrame:vsr(0, 0, 320, 416)];
	v.contentSize = CGSizeMake(320, introImageView.image.size.height);
	[v addSubview:introImageView];
	[self addSubview:v];
	
	[introImageView release];
	[v release];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"play_into");
}

@end
