//
//  SearchResultCellView.m
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import "SearchResultCellView.h"
#import "SBShopInfo.h"
#import "SBCoupon.h"
#import "Utility.h"


#define MarginX  10		// margin to top and bottom
#define MarginY  10		// margin to right and left
#define PaddingX 5
#define PaddingY 6

@implementation SearchResultCellView

@synthesize showDistance;
@synthesize showTag;

- (void)setDataModel:(id)model {
	[super setDataModel:model];
	[self setNeedsDisplay];
}	

- (void)drawRect:(CGRect)rect {
	NSInteger currentY = MarginY;
	NSInteger currentX = MarginX;
	UIFont *font16 = FontWithSize(16);
    UIFont *font14 = FontLiteWithSize(14);
    
	SBShopInfo *info = dataModel;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
    CGContextSaveGState(ctx);
    if (isHighlighted) {
		[[Utility colorWithHex:kColorSelected] set];
	}else {
		[[Utility colorWithHex:0xffffff] set];
	}
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
	
    // 分割线
    if (!noSeperator) {
        [PNGImage(@"line_dot") drawInRect:CGRectMake(0, 0, 320, 1)];
    }
    
	// 商户名
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.745 green:0.137 blue:0.173 alpha:1] CGColor]);
	[info.strName drawInRect:CGRectMake(MarginX, MarginY, 280, 20) withFont:font16 lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	currentY += 15;
	
	// Tag
	if ([info firstTag] != nil) {
		currentY += PaddingY;
		NSString *tag = [NSString stringWithFormat:@"[%@]", [info firstTag]];
		UIFont *font = [UIFont systemFontOfSize:14];
		CGSize size = [tag sizeWithFont:font];
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
		[tag drawInRect:CGRectMake(MarginX, currentY - 1, size.width, 15) withFont:font lineBreakMode:UILineBreakModeTailTruncation];
		CGContextRestoreGState(ctx);
		currentX += size.width + PaddingX;
	}
	
	// 人均消费
	if (info.fltAverage > 0) {
		if (![info firstTag]) {
			currentY += PaddingY;
		}
		currentY += 1;
		NSString *average = [NSString stringWithFormat:@"¥%d元", [Utility roundoff:info.fltAverage]];
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
		[average drawInRect:CGRectMake(currentX, currentY, 70, 15) withFont:font14 lineBreakMode:UILineBreakModeTailTruncation];
		CGContextRestoreGState(ctx);
	}
    currentX = MarginX;
	
	if ([info firstTag] != nil || info.fltAverage > 0) {
		currentY += 15;
	}
	
	// 评星
	currentY += PaddingY;
	[Utility drawStars:CGPointMake(currentX, currentY) score:info.intScoreTotal];
    
	// 点评数
	if (info.intCmtCount > 0) {
		NSString *cmtCount = [NSString stringWithFormat:@"%d篇点评", info.intCmtCount];
		CGSize size = [cmtCount sizeWithFont:font14];
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [GrayColor CGColor]);
		[cmtCount drawInRect:CGRectMake(90, currentY, size.width, 15) withFont:font14 lineBreakMode:UILineBreakModeTailTruncation];
		CGContextRestoreGState(ctx);
	}
	currentY += 15;
	
	// 地址
	float addressY = 0;
	if ([info.strAddress length] > 0) {
		currentY += PaddingY;
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [GrayColor CGColor]);
		CGSize size = [info.strAddress sizeWithFont:font14 constrainedToSize:CGSizeMake(250, 15) lineBreakMode:UILineBreakModeTailTruncation];
		[info.strAddress drawInRect:CGRectMake(MarginX, currentY, size.width, size.height) withFont:font14 lineBreakMode:UILineBreakModeTailTruncation];
		addressY = currentY;
		CGContextRestoreGState(ctx);
		currentY += size.height;
	}
	
	// 优惠
	if (info.showCoupon && [info.arrCouponList count] > 0) {
		currentY += PaddingY;
		SBCoupon *coupon = [info.arrCouponList objectAtIndex:0];
		UIImage *typeIcon = PNGImage(@"search_coupon_icon");
		[typeIcon drawInRect:CGRectMake(MarginX, currentY, 31, 16)];
		[coupon.topic drawInRect:CGRectMake(MarginX + 36, currentY, 225, 16) withFont:FontWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
	}
	
    // 距离
	if (showDistance && [info.distance length] > 0) {
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [GrayColor CGColor]);
		if (addressY > 0) {
			[info.distance drawInRect:CGRectMake(250, addressY + 2, 60, 20) withFont:FontLiteWithSize(12) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		} else {
			[info.distance drawInRect:CGRectMake(250, rect.size.height - 25, 60, 20) withFont:FontLiteWithSize(12) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
		}

		CGContextRestoreGState(ctx);
	}
}

+ (NSInteger)heightOfCell:(id)data {
	NSInteger height = 75;
	SBShopInfo *info = data;
	
    if ([info firstTag] != nil) {
        height += PaddingY + 15;
    }
    
	if (info.showCoupon && [info.arrCouponList count] > 0) {
		height += 10 + PaddingY + MarginY;
	}
    
	return height;
}

- (void)dealloc {
    [super dealloc];
}


@end
