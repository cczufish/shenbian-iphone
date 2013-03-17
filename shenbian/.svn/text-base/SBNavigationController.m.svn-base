    //
//  SBNavigationController.m
//  shenbian
//
//  Created by MagicYang on 10-12-2.
//  Copyright 2010 百度. All rights reserved.
//

#import "SBNavigationController.h"
#import "UIViewAdditions.h"


#define ButtonTitleSize 13
//#define ButtonTitleColor [UIColor colorWithRed:0.620 green:0 blue:0.118 alpha:1]
#define ButtonTitleColor [UIColor whiteColor]

@implementation SBNavigationController

- (void)viewDidUnload {
	[super viewDidUnload];
	
	Release(navShadow);
}

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor whiteColor];
    
	// 导航按钮
	NSArray *controllers = [self.navigationController viewControllers];
	if ([controllers count] > 1) {
		[self setBackTitle:[self defaultBackTitle]];
	}
	
	// 导航栏下方阴影
	navShadow = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_shadow")];
	navShadow.frame = CGRectMake(0, 0, 320, 5);
	[self.view addSubview:navShadow];
}

- (void)viewDidAppear:(BOOL)animated {
	isShowing = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
	isShowing = NO;
}

- (NSString *)defaultBackTitle {
	NSArray *controllers = [self.navigationController viewControllers];
	if ([controllers count] > 1) {
		UIViewController *controller = [[self.navigationController viewControllers] objectAtIndex:[controllers count] - 2];
		if (controller.title) {
			return controller.title;
		}
	}
	return @"返回";
}

- (void)back:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)setBackTitle:(NSString *)backTitle {
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
	if ([backTitle length] > 2) {
		[backButton setFrame:CGRectMake(0, 0, 70, 30)];
	} else {
		[backButton setFrame:CGRectMake(0, 0, 50, 30)];
	}
    
    UIImage *img0 = [PNGImage(@"button_navigation_back_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage *img1 = [PNGImage(@"button_navigation_back_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [backButton setBackgroundImage:img0 forState:UIControlStateNormal];
    [backButton setBackgroundImage:img1 forState:UIControlStateHighlighted];
    
    backButton.titleLabel.font = FontWithSize(ButtonTitleSize);
    [backButton setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
	[backButton setTitle:backTitle forState:UIControlStateNormal];
	[backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
	[backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
	self.navigationItem.leftBarButtonItem = backButtonItem;
	self.navigationItem.backBarButtonItem = nil;
	[backButtonItem release];
}

- (void)addSubview:(UIView *)subview {
	[self.view addSubview:subview];
	[self.view bringSubviewToFront:navShadow];
}

+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)aTitle andAction:(SEL)action inDelegate:(id)delegate {
	UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];	
    [button setFrame:CGRectMake(0, 0, 51, 30)];
    button.width += ([aTitle length] - 2) * 10;

    UIImage *img0 = [PNGImage(@"button_navigation_normal_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    UIImage *img1 = [PNGImage(@"button_navigation_normal_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
    [button setBackgroundImage:img0 forState:UIControlStateNormal];
    [button setBackgroundImage:img1 forState:UIControlStateHighlighted];
    
	button.titleLabel.font = FontWithSize(ButtonTitleSize);
    [button setTitleColor:ButtonTitleColor forState:UIControlStateNormal];
	[button setTitle:aTitle forState:UIControlStateNormal];
	[button addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
	return [buttonItem autorelease];
}

- (void)dealloc {
	[navShadow release];
	[super dealloc];
}

@end


@implementation UINavigationBar(CustomBackground)

- (void)drawRect:(CGRect)rect {
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGContextSaveGState(ctx);
	if (self.tag == 0) {
        [[UIImage imageNamed:@"navigationbar_bg.png"] drawAsPatternInRect:rect];;
	} else {
        [[UIImage imageNamed:@"navigationbar_bg_translucent.png"] drawAsPatternInRect:rect];
	}
	
	CGContextRestoreGState(ctx);
}

@end