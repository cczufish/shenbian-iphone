//
//  CouponInfoCellView.m
//  shenbian
//
//  Created by MagicYang on 10-12-22.
//  Copyright 2010 personal. All rights reserved.
//

#import "CouponInfoCellView.h"
#import "SBCoupon.h"
#import "Utility.h"
#import "Notifications.h"


#define MarginX 10
#define MarginY 20


@implementation CouponInfoCellView

@synthesize button;

- (void)setDataModel:(id)model {
    [super setDataModel:model];
    
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    // Override from super class to remove setNeedsDisplay when tap cell
	isHighlighted = highlighted;
}

- (void)drawRect:(CGRect)rect {
	NSInteger currentY = MarginY;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	SBCoupon *coupon = dataModel;

	// 白色底
	CGContextSaveGState(ctx);
	[Utility clipContext:ctx toRoundedCornerWithRect:CGRectMake(0, 0, rect.size.width, rect.size.height + 10) andRadius:10];
	CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
	CGContextFillRect(ctx, rect);
	CGContextRestoreGState(ctx);
	
	// 标题
	UIFont *topicFont = FontWithSize(18);
//	CGSize size = [coupon.topic sizeWithFont:topicFont constrainedToSize:CGSizeMake(200, 40) lineBreakMode:UILineBreakModeTailTruncation];
	[coupon.topic drawInRect:CGRectMake(MarginX, currentY, 200, 40) withFont:topicFont lineBreakMode:UILineBreakModeTailTruncation];
	
	// 标签贴图
	UIImage *couponLogo = PNGImage(@"coupon_logo");
	[couponLogo drawInRect:CGRectMake(200, -2, 100, 85)];
	
	currentY += 40 + 10;
	// <优惠详情:>
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
	[@"优惠详情:" drawInRect:CGRectMake(MarginX, currentY, 220, 20) withFont:FontWithSize(16) lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	currentY += 20 + 10;
	
	// 内容
	UIFont *contentFont = [UIFont systemFontOfSize:14];
	CGSize size = [coupon.content sizeWithFont:contentFont constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
	CGFloat h = coupon.showAll ? size.height : MIN(size.height, 120);
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
	[coupon.content drawInRect:CGRectMake(MarginX, currentY - 7, size.width, h) withFont:contentFont lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	
	currentY += h;
	
	if (size.height > 130) {
		if (button) {
			[button removeFromSuperview];
		}
        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *img = PNGImage(@"button_couponinfo_down");
        img = coupon.showAll ? [Utility reverseImage:img] : img;
        [button setImage:img forState:UIControlStateNormal];
		[button setFrame:CGRectMake(265, currentY - 15, 26, 26)];
		[button addTarget:self action:@selector(showAll:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:button];
	}
}

+ (NSInteger)heightOfCell:(id)data {
	NSInteger height = MarginY + 40 + 10 + 20 + 10;
	SBCoupon *coupon = (SBCoupon *)data;
	
	UIFont *contentFont = [UIFont systemFontOfSize:14];
	CGSize size = [coupon.content sizeWithFont:contentFont constrainedToSize:CGSizeMake(280, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
	height += coupon.showAll ? size.height : MIN(size.height, 120);
	height += MarginY;
	
	if (size.height <= 130) {
		height -= 10;
	}
	
	return height;
}

- (void)dealloc {
	[button release];
	[super dealloc];
}

- (void)showAll:(id)sender {
    SBCoupon *coupon = dataModel;
    coupon.showAll = !coupon.showAll;
	[Notifier postNotificationName:kCouponShowAllInfo 
                            object:self
                          userInfo:[NSDictionary dictionaryWithObject:coupon.couponId forKey:@"id"]];
}

@end