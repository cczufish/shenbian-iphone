//
//  CommentCellView.m
//  shenbian
//
//  Created by MagicYang on 10-12-3.
//  Copyright 2010 personal. All rights reserved.
//

#import "CommentCellView.h"
#import "SBComment.h"
#import "Utility.h"
#import "SBUser.h"

#define MarginX 15
#define MarginY 12
#define FIX_HEIGHT 58
#define contentW 267
#define contentH 130
#define contentH_Real 110

#define Ellipsis @"..."

@implementation CommentCellView

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self) {
		NSInteger currentY = 0;
		currentY += MarginY;
		CGRect imgFrame = CGRectMake(MarginX, currentY, 45, 45);
		UIButton *btnAvatar = [[UIButton alloc] initWithFrame:imgFrame];
		[btnAvatar addTarget:self
					  action:@selector(avatarDidTouched)
			forControlEvents:UIControlEventTouchUpInside];
		btnAvatar.backgroundColor = [UIColor clearColor];
		[self addSubview:btnAvatar];
		[btnAvatar release];
	}
	return self;
}

- (void)addIconBtnTarget:(id)atarget sel:(SEL)selector
{
	target = atarget;
	iconBtnSelector = selector;
	
}

- (void)avatarDidTouched {
	SBComment *cmt = dataModel;	
	[target performSelector:iconBtnSelector withObject:cmt.userId];
}

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"userImg"];
	[super setDataModel:model];
	[dataModel addObserver:self forKeyPath:@"userImg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	[self setNeedsDisplay];
}

+ (UIFont *)contentFont {
	return [UIFont systemFontOfSize:14];
}

- (void)drawRect:(CGRect)rect {
	SBComment *cmt = dataModel;
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	NSInteger currentY = MarginY;
    
	CGContextSaveGState(ctx);
    if (isHighlighted) {
		[[Utility colorWithHex:kColorSelected] set];
	}else {
		[[Utility colorWithHex:0xffffff] set];
	}
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
	
	// 用户头像
    UIImage *img = cmt.userImg ? cmt.userImg : DefaultUserImage;
	[SBUser drawUserAvatarWithImage:img atRect:vsr(MarginX, currentY, 45, 45) andIsVIP:NO];
	
	// 用户名称
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[Utility colorWithHex:0x4F3200] CGColor]);
	[cmt.userName drawInRect:CGRectMake(72, currentY, 120, 15) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	
	// 用户评分
    [Utility drawStars:CGPointMake(rect.size.width - 90, currentY) score:cmt.totalScore];
	
	currentY += 15 + 10;
	
	// 用户级别
	[Utility drawUserLevel:cmt.uLevel withRect:CGRectMake(72, currentY, 47, 18)];
	
	// 发布时间
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1] CGColor]);
	[[cmt createdDate] drawInRect:CGRectMake(rect.size.width - 80, currentY - 5, 70, 10) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	
	currentY = FIX_HEIGHT;
	
	// 人均消费
	if (cmt.fltAverage > 0) {
		currentY += 10;
		NSString *cost = [NSString stringWithFormat:@"人均:¥%d", [Utility roundoff:cmt.fltAverage]];
		[cost drawInRect:CGRectMake(MarginX, currentY, 60, 12) withFont:[UIFont systemFontOfSize:13] lineBreakMode:UILineBreakModeTailTruncation];
		currentY += 12;
	}
	
	// 内容
	if ([cmt.content length] > 0) {
		currentY += 10;
        NSString *content = cmt.content;
        if (cmt.isContentTrunc) {
            content = [cmt.content stringByAppendingString:Ellipsis];
        }
		CGSize size = [content sizeWithFont:[CommentCellView contentFont] constrainedToSize:CGSizeMake(contentW, contentH_Real) lineBreakMode:UILineBreakModeTailTruncation];
		[cmt.content drawInRect:CGRectMake(MarginX, currentY, contentW, contentH) withFont:[CommentCellView contentFont] lineBreakMode:UILineBreakModeTailTruncation];
		currentY += size.height + 5;
	}
    
    [PNGImage(@"line_dot") drawInRect:CGRectMake(0, rect.size.height - 1, 320, 1)];
}

- (void)dealloc {
	[dataModel removeObserver:self forKeyPath:@"userImg"];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)data {
	NSInteger height = FIX_HEIGHT;
	SBComment *cmt = data;
	if (cmt.fltAverage > 0) {
		height += 10 + 12;
	}
	
	if ([cmt.content length] > 0) {
		height += 10;
        NSString *content = cmt.content;
        if (cmt.isContentTrunc) {
            content = [cmt.content stringByAppendingString:Ellipsis];
        }
		CGSize size = [content sizeWithFont:[self contentFont] constrainedToSize:CGSizeMake(contentW, contentH) lineBreakMode:UILineBreakModeTailTruncation];
		height += size.height + MarginY;
	}
	
	return height;
}

@end
