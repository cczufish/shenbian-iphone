//
//  VSEffectLabel.m
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSEffectLabel.h"


@implementation VSEffectLabel

@synthesize isEnableGrow, isEnableStroke;
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setEffectGlow:(UIColor*)color offset:(CGSize)offset amount:(CGFloat)amount
{
	isEnableGrow = YES;
	if(glowColor != color){
		[glowColor release];
		glowColor = [color retain];
	}
	glowOffset = offset;
	glowAmount = amount;
	[self setNeedsDisplay];
}

- (void)setEffectStroke:(UIColor*)color width:(CGFloat)awidth
{
	isEnableStroke = YES;
	if (strokeColor != color) {
		[strokeColor release];
		strokeColor = [color retain];
	}
	strokeWidth = awidth;
	[self setNeedsDisplay];
}

- (void)drawTextInRect:(CGRect)rect {
	
	
	if (isEnableGrow) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);
		
		CGContextSetShadow(ctx, glowOffset, glowAmount);
		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		
		CGColorRef color = CGColorCreate(colorSpace, CGColorGetComponents(glowColor.CGColor));
		CGContextSetShadowWithColor(ctx, glowOffset, glowAmount, color);
		
		[super drawTextInRect:rect];
		
		CGColorRelease(color);
		CGColorSpaceRelease(colorSpace);
		CGContextRestoreGState(ctx);		
		return;
	}
	
	if (isEnableStroke) {
		CGContextRef ctx = UIGraphicsGetCurrentContext();
		CGContextSaveGState(ctx);	
		
		CGContextSetLineWidth(ctx, strokeWidth);

		CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
		
		UIColor* backColor = self.textColor;
		[self setValue:strokeColor forKey:@"_color"];
		
		CGColorRef color = CGColorCreate(colorSpace, CGColorGetComponents(strokeColor.CGColor));
		CGContextSetStrokeColorWithColor(ctx, color);
		
		CGContextSetTextDrawingMode(ctx, kCGTextFillStroke);
	
		[super drawTextInRect:rect];
		
		CGContextSetTextDrawingMode(ctx, kCGTextFill);
		[self setValue:backColor forKey:@"_color"];
		[super drawTextInRect:rect];
		
		
		CGColorRelease(color);
		CGColorSpaceRelease(colorSpace);
		CGContextRestoreGState(ctx);		
		return;
	}
	[super drawTextInRect:rect];
	
}



- (void)dealloc {
	VSSafeRelease(glowColor);
	VSSafeRelease(strokeColor);
    [super dealloc];
}


@end
