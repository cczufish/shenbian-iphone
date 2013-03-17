//
//  CommentInfoView.m
//  shenbian
//
//  Created by MagicYang on 10-12-6.
//  Copyright 2010 personal. All rights reserved.
//

#import "CommentInfoView.h"
#import "SBComment.h"
#import "Utility.h"
#import "SBUser.h"


#define MarginX 15
#define MarginY 15
#define contentW 270
#define FixedHeight 130


@implementation CommentInfoView

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

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"userImg"];
	[dataModel removeObserver:self forKeyPath:@"usefulCount"];
	
	[super setDataModel:model];
	
	[dataModel addObserver:self forKeyPath:@"userImg" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	[dataModel addObserver:self forKeyPath:@"usefulCount" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	
	[self setNeedsDisplay];
}

+ (UIFont *)contentFont {
	return [UIFont systemFontOfSize:14];
}

- (void)avatarDidTouched {
	SBComment *cmt = dataModel;	
	[target performSelector:iconBtnSelector withObject:cmt.userId];
 
	
}

- (void)drawRect:(CGRect)rect {
	SBComment *cmt = dataModel;
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	NSInteger currentY = 0;
	currentY += MarginY;
	
	// 背景样式（箭头，颜色）
    NSString *recommend = [NSString stringWithFormat:@"推荐: %@", cmt.recommend];
    UIFont *rmdFont = [UIFont systemFontOfSize:13];
    CGSize rmdSize = [recommend sizeWithFont:rmdFont constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
    
	if (cmt.content && [cmt.content length] > 0) {
		NSInteger bgY = FixedHeight;
		if ([cmt.recommend length] > 0) {
			bgY += rmdSize.height + 10;
		}
		
		NSInteger arcSize = 10;
		CGContextSaveGState(ctx);
		CGContextMoveToPoint(ctx, 0, bgY);
		CGContextAddLineToPoint(ctx, 15, bgY);
		CGContextAddLineToPoint(ctx, 25, bgY - 8);
		CGContextAddLineToPoint(ctx, 35, bgY);
		CGContextAddLineToPoint(ctx, rect.size.width, bgY);
		CGContextAddLineToPoint(ctx, rect.size.width, rect.size.height - arcSize);
		CGContextAddArcToPoint(ctx, rect.size.width, rect.size.height, rect.size.width - arcSize, rect.size.height, arcSize);
		CGContextAddArcToPoint(ctx, 0, rect.size.height, 0, rect.size.height - arcSize, arcSize);
		CGContextClosePath(ctx);
		CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.949 green:0.949 blue:0.949 alpha:1] CGColor]);
		CGContextFillPath(ctx);
		CGContextRestoreGState(ctx);
	}
	
	// 用户头像
    UIImage *img = cmt.userImg ? cmt.userImg : DefaultUserImage;
	[SBUser drawUserAvatarWithImage:img atRect:vsr(MarginX, currentY, 45, 45) andIsVIP:NO];
//	CGContextSaveGState(ctx);
//	CGRect imgFrame = CGRectMake(MarginX, currentY, 45, 45);
//	UIImage *img = cmt.userImg ? [Utility clipImage:cmt.userImg toSize:CGSizeMake(45, 45)] : DefaultUserImage;
//	[Utility clipContext:ctx toRoundedCornerWithRect:imgFrame andRadius:5];
//	[img drawInRect:imgFrame];
//	CGContextRestoreGState(ctx);
	
	// 用户名称
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[Utility colorWithHex:0x4F3200] CGColor]);
	[cmt.userName drawInRect:CGRectMake(72, currentY, 120, 15) withFont:[UIFont systemFontOfSize:14] lineBreakMode:UILineBreakModeTailTruncation];
	CGContextRestoreGState(ctx);
	
	// 发布时间
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.588 green:0.588 blue:0.588 alpha:1] CGColor]);
	[[cmt createdDate] drawInRect:CGRectMake(220, currentY, 70, 10) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
	CGContextRestoreGState(ctx);
	currentY += 15 + 10;
	
	// 用户级别
//	[Utility drawUserLevel:cmt.uLevel withRect:CGRectMake(72, currentY, 52, 20)];
	currentY += 20 + 13;
	
	// 用户评分
    [Utility drawStars:CGPointMake(MarginX, currentY) score:cmt.totalScore];
	
	// 人均消费
	if (cmt.fltAverage > 0) {
		NSString *costLabel = @"人均";
		NSString *costValue = [NSString stringWithFormat:@"¥%d", [Utility roundoff:cmt.fltAverage]];
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
		[costLabel drawInRect:CGRectMake(105, currentY, 30, 10) withFont:FontLiteWithSize(13) lineBreakMode:UILineBreakModeTailTruncation];
		CGContextRestoreGState(ctx);
		CGContextSaveGState(ctx);
		CGContextSetFillColorWithColor(ctx, [[UIColor redColor] CGColor]);
		[costValue drawInRect:CGRectMake(105 + 30, currentY + 1, 80, 10) withFont:FontLiteWithSize(12) lineBreakMode:UILineBreakModeTailTruncation];
		CGContextRestoreGState(ctx);
	}
	
	currentY += 18 + 10;
	
	// 各项评分 & 人均消费
	NSMutableString *scores = [NSMutableString string];
	for (NSString *key in [cmt.detailScore allKeys]) {
		NSString *aScore = [NSString stringWithFormat:@"%@:%0.1f  ", key, [[cmt.detailScore objectForKey:key] floatValue]];
		[scores appendString:aScore];
	}
	[scores drawInRect:CGRectMake(MarginX, currentY, rect.size.width - 30, 12) withFont:[UIFont systemFontOfSize:13] lineBreakMode:UILineBreakModeTailTruncation];
	currentY += 20;
	
	// 推荐
	if ([cmt.recommend length] > 0) {
		[recommend drawInRect:CGRectMake(MarginX, currentY, rmdSize.width, rmdSize.height) withFont:rmdFont lineBreakMode:UILineBreakModeTailTruncation];
		currentY += rmdSize.height + 10;
	}
	
	// 内容
	if ([cmt.content length] > 0) {
		currentY += 12 + 10;
		CGSize size = [cmt.content sizeWithFont:[CommentInfoView contentFont] constrainedToSize:CGSizeMake(contentW, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
		[cmt.content drawInRect:CGRectMake(15, currentY, contentW, size.height) withFont:[CommentInfoView contentFont] lineBreakMode:UILineBreakModeTailTruncation];
		currentY += size.height;
	}
	
    /*
	// 有用
	currentY += 5;
	UIFont *font = [UIFont systemFontOfSize:13];
	
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.871 green:0 blue:0 alpha:1] CGColor]);
	NSString *count = [NSString stringWithFormat:@"%d", cmt.usefulCount];
	CGSize size = [count sizeWithFont:font];
	[count drawInRect:CGRectMake(200, currentY, size.width, size.height) withFont:font];
	CGContextRestoreGState(ctx);
	
	CGContextSaveGState(ctx);
	CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.592 green:0.592 blue:0.592 alpha:1] CGColor]);
	[@"人认为有用" drawInRect:CGRectMake(200 + size.width, currentY, 80, 10) withFont:font];
	CGContextRestoreGState(ctx);
	*/
    
	// Button
//	if (usefulButton) {
//		[usefulButton removeFromSuperview];
//	} else {
//		usefulButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
//		[usefulButton setImage:[UIImage imageWithContentsOfFile:PNGImgPath(@"button_useful")] forState:UIControlStateNormal];
//		[usefulButton addTarget:self action:@selector(useful:) forControlEvents:UIControlEventTouchUpInside];
//	}
//	[usefulButton setFrame:CGRectMake(145, currentY - 3, 45, 22)];
//	[self addSubview:usefulButton];
	
	[super drawRect:rect];
}

- (void)dealloc {
	[dataModel removeObserver:self forKeyPath:@"userImg"];
	[dataModel removeObserver:self forKeyPath:@"usefulCount"];
	[usefulButton release];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)data {
	NSInteger height = FixedHeight;
	SBComment *cmt = data;
	
	if ([cmt.recommend length] > 0) {
        NSString *recommend = [NSString stringWithFormat:@"推荐: %@", cmt.recommend];
        CGSize size = [recommend sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:CGSizeMake(290, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
		height += size.height + 10;
	}
	
	if (cmt.content && [cmt.content length] > 0) {
		height += 20;	// 背景箭头导致此处比一般间隔距离多10px
		height += 10;
		CGSize size = [cmt.content sizeWithFont:[self contentFont] constrainedToSize:CGSizeMake(contentW, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
		height += size.height;
	}
	
	height += MarginY;
	
	return height;
}

- (void)useful:(id)sender {
//	[Notifier postNotificationName:kCommentUseful object:nil];
}


@end
