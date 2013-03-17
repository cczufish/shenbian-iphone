//
//  SBButton.m
//  shenbian
//
//  Created by MagicYang on 11-1-13.
//  Copyright 2011 personal. All rights reserved.
//

#import "SBButton.h"


#define TextColorNormal [UIColor blackColor]
#define TextColorHighlighted [UIColor blueColor]
#define BackgroundColorNormal [UIColor whiteColor]
#define BackgroundColorHighlighted [UIColor whiteColor]

@implementation SBButton

@synthesize title, titleFont, titleAlignment;
@synthesize delegate, action;
@synthesize normalImage, highlightImage;


- (id)initWithFrame:(CGRect)frame {
	if (self = [super initWithFrame:frame]) {
		self.backgroundColor = [UIColor clearColor];
		_titleColorDict = [NSMutableDictionary new];
		_backgroundColorDict = [NSMutableDictionary new];
		
		// Set default color
		[_titleColorDict setObject:TextColorNormal forKey:NUM(UIControlStateNormal)];
		[_titleColorDict setObject:TextColorHighlighted forKey:NUM(UIControlStateHighlighted)];
		
		[_backgroundColorDict setObject:BackgroundColorNormal forKey:NUM(UIControlStateNormal)];
		[_backgroundColorDict setObject:BackgroundColorHighlighted forKey:NUM(UIControlStateHighlighted)];
		
		self.titleFont = FontWithSize(14);
		self.titleAlignment = UITextAlignmentCenter;
	}
	return self;
}

- (void)dealloc {
	[normalImage release];
	[highlightImage release];
	[_titleColorDict release];
	[_backgroundColorDict release];
	[title release];
	[titleFont release];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	[super drawRect:rect];
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	if (self.highlightImage || self.normalImage) {	// Background image
		CGContextSaveGState(ctx);
		CGContextSetShouldAntialias(ctx, true);
		CGContextSetAllowsAntialiasing(ctx, true);
		UIImage *img = _state == UIControlStateHighlighted ? self.highlightImage : self.normalImage;
		[img drawInRect:rect];
		CGContextSetAllowsAntialiasing(ctx, false);
		CGContextRestoreGState(ctx);
	} else {// If no background image, render color
		CGContextSaveGState(ctx);
		CGColorRef color = [(UIColor *)[_backgroundColorDict objectForKey:NUM(_state)] CGColor];
		CGContextSetFillColorWithColor(ctx, color);
		CGContextFillRect(ctx, rect);
		CGContextRestoreGState(ctx);
	}
	
	// Title
	if (self.title) {
		CGContextSaveGState(ctx);
		CGColorRef color = [(UIColor *)[_titleColorDict objectForKey:NUM(_state)] CGColor];
		CGContextSetFillColorWithColor(ctx, color);
		[title drawInRect:rect withFont:titleFont lineBreakMode:UILineBreakModeTailTruncation alignment:titleAlignment];
		CGContextRestoreGState(ctx);
	}
}

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state {
	[_titleColorDict setObject:color forKey:NUM(state)];
}

- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state {
	[_backgroundColorDict setObject:color forKey:NUM(state)];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state {
	if (state == UIControlStateHighlighted) {
		self.highlightImage = image;
	} else {
		self.normalImage = image;
	}
}

- (void)addTarget:(id)target action:(SEL)act forControlEvents:(UIControlEvents)controlEvents {
	self.delegate = target;
	self.action = act;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = UIControlStateHighlighted;
	[self setNeedsDisplay];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = UIControlStateNormal;
	if ([delegate respondsToSelector:action]) {
		[delegate performSelector:action withObject:self];
	}
	[self setNeedsDisplay];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = UIControlStateNormal;
	[self setNeedsDisplay];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
	_state = UIControlStateNormal;
	[self setNeedsDisplay];
}

@end