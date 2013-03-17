//
//  LoadingView.m
//  shenbian
//
//  Created by MagicYang on 10-11-24.
//  Copyright 2010 personal. All rights reserved.
//

#import "LoadingView.h"


@implementation LoadingView

- (id)initNoIconViewWithFrame:(CGRect)frame andMessage:(NSString *)msg
{
    if ((self = [super initWithFrame:frame])) {
		self.frame = CGRectMake(90, 150, 140, 100);
		
		indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
		indicatorView.frame = vsrc(70, 40, 20, 20);// CGRectMake(20, 5, 20, 20);
		
        icon = nil;
        
		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 140, 50)];
		label.font = [UIFont systemFontOfSize:14];
		label.textColor = [UIColor grayColor];
        label.textAlignment = UITextAlignmentCenter;
		label.text = msg ? msg : @"正在载入数据...";
		label.backgroundColor = [UIColor clearColor];
        
		[self addSubview:indicatorView];
        [self addSubview:icon];
		[self addSubview:label];
        
		self.backgroundColor = [UIColor clearColor];
		
		[indicatorView startAnimating];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame andMessage:(NSString *)msg
{
	if (0 == memcmp(&frame, &CGSizeZero, sizeof(CGRect))) {
		frame = CGRectMake(0, 150, 320, 100);
	}
	
	if (self = [self initJumpLoadingViewWithFrame:frame]) {
		
	}
	return self;
	
//    if ((self = [super initWithFrame:frame])) {
//		self.frame = CGRectMake(100, 150, 140, 100);
//		
//		indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//		indicatorView.frame = CGRectMake(20, 5, 20, 20);
//		
//        icon = [[UIImageView alloc] initWithFrame:CGRectMake(45, 0, 47, 47)]; // 62x63
//        icon.image = PNGImage(@"image-loading");
//        
//		label = [[UILabel alloc] initWithFrame:CGRectMake(0, 40, 140, 50)];
//		label.font = [UIFont systemFontOfSize:14];
//		label.textColor = [UIColor grayColor];
//        label.textAlignment = UITextAlignmentCenter;
//		label.text = msg ? msg : @"正在载入数据...";
//		label.backgroundColor = [UIColor clearColor];
//        
//		[self addSubview:indicatorView];
//        [self addSubview:icon];
//		[self addSubview:label];
//        
//		self.backgroundColor = [UIColor clearColor];
//		
//		[indicatorView startAnimating];
//    }
//    return self;
}

- (id)initJumpLoadingViewWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		UIImage *loadingIcon = PNGImage(@"loading");
		icon = [[UIImageView alloc] initWithImage:loadingIcon];
		icon.frame = vsrc(self.size.width / 2, (self.size.height - loadingIcon.size.height) / 2 - 15,
						  loadingIcon.size.width, loadingIcon.size.height);
		[self addSubview:icon];
		
		// shadow
		UIImage *shadowImage = PNGImage(@"loading-shadow");
		UIImageView *shadowView = [[UIImageView alloc] initWithImage:shadowImage];
		shadowView.frame = vsrc(self.size.width / 2, (self.size.height - loadingIcon.size.height) / 2 + 15,
								shadowImage.size.width, shadowImage.size.height);
		[self addSubview:shadowView];
		[shadowView release];
		
		[UIView beginAnimations:@"jump loading" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
		[UIView setAnimationDuration:0.5f];
		[UIView setAnimationRepeatAutoreverses:YES];
		[UIView setAnimationRepeatCount:9999.9f];
		
		icon.top = icon.top - icon.size.height * .3f;
		
		[UIView commitAnimations];
	}
	return self;
}

- (void)removeFromSuperview {
	[super removeFromSuperview];
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touchbegan %@", [self nextResponder]);
//	[[self nextResponder] touchesBegan:touches withEvent:event];
//}
//
//- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touchended %@", [self nextResponder]);
//	[[self nextResponder] touchesEnded:touches withEvent:event];
//}
//
//- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touchmoved %@", [self nextResponder]);
//	[[self nextResponder] touchesMoved:touches withEvent:event];
//}
//
//- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
//	NSLog(@"touchcanceled %@", [self nextResponder]);
//	[[self nextResponder] touchesCancelled:touches withEvent:event];
//}

- (BOOL)canBecomeFirstResponder {
	return NO;
}

- (void)dealloc {
	[indicatorView stopAnimating];
	[indicatorView release];
	[label release];
    [icon release];
    [super dealloc];
}

- (void)setMessage:(NSString *)msg
{
    label.text = msg;
}

@end
