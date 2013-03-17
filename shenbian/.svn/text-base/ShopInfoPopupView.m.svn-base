//
//  shopPopupView.m
//  shenbian
//
//  Created by MagicYang on 11-1-19.
//  Copyright 2011 personal. All rights reserved.
//

#import "ShopInfoPopupView.h"
#import "SBShopInfo.h"


@implementation ShopInfoPopupView

@synthesize shop;

- (NSString *)extraContent {
	NSMutableString *content = [NSMutableString string];
    NSString *newLine = @"\n\n";
    int i = 0;
    for (NSString *key in [shop.moreInfo allKeys]) {
        NSString *item = [NSString stringWithFormat:@"%@: %@", key, [shop.moreInfo objectForKey:key]];
        [content appendString:item];
        if (i < [[shop.moreInfo allKeys] count]) {
            [content appendString:newLine];
        }
        i++;
    }
	return content;
}

- (ShopInfoPopupView *)initWithShopInfo:(SBShopInfo *)info {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 480)])) {
        self.shop = info;
		self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
		
		imgView = [[UIImageView alloc] initWithFrame:CGRectMake(26, 150, 267, 192)];
		imgView.image = PNGImage(@"shop_popup_bg");
		
		textView = [[UITextView alloc] initWithFrame:CGRectMake(26, 155, 267, 180)];
		textView.text = [self extraContent];
		textView.backgroundColor = [UIColor clearColor];
		textView.textColor = [UIColor whiteColor];
		textView.font = [UIFont boldSystemFontOfSize:15];
		textView.editable = NO;
		textView.showsVerticalScrollIndicator = NO;
		
		UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		[closeBtn setFrame:CGRectMake(imgView.frame.origin.x + imgView.frame.size.width - 20,
									  imgView.frame.origin.y - 7,
									  29, 29)];
		[closeBtn setImage:PNGImage(@"button_close") forState:UIControlStateNormal];
		[closeBtn addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
		
		[self addSubview:imgView];
		[self addSubview:textView];
		[self addSubview:closeBtn];
    }
    return self;
}


- (void)dealloc {
	[shop release];
	[textView release];
	[imgView release];
    [super dealloc];
}

- (void)changeAlpha:(CGFloat)value {
	self.alpha = value;
	imgView.alpha = value;
	textView.alpha = value;
}

- (void)show {
	[[[UIApplication sharedApplication] keyWindow] addSubview:self];
	
	[self changeAlpha:0];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelay:0.3];
	[self changeAlpha:1];
	[UIView commitAnimations];
}

- (void)hide {
	[self changeAlpha:1];
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveLinear];
	[UIView setAnimationDelay:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideAnimationStop)];
	[self changeAlpha:0];
	[UIView commitAnimations];
}

- (void)hideAnimationStop {
	[self removeFromSuperview];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	[super touchesEnded:touches withEvent:event];
	if ([touches count] == 1) {
		[self hide];
	}
}

@end
