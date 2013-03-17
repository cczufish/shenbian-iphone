//
//  WeiBoShareCommentsView.m
//  shenbian
//
//  Created by xu xhan on 5/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "WeiBoShareCommentsView.h"
#import "AppDelegate.h"

#define WeiBoShareCommentsViewAnimationHeight 260
#define WeiBoShareCommentsViewAnimationDuration 0.3

@implementation WeiBoShareCommentsView
@synthesize withOjbAssign;

- (id)initWithDelegate:(id)aDelegate
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        delegate = aDelegate;
        self.backgroundColor = [T colorR:0 g:0 b:0 a:0.5];
        [self _setupSubviews];
    }
    return self;
}

- (void)dealloc
{
    VSSafeRelease(containerView);
    VSSafeRelease(textView);
    [super dealloc];
}

- (void)_setupSubviews
{
    containerView = [[UIView alloc] initWithFrame:self.bounds];
    containerView.backgroundColor = [UIColor clearColor];
    containerView.origin = ccp(11, 11);
    [self addSubview:containerView];
    
    UIView* bg = [T imageViewNamed:@"weibo_share_bg.png"]; 
    [containerView addSubview:bg];
    
    //title
    UILabel* labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300, 35)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = FontWithSize(17);
    labelTitle.textAlignment = UITextAlignmentCenter;
    labelTitle.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
    labelTitle.text = @"分享到新浪微博";
    [containerView addSubview:labelTitle];
    [labelTitle release];
    
    textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 45, 280, 160)];
    textView.font = FontWithSize(16);
//    textView.delegate = self;
    textView.backgroundColor = [UIColor clearColor];
    textView.textColor = [UIColor darkGrayColor];
    [containerView addSubview:textView];
    
    //two buttons
    UIButton* btnCancel = [T createBtnfromPoint:ccp(bg.left,bg.bottom +5 )
                                          image:PNGImage(@"weibo_share_close")
                                   highlightImg:PNGImage(@"weibo_share_close_h")
                                         target:self
                                       selector:@selector(onBtnClose)];
    [containerView addSubview:btnCancel];
    
    UIButton* btnShare = [T createBtnfromPoint:CGPointZero
                                         image:PNGImage(@"weibo_share_share")
                                  highlightImg:PNGImage(@"weibo_share_share_h")
                                        target:self
                                      selector:@selector(onBtnShare)];
    btnShare.right = bg.right;
    btnShare.top = bg.bottom + 5;
    [containerView addSubview:btnShare];
    
    containerView.top -= WeiBoShareCommentsViewAnimationHeight;
}


- (void)_showKeyboard
{
    [textView becomeFirstResponder];
}

- (void)_hidenKeyboard
{
    [textView resignFirstResponder];
}


- (void)onBtnClose
{
    [delegate weiboShareView:self cancelBtnPressed:textView.text];
}

- (void)onBtnShare
{
    [delegate weiboShareView:self confirmBtnPressed:textView.text];
}

- (void)showInMainWindow
{
    UIWindow* win = [AppDelegate sharedDelegate].window;
    win.windowLevel = UIWindowLevelStatusBar + 1;
    [self showInWindow:win];
}

- (void)showInWindow:(UIWindow*)win;
{
    [win addSubview:self];
    
    [self _showKeyboard];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:WeiBoShareCommentsViewAnimationDuration];
    containerView.top += WeiBoShareCommentsViewAnimationHeight;
    [UIView commitAnimations];
}

- (void)dismiss
{
    //convert back
    UIWindow* win = (UIWindow*)[self superview];
    win.windowLevel = UIWindowLevelNormal;
    
    [self _hidenKeyboard];
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:WeiBoShareCommentsViewAnimationDuration];
    //added delegate to handle removeFromSuperView action
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    containerView.top -= WeiBoShareCommentsViewAnimationHeight;
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    [self removeFromSuperview];
}

@end
