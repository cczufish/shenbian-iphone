//
//  SBLoadingView.m
//  shenbian
//
//  Created by MagicYang on 11-01-24.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBLoadingView.h"
#import "Util.h"
#import <QuartzCore/QuartzCore.h>


#define degreesToRadians(x) (M_PI * x / 180.0)
#define BoarderWidth  160
#define BoarderHeight 160

@implementation SBLoadingView

@synthesize loading;


- (SBLoadingView *)initWithContainer:(UIView*)v {
	return [self initWithContainer:v andLoadingText:@"加载中..."];
}

- (SBLoadingView *)initWithContainer:(UIView *)v andLoadingText:(NSString *)loadingText {
    self = [super init];
	if(self) {
		container = [v retain];
		
		loading = [[UIImageView alloc] initWithFrame:CGRectMake(160, 160, BoarderWidth, BoarderHeight)];
		loading.image = PNGImage(@"loading_bg");
		
		spinner = [[UIImageView alloc] initWithFrame:CGRectMake((BoarderWidth - 70) / 2, (BoarderHeight - 65) / 2, 70, 65)];
		NSMutableArray *images = [NSMutableArray array];
		for (int i = 0; i < 24; i++) {
			NSString *imageName = [NSString stringWithFormat:@"loading_load%d", i + 1];
			[images addObject:PNGImage(imageName)];
		}
		spinner.animationImages = images;
		
		promtLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 120, 140, 20)];
		promtLabel.text = loadingText;
		promtLabel.textAlignment = UITextAlignmentCenter;
		promtLabel.font = [UIFont boldSystemFontOfSize:16];
		promtLabel.textColor = [UIColor whiteColor];
		promtLabel.backgroundColor = [UIColor clearColor];
		
		[loading addSubview:spinner];
		[loading addSubview:promtLabel];
	}
	return self;
}

- (void)dealloc {
    [spinner release];
	[promtLabel release];
	[loading release];
	[container release];
    [super dealloc];
}

- (void)show {
	[spinner startAnimating];
	CGRect rect = loading.frame;

	if(container != nil) {
		loading.frame = CGRectMake((container.frame.size.width - rect.size.width)/2, 
								   (container.frame.size.height - rect.size.height)/2, 
								   rect.size.width, rect.size.height);

		[container addSubview:loading];
		[container bringSubviewToFront:loading];
		
		CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		basicAnimation.duration = 0.2;
		basicAnimation.fromValue = [NSNumber numberWithFloat:1.2];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
		basicAnimation.toValue = [NSNumber numberWithFloat:1];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
		[loading.layer addAnimation:basicAnimation forKey:@"showLoading"];
	} else {
		UIApplication *app = [UIApplication sharedApplication];
		UIWindow *frontest = [[app windows] objectAtIndex:0];
		
		loading.frame = CGRectMake(0, 0, 160, 160);
		loading.center = frontest.center;
		[frontest addSubview:loading];

		CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
		basicAnimation.duration = 0.1;
		basicAnimation.fromValue = [NSNumber numberWithFloat:1.5];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.5, 1.5, 1)];
		basicAnimation.toValue = [NSNumber numberWithFloat:1];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
		[loading.layer addAnimation:basicAnimation forKey:@"showLoading"];
	}
}



- (void)hideWithStatus:(BOOL)successed andText:(NSString *)txt {
	[spinner stopAnimating];
	
	promtLabel.text = txt;
	NSString *imgName = successed ? @"loading_success" : @"loading_failed";
	UIImage *img = PNGImage(imgName);
	CGRect rect = CGRectMake((loading.frame.size.width - img.size.width)/2, 
								   (loading.frame.size.height - [img size].height)/2,
								   [img size].width, 
								   [img size].height);
	UIImageView *imgView =[[UIImageView alloc] initWithFrame:rect];
	imgView.image = img;
	[loading addSubview:imgView];
	[imgView release];
	
	// 消失动画
	CABasicAnimation *basicAnimationForScale = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
	basicAnimationForScale.fromValue = [NSNumber numberWithFloat:1.0];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
	basicAnimationForScale.toValue = [NSNumber numberWithFloat:0.7];//[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1)];
	
	CABasicAnimation *basicAnimationForOpacity = [CABasicAnimation animationWithKeyPath:@"opacity"];
	basicAnimationForOpacity.fromValue = [NSNumber numberWithFloat:1.0];
	basicAnimationForOpacity.toValue = [NSNumber numberWithFloat:0];
	
	CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
	animationGroup.duration = 0.2;
	animationGroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	animationGroup.animations = [NSArray arrayWithObjects:basicAnimationForScale,basicAnimationForOpacity,nil];
	animationGroup.beginTime = CACurrentMediaTime() + 0.5;
	animationGroup.delegate = self;
	animationGroup.removedOnCompletion = NO;
	animationGroup.fillMode = kCAFillModeForwards;
	
	[loading.layer addAnimation:animationGroup forKey:@"loading"];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
	if([theAnimation isKindOfClass:[CAAnimationGroup class]]) {
		loading.layer.opacity = 0;
		[loading.layer setValue:[NSNumber numberWithFloat:0.7] forKey:@"transform.scale"];
		[loading.layer removeAllAnimations];
		
		if(loading && [loading superview]) {
			[loading removeFromSuperview];
		}
	}
}

@end
