//
//  VSAlertView.m
//  shenbian
//
//  Created by Leeyan on 11-7-19.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "VSAlertView.h"
#import <QuartzCore/QuartzCore.h>
#import "AppDelegate.h"


#define GROW_SCALE   1.15
#define SHRINK_SCALE 0.80
#define NORMAL_SCALE 1.00

#define GROW_ANIMATION_DURATION    0.10
#define SHRINK_ANIMATION_DURATION  0.10
#define RESTORE_ANIMATION_DURATION 0.10

@interface VSAlertView(PrivateMethods)

- (CATransform3D)_transformForScale:(CGFloat)scale;
- (void)_addAnimationToScale:(CGFloat)scale duration:(NSTimeInterval)duration;

@end


@implementation VSAlertView

- (UIWindow *)mainWindow
{
    return [[UIApplication sharedApplication] keyWindow];
}

- (id)initWithMessage:(NSString *)_message icon:(UIImage *)_icon delegate:(id)_delegate
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
	if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.8;
		delegate = _delegate;
        
        dialogView = [[UIImageView alloc] initWithFrame:CGRectMake(48, 200, 224, 132)];
        dialogView.image = [PNGImage(@"alert-bg") stretchableImageWithLeftCapWidth:40 topCapHeight:20];
        dialogView.userInteractionEnabled = YES;
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(38, 15, 40, 31)];
        iconView.image = _icon;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(90, 10, 100, 40)];
        label.text = _message;
        label.font = FontWithSize(18);
        label.textColor = [UIColor whiteColor];
        label.backgroundColor = [UIColor clearColor];
//        label.textAlignment = UITextAlignmentCenter;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *btnImage = [PNGImage(@"alert-button") stretchableImageWithLeftCapWidth:20 topCapHeight:10];
        [button setBackgroundImage:btnImage forState:UIControlStateNormal];
        [button setFrame:CGRectMake(15, 75, 224 - 30, 36)];
        [button setTitle:@"确认" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(onBtnConfirm) forControlEvents:UIControlEventTouchUpInside];
        
        [dialogView addSubview:label];
        [dialogView addSubview:iconView];
        [dialogView addSubview:button];
        [iconView release];
        [label release];
        
        [self addSubview:dialogView];
	}
	return self;
}

- (void)show
{
    [dialogView.layer removeAllAnimations];
    
    [[self mainWindow] addSubview:self];
    
    _growing = YES;
    [self _addAnimationToScale:GROW_SCALE duration:GROW_ANIMATION_DURATION];
}

- (void)hide
{
    _growing = NO;
    _shrinking = NO;
    [self removeFromSuperview];
}

- (void)onBtnConfirm 
{
	if ([delegate respondsToSelector:@selector(alertConfirmed:)]) {
		[delegate performSelector:@selector(alertConfirmed:) withObject:self];
	}
    [self hide];
}

- (void)dealloc {
    [dialogView release];
	[alertLayer release];
    [super dealloc];
}


#pragma -
#pragma PrivateMethods
- (CATransform3D)_transformForScale:(CGFloat)scale 
{
    if (scale == NORMAL_SCALE) {
        return CATransform3DIdentity;
    } else {
        return CATransform3DScale(CATransform3DIdentity, scale, scale, 1.0);
    }
}

- (void)_addAnimationToScale:(CGFloat)scale duration:(NSTimeInterval)duration 
{
    CABasicAnimation *transformAni = [CABasicAnimation animation];
    transformAni.fromValue = [NSValue valueWithCATransform3D:dialogView.layer.transform];
    transformAni.duration = duration;
    transformAni.delegate = self;
    dialogView.layer.transform = [self _transformForScale:scale];
    [dialogView.layer addAnimation:transformAni forKey:@"transform"];
}


#pragma -
#pragma CAAnimation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) { // Some exception, animation did not finished
        _growing = NO;
        _shrinking = NO;
        dialogView.layer.transform = [self _transformForScale:NORMAL_SCALE];
        [dialogView.layer removeAllAnimations];
    }
    
    if (_growing) {
        _growing = NO;
        _shrinking = YES;
        [self _addAnimationToScale:SHRINK_SCALE duration:SHRINK_ANIMATION_DURATION];
    } else if (_shrinking) {
        _shrinking = NO;
        [self _addAnimationToScale:NORMAL_SCALE duration:RESTORE_ANIMATION_DURATION];
    } else {
        _growing = NO;
        _shrinking = NO;
    }
}

@end
