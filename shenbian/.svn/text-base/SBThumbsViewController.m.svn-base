    //
//  SBThumbsViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-8.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBThumbsViewController.h"
#import "KTThumbsViewController.h"
#import "SBImageDataSource.h"


@implementation SBThumbsViewController

@synthesize imageLinks;

- (void)newNavigationBar {
	self.navigationController.navigationBar.tag = 1;
	self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
	self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStyleBordered target:self action:@selector(back:)];
}

- (void)oldNavigationBar {
	self.navigationController.navigationBar.tag = 0;
	self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (SBThumbsViewController *)initWithLinks:(NSArray *)links {
	if ((self = [super init])) {
		self.imageLinks = links;
	}
	return self;
}

- (void)loadView {
	[super loadView];
	self.title = @"商户相册";
	[self newNavigationBar];
}

- (void)viewDidLoad {
//	images = [[SBImageDataSource alloc] initWithImageLinks:imageLinks];
	[self setDataSource:images];
}

- (void)dealloc {
	[self oldNavigationBar];
	[imageLinks release];
	[images release];
    [super dealloc];
}

- (void)back:(id)sender {
	[self dismissModalViewControllerAnimated:YES];
}

@end