//
//  SBGuideView.m
//  shenbian
//
//  Created by MagicYang on 6/23/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBGuideView.h"
#import "Notifications.h"

@implementation SBGuideView

- (id)init
{
    self = [super initWithFrame:CGRectMake(0, 20, 320, 460)];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIImageView *topBar = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_bg")];
        topBar.userInteractionEnabled = YES;
        topBar.frame = CGRectMake(0, 0, 320, 44);
        
        UIImageView *titleView = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_titleView")];
        titleView.frame = CGRectMake((320 - 115) / 2, (44 - 27) / 2, 115, 27);
        [topBar addSubview:titleView];
        [titleView release];
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(235, 7, 80, 30)];
        UIImage *img0 = [PNGImage(@"button_navigation_normal_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        UIImage *img1 = [PNGImage(@"button_navigation_normal_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        [cancelBtn setBackgroundImage:img0 forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
        [cancelBtn setTitle:@"开始使用" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FontWithSize(13);
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:cancelBtn];
        
        UIImageView *introImageView = [[UIImageView alloc] initWithImage:PNGImage(@"intro")];
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
        scrollView.contentSize = CGSizeMake(320, introImageView.image.size.height);
        [scrollView addSubview:introImageView]; 
        [introImageView release];        
        
        [self addSubview:topBar];
        [self addSubview:scrollView];
        [scrollView release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)hide
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideAnimationDidStop)];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    self.alpha = 0;
    [UIView commitAnimations];
}

- (void)hideAnimationDidStop
{
    [Notifier postNotificationName:kGuideDissmissed object:nil];
    [self removeFromSuperview];
}

+ (void)showGuide
{
    SBGuideView *guide = [SBGuideView new];
    UIWindow *window = [[[UIApplication sharedApplication] windows] lastObject];
    [window addSubview:guide];
    [guide release];
}

@end
