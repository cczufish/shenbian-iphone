//
//  SearchCellView.m
//  shenbian
//
//  Created by MagicYang on 5/5/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SearchCellView.h"
#import "SBShopInfo.h"
#import "SBSuggestion.h"
#import "Utility.h"


#define PaddingX 10


@implementation SearchShopCellView

- (void)setDataModel:(id)model 
{
    [super setDataModel:model];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    SBSuggestShop *shop = dataModel;
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    if (isHighlighted) {
		[[Utility colorWithHex:kColorSelected] set];
	}else {
		[[Utility colorWithHex:0xffffff] set];
	}
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
    
    [shop.shopName drawInRect:CGRectMake(PaddingX, 10, 200, 20) withFont:FontLiteWithSize(16)];
    [[UIColor grayColor] set];
    
    [shop.shopAddress drawInRect:CGRectMake(PaddingX, 30, 250, 20) withFont:FontLiteWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
    if ([shop.distance length] > 0) {
        [shop.distance drawInRect:CGRectMake(250, 10, 60, 15) withFont:[UIFont systemFontOfSize:12] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
    }
    
    if (!noSeperator) {
        [PNGImage(@"line_dot") drawInRect:CGRectMake(0, rect.size.height - 1, 320, 1)];
    }
}

+ (NSInteger)heightOfCell:(id)data
{
    return 57;
}

@end



@implementation SearchSuggestCellView

@synthesize icon;


- (void)dealloc
{
    [icon release];
    [super dealloc];
}

- (void)setDataModel:(id)model
{
    [super setDataModel:model];
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ctx);
    if (isHighlighted) {
		[[Utility colorWithHex:kColorSelected] set];
	}else {
		[[Utility colorWithHex:0xffffff] set];
	}
    CGContextFillRect(ctx, rect);
    CGContextRestoreGState(ctx);
    
    NSInteger x = PaddingX;
    if (icon) {
        [icon drawInRect:CGRectMake(x, (rect.size.height - 12) / 2, 12, 12)];
        x += 12 + 10;
    }
    
    if ([dataModel isKindOfClass:[SBSuggestKeyword class]]) {
        SBSuggestKeyword *sug = dataModel;
        [sug.keyword drawInRect:CGRectMake(x, 10, 200, 20) withFont:FontLiteWithSize(16)];
        if (sug.count > 0) {
            NSString *count = [NSString stringWithFormat:@"约%d家", sug.count];
            [count drawInRect:CGRectMake(220, 10, 92, 15) withFont:[UIFont systemFontOfSize:13] lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
        }
    } else {
        SBSuggestShop *shop = dataModel;
        [shop.shopName drawInRect:CGRectMake(x, 10, 200, 20) withFont:FontLiteWithSize(16) lineBreakMode:UILineBreakModeTailTruncation];
    }
    
    if (!noSeperator) {
        [PNGImage(@"line_dot") drawInRect:CGRectMake(0, rect.size.height - 1, 320, 1)];
    }
}

+ (NSInteger)heightOfCell:(id)data
{
    return 35;
}


@end