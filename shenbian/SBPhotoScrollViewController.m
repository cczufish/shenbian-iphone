//
//  SBPhotoScrollViewController.m
//  shenbian
//
//  Created by MagicYang on 11-1-21.
//  Copyright 2011 personal. All rights reserved.
//

#import "SBPhotoScrollViewController.h"


@implementation SBPhotoScrollViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Special deal with 1 image
    if (photoCount_ == 1) {
        [toolbar_ removeFromSuperview];
    }
}

- (void)setTitleWithCurrentPhotoIndex
{
    // Special deal with 1 image
    if (photoCount_ == 1) {
        [self setTitle:nil];
    } else {
        [super performSelector:@selector(setTitleWithCurrentPhotoIndex)];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
    UIView *photoView = [[scrollView_ subviews] objectAtIndex:0];
    photoView.alpha = 0;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    photoView.alpha = 1;
    [UIView commitAnimations];
}

- (void)viewDidDisappear:(BOOL)animated 
{
    [super viewDidDisappear:animated];
    
    // Fixed:在“隐藏导航栏动画执行时，点‘返回’”，statusBar消失
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
}

- (void)toggleChromeDisplay 
{
    self.view.backgroundColor = [UIColor blackColor];
    scrollView_.alpha = 1;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidFinished)];
    scrollView_.alpha = 0;
    [UIView commitAnimations];
}

- (void)animationDidFinished
{
    [self dismissModalViewControllerAnimated:NO];
}

// Overwrite super class methods to diable something
- (void)hideChrome{};
- (void)showChrome{};
- (void)startChromeDisplayTimer{}
- (void)cancelChromeDisplayTimer{}
@end
