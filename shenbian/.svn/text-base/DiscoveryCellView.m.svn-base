//
//  DiscoveryCellView.m
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "DiscoveryCellView.h"
#import "SBCommodityList.h"
#import "Utility.h"
#import "SBUser.h"

//#define DefaultShopImage [T imageNamed:@"shop_default.png"]
#define DefaultShopImage [T imageNamed:@"image-loading.png"]

@implementation DiscoveryCellView
@synthesize isLatestTab, isAlbumStyle;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        //add user icon button
        CGRect imgFrame = CGRectMake(10, 10, 36, 36);
        UIButton* btn = [[UIButton alloc] initWithFrame:imgFrame];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self 
                action:@selector(onUserIconClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn release];
    }
    return self;
}

- (void)onUserIconClicked:(id)sender
{
    UIViewController* vc =  self.viewController;
    if ([vc respondsToSelector:@selector(onCellViewUserIconClicked:)]) {
        [vc performSelector:@selector(onCellViewUserIconClicked:) withObject:dataModel];
    }
}

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"imgUserIcon"];
	[dataModel removeObserver:self forKeyPath:@"imgCover"];
	[super setDataModel:model];
	[dataModel addObserver:self forKeyPath:@"imgUserIcon" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	[dataModel addObserver:self forKeyPath:@"imgCover" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	SBCommodity* amodel = model;
	[amodel loadImageResource];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
	SBCommodity* model = dataModel;
	
	CGFloat offsetX;
	NSInteger ln = 0;	//	一个标记变量，在一行中出现的字段个数，有时需要根据个数来画分割线。
	CGContextRef ctx = UIGraphicsGetCurrentContext();	

	//draw background
	if (isHighlighted) {
		[[Utility colorWithHex:kColorSelected] set];
	}else {
		[[Utility colorWithHex:0xffffff] set];
	}
	CGContextFillRect(ctx, rect);
	
	
	//user icon
	UIImage *img = model.imgUserIcon ? model.imgUserIcon : DefaultUserImage;
	[SBUser drawUserAvatarWithImage:img atRect:vsr(10, 10, 36, 36) andIsVIP:model.isVIP];
	
	//user name
	[[Utility colorWithHex:0x9e754c] set];
	[model.uname drawInRect:CGRectMake(3, 52, 50, 15) withFont:FontWithSize(13) 
			  lineBreakMode:UILineBreakModeTailTruncation
				  alignment:UITextAlignmentCenter];
	
	//cover bg
	int imgHeight;
	if (model.cimageSize.width == 0) {
		imgHeight = 60;
	}else {
		imgHeight = 105 *  model.cimageSize.height / model.cimageSize.width;	
	}

	 
	CGRect coverRect = CGRectMake(58, 13, 105, imgHeight);
	[[[T imageNamed:@"commodity_cover.png"] stretchableImageWithLeftCapWidth:15 topCapHeight:15] drawInRect:coverRect];

	// commodity image
    CGSize coverImgSize = CGSizeMake((105 - 10) * 2, (imgHeight -10) * 2); // 需要画封面（或默认封面）的size
//    CGSize defaultCoverSize = CGSizeMake(100, 76); // 默认封面的size
    
    if (model.imgCover) {
        UIImage *cimg = [Utility clipImage:model.imgCover toSize:coverImgSize];
        [cimg drawInRect:CGRectInset(coverRect, 5, 5)];
    } else {
        // 默认封面居中显示，不放缩
//        CGFloat x = (105 - 10 - 100) / 2 + coverRect.origin.x;
//        CGFloat y = (imgHeight - 10 - 76) + coverRect.origin.y;
//        CGRect defaultrect = CGRectMake(x, y, 100, 76);
//        [DefaultShopImage drawInRect:CGRectInset(defaultrect, 5, 5)];
		[[Utility colorWithHex:0xefefef] set];
		CGContextFillRect(ctx, CGRectInset(coverRect, 5, 5));
        CGFloat x = (105 - 31) / 2 + coverRect.origin.x;
        CGFloat y = (imgHeight - 32) / 2 + coverRect.origin.y;
        CGRect defaultrect = CGRectMake(x, y, 31, 32);
        [DefaultShopImage drawInRect:CGRectInset(defaultrect, 5, 5)];
    }
	
	// conner img 切角
	UIImage* connerImg;
	if (isHighlighted) {
		connerImg = [UIImage imageNamed:@"commodity_cover_conner_h.png"];
	} else {
		connerImg = [UIImage imageNamed:@"commodity_cover_conner.png"];
	}
	[connerImg drawAtPoint:ccp(144,imgHeight - 6)];
    
    if (!isAlbumStyle) {
        [Utility drawVote:model.cvote at:ccp(55,10) inContext:ctx];
    }
	
	// commodity name and shop name
	int textMaxWidth = 144;
	CGSize maximumSize = CGSizeMake(textMaxWidth, 9999);
	NSString* mergedName = [NSString stringWithFormat:@"%@@%@",
							model.cname,model.sname];
	
	CGSize titleRect = [mergedName sizeWithFont:FontLiteWithSize(16)
							   constrainedToSize:maximumSize 
								   lineBreakMode:UILineBreakModeClip];
	

	[[Utility colorWithHex:0x000000] set];
	[mergedName drawInRect:CGRectMake(172, 18, textMaxWidth, titleRect.height) withFont:FontLiteWithSize(16) lineBreakMode:UILineBreakModeClip ];
	
//	[[Utility colorWithHex:0x858585] set];

	[GrayColor set];
	
    CGSize detailRect = [model.cdetail sizeWithFont:FontLiteWithSize(14)
                              constrainedToSize:maximumSize 
                                  lineBreakMode:UILineBreakModeTailTruncation];
    int detailMaxHeight = 31;
    detailMaxHeight = MIN(detailRect.height, detailMaxHeight);
    detailMaxHeight = MAX(10, detailMaxHeight);
    
	[model.cdetail drawInRect:CGRectMake(172, 18 + titleRect.height + 11, textMaxWidth, detailMaxHeight) withFont:FontLiteWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];

	int imageBottom = imgHeight + 11 ;
	int txtBottom = 18 + titleRect.height + 11 + detailMaxHeight;
	
	// 31  equls `distance` height
	int distanceLabelYpos;
	if (imageBottom - txtBottom > 31) {
		distanceLabelYpos = imageBottom - 15;
	}else {
		distanceLabelYpos = txtBottom + 10;
	}
	
//	[[Utility colorWithHex:0x717171] set];
    
    NSString* bottomRightInfo;
    if (isLatestTab || isAlbumStyle) {
        bottomRightInfo = [Utility userFriendlyTimeFromUTC:[model.createdAt longLongValue]]; 
    } else {
        //定位失败 return 0
        if ([model.distance length] == 0) {
            bottomRightInfo = nil;
        }else{
            bottomRightInfo = model.distance;
        }   
    }
	[bottomRightInfo drawInRect:CGRectMake(210, distanceLabelYpos, 100, 12) withFont:FontLiteWithSize(12) lineBreakMode:UILineBreakModeClip alignment:UITextAlignmentRight];
    
	ln = 0;
    // 评论数
	offsetX = 172.0f;
    if ([model.ccmt intValue] > 0) {
		[PNGImage(@"comment") drawAtPoint:ccp(offsetX, distanceLabelYpos + 2)];
		offsetX += 15;
		CGSize commentSize = [model.ccmt sizeWithFont:FontLiteWithSize(12)];
        [model.ccmt drawInRect:CGRectMake(offsetX, distanceLabelYpos, commentSize.width, commentSize.height)
                      withFont:FontLiteWithSize(12)
                 lineBreakMode:UILineBreakModeTailTruncation];
		offsetX += commentSize.width + 6;
		ln++;
    }
    
//*
	//	喜欢数
	if ([model.like intValue] > 0) {
		if (ln > 0) {
			//	画分割线
			CGContextMoveToPoint(ctx, offsetX, distanceLabelYpos + 1);
			CGContextAddLineToPoint(ctx, offsetX, distanceLabelYpos + 10);
			CGContextStrokePath(ctx);
			offsetX += 6;
		}

		[PNGImage(@"xin") drawAtPoint:ccp(offsetX, distanceLabelYpos + 2)];
		offsetX += 15;
		CGSize likeSize = [model.like sizeWithFont:FontLiteWithSize(12)];
		[model.like drawInRect:vsr(offsetX, distanceLabelYpos, likeSize.width, likeSize.height) 
					  withFont:FontLiteWithSize(12)
				 lineBreakMode:UILineBreakModeTailTruncation];
//		ln++;
	}
//*/
	
	//final height = here
//	if (!isHighlighted) {
//		[PNGImage(@"dot_line_320") drawAtPoint:ccp(0,distanceLabelYpos + 31)];
//	}
	[PNGImage(@"dot_line_320") drawAtPoint:ccp(0, rect.size.height - 1)];
}


- (void)dealloc {
	[dataModel removeObserver:self forKeyPath:@"imgUserIcon"];
	[dataModel removeObserver:self forKeyPath:@"imgCover"];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)amodel
{
	SBCommodity* model = amodel;
	int imgHeight;
	if (model.cimageSize.width == 0) {
		imgHeight = 60;
	}else {
		imgHeight = 105 *  model.cimageSize.height / model.cimageSize.width;	
	}
	int imageBottom = imgHeight + 11 ;

	//text
	int textMaxWidth = 144;
	CGSize maximumSize = CGSizeMake(textMaxWidth, 9999);
	NSString* mergedName = [NSString stringWithFormat:@"%@@%@",
							model.cname,model.sname];
	
	CGSize titleRect = [mergedName sizeWithFont:FontWithSize(16) 
							  constrainedToSize:maximumSize 
								  lineBreakMode:UILineBreakModeClip];
	
    CGSize detailRect = [model.cdetail sizeWithFont:FontWithSize(14) 
                               constrainedToSize:maximumSize 
                                   lineBreakMode:UILineBreakModeTailTruncation];
    int detailMaxHeight = 31;
    detailMaxHeight = MIN(detailRect.height, detailMaxHeight);
    detailMaxHeight = MAX(10, detailMaxHeight);
    
    
	int txtBottom = 18 + titleRect.height + 11 + detailMaxHeight;
	
	// 31  equls `distance` height
	int distanceLabelYpos;
	if (imageBottom - txtBottom > 31) {
		distanceLabelYpos = imageBottom - 15;
	} else {
		distanceLabelYpos = txtBottom + 10;
	}
	
	return distanceLabelYpos + 33 ;
}

@end
