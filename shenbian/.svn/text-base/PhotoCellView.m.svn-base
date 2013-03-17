//
//  PhotoCellView.m
//  shenbian
//
//  Created by Leeyan on 11-7-13.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "PhotoCellView.h"

@implementation PhotoCellView

@synthesize preloadingImageView, imageButton, image;


- (id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate photoPressedAction:(SEL)_action andExtra:(id)_extra {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		delegate = [_delegate retain];
		action = _action;
		extra = [_extra retain];
		
		UIImageView *imgView = [[UIImageView alloc] initWithImage:PNGImage(@"image-loading")];
		imgView.frame = vsr((frame.size.width - imgView.width) / 2, (frame.size.height - imgView.height) / 2,
							imgView.width, imgView.height);
		preloadingImageView = imgView;
		
		preloadingImageView.tag = 0;
		
		isLoaded = NO;
		
		[self addSubview:preloadingImageView];
    }
    return self;
}

- (void)setImage:(UIImage *)img {
	[image release];
	image = [img retain];
	[imageButton release];
	imageButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	imageButton.frame = self.frame;
	imageButton.origin = ccp(0, 0);
	[imageButton setImage:img forState:UIControlStateNormal];
	[imageButton addTarget:delegate action:action forControlEvents:UIControlEventTouchUpInside];

	for (UIView* v in self.subviews) {
		v.tag = 100;
	}
	
	if (isLoaded) {
		[self addSubview:imageButton];
	} else {
		[UIView beginAnimations:@"photo flip" context:nil];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		[UIView setAnimationDuration:0.2f];
//		[UIView setAnimationDelay:2.0f];
		[UIView setAnimationDelegate:self];
		[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		
		[UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
							   forView:self cache:NO];
		
		[self addSubview:imageButton];
		
		[UIView commitAnimations];
	}
	
	imageButton.tag = [extra intValue];

}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	for (UIView* v in self.subviews) {
		if (v.tag == 100) {
			[v removeFromSuperview];
		}
	}
	isLoaded = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void)dealloc {
	[preloadingImageView release];
	[imageButton release];
	[image release];
	[extra release];
	
    [super dealloc];
}


@end
