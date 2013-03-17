//
//  BadgeInfoView.m
//  shenbian
//
//  Created by MagicYang on 5/19/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "BadgeInfoView.h"
#import "SBBadge.h"
#import "UIViewAdditions.h"


#define MarginY 15

@interface BadgeInfoView ()

- (void)setPromoButtonTitle:(NSInteger)useableCount;

@end


@implementation BadgeInfoView
@synthesize delegate;

- (id)initWithBadge:(SBBadge *)aBadge andDelegate:(id)del
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = del;
        badge = [aBadge retain];
        self.width  = [self viewSize].width;
        self.height = [self viewSize].height;
		self.backgroundColor = [UIColor whiteColor];
		[badge addObserver:self forKeyPath:@"useableCount"
				   options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld 
				   context:nil];
    }
    return self;
}

- (void)dealloc
{
	[badge removeObserver:self forKeyPath:@"useableCount"];
    [badge release];
	[promoButton release];
    [super dealloc];
}

- (void)drawRect:(CGRect)rect
{
    NSInteger currentY = 0;
    CGSize descSize = [badge.description sizeWithFont:FontWithSize(14) constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // Image
    if (badge.picImage) {
        [badge.picImage drawInRect:CGRectMake(56, 29, 205, 205)];
    }
    currentY = 257;
    
    // Name
    [badge.name drawInRect:CGRectMake(20, currentY, 280, 25) withFont:FontWithSize(18) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
    currentY = 290;
    
    // Description
	if (descSize.height < 28) {
		[badge.description drawInRect:vsr(30, currentY, 260, descSize.height) withFont:FontWithSize(14) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentCenter];
	} else {
		[badge.description drawInRect:CGRectMake(30, currentY, descSize.width, descSize.height) withFont:FontWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
	}
    currentY += descSize.height + MarginY;
    
    // Promotion
    if (badge.isPromo) {
        CGContextSaveGState(ctx);
        [[UIColor colorWithRed:0.941 green:0.933 blue:0.878 alpha:1] set];
//		[[UIColor grayColor] set];
        CGContextFillRect(ctx, CGRectMake(0, currentY, 320, 290 + 100 + MarginY));
        CGContextRestoreGState(ctx);
        
        UIImage *icon     = PNGImage(@"badge_promotion");
        UIImage *shadow   = PNGImage(@"badge_list_seperate_line");
        UIImage *dotline1 = PNGImage(@"badge_dotline_1");
        UIImage *dotline2 = PNGImage(@"badge_dotline_2");
        
        [shadow drawInRect:CGRectMake(0, currentY, 320, 14)];

		//	promo button
		currentY += MarginY;
		
		promoButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
		
		[promoButton setBackgroundImage:PNGImage(@"promobutton-normal") forState:UIControlStateNormal];
		[promoButton setBackgroundImage:PNGImage(@"promobutton-pressed") forState:UIControlStateHighlighted];
		[promoButton setBackgroundImage:PNGImage(@"promobutton-disabled") forState:UIControlStateDisabled];
		
		[promoButton setTitle:@"徽章使用完毕" forState:UIControlStateDisabled];
		
		[promoButton setTitleColor:VSColorRGB(0xffffff) forState:UIControlStateNormal];
		[promoButton setTitleColor:VSColorRGB(0xcbcbcb) forState:UIControlStateDisabled];

		promoButton.frame = vsrc(160, currentY + 33 / 2, 200, 33);
		
//		badge.useableCount = 100;
		[self setPromoButtonTitle:badge.useableCount];
		promoButton.titleLabel.font = FontWithSize(17);
		promoButton.titleLabel.textAlignment = UITextAlignmentCenter;
		[promoButton addTarget:self.delegate action:@selector(useBadgeTouched:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:promoButton];
		
		currentY += promoButton.size.height + MarginY;
		
        [dotline1 drawInRect:vsrc(160, currentY, 287, 2)];
        [icon drawInRect:vsrc(25, currentY, 35, 29)];
        
        currentY += MarginY;
        
        CGSize promSize = [badge.promoInfo sizeWithFont:FontWithSize(14) constrainedToSize:CGSizeMake(260, MAXFLOAT)];
        
        [badge.promoInfo drawInRect:CGRectMake(30, currentY, promSize.width, promSize.height) withFont:FontWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
		
		currentY += promSize.height + MarginY;
        [dotline2 drawInRect:CGRectMake(16, currentY, 287, 2)];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if (object == badge && [keyPath isEqualToString:@"useableCount"]) {
		if ([promoButton isKindOfClass:[UIButton class]]) {
			[self setPromoButtonTitle:badge.useableCount];
		}		
	}
}

- (void)setPromoButtonTitle:(NSInteger)useableCount {
	NSString *title = nil;
	if (useableCount > 0) {
		title = [NSString stringWithFormat:@"使用优惠 (还能用%d次)", useableCount];
		promoButton.enabled = YES;
		[promoButton setTitle:title forState:UIControlStateNormal];
	} else {
		promoButton.enabled = NO;
	}	
}

- (CGSize)viewSize
{
    NSInteger height = 290;
    
    CGSize descSize = [badge.description sizeWithFont:FontWithSize(14) constrainedToSize:CGSizeMake(260, MAXFLOAT)];
    height += descSize.height + MarginY;
    
    if (badge.isPromo) {
        CGSize promSize = [badge.promoInfo sizeWithFont:FontWithSize(14) constrainedToSize:CGSizeMake(260, MAXFLOAT) lineBreakMode:UILineBreakModeTailTruncation];
        height += promSize.height + 65;    
//		NSLog(@"view size:%f, %@", promSize.height, badge.promoInfo);
    }
	
	height += 50;
    
	
    return CGSizeMake(320, height);
}

@end
