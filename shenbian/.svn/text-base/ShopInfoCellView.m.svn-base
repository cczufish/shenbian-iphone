//
//  ShopInfoCellView.m
//  shenbian
//
//  Created by MagicYang on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "ShopInfoCellView.h"
#import "SBShopInfo.h"
#import "SBComment.h"
#import "SBCoupon.h"
#import "Utility.h"
#import "SBCommodityList.h"
#import "Notifications.h"
#import "SBUser.h"

#import "WTFButton2.h"

#define MarginX 10
#define MarginY 10


@implementation ShopBasicInfoView

@synthesize shop, wtfButton;

- (id)initWithShop:(SBShopInfo *)shopInfo
{
	float myHeight = 0.0f;
	CGSize titleSize = [shopInfo.strName sizeWithFont:FontWithSize(18) constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
	myHeight+= titleSize.height + 5 + 20 + 20 + 15;
	
    self = [super initWithFrame:CGRectMake(0, 0, 320, myHeight)];
    if ((self)) {
        self.backgroundColor = [UIColor clearColor];
        self.shop = shopInfo;
        
        wtfButton = [[WTFButton2 alloc] init];
        [wtfButton setVisited:shop.been];
        [wtfButton setVisitedNum:shop.intBeenCount];
        wtfButton.left = 250;
        wtfButton.top = 15 - 2;
        [self addSubview:wtfButton];
        
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    NSInteger currentX = 15;
    NSInteger currentY = 15;
    CGContextRef ctx = UIGraphicsGetCurrentContext();

    // 商户名
	CGSize titleSize = [shop.strName sizeWithFont:FontWithSize(18) constrainedToSize:CGSizeMake(230, MAXFLOAT) lineBreakMode:UILineBreakModeCharacterWrap];
//    [shop.strName drawInRect:CGRectMake(currentX, currentY, 230, 15) withFont:FontWithSize(18)];
    [shop.strName drawInRect:vsr(currentX, currentY, titleSize.width, titleSize.height) withFont:FontWithSize(18)];

    // 去过按钮
    /*
    NSString *imgName = shop.been ? @"button_shop_been_1" : @"button_shop_been_0";
    UIImage *img = PNGImage(imgName);
    [img drawInRect:CGRectMake(250, currentY - 2, 56, 56)];
    
    NSString *beenCount = [NSString stringWithFormat:@"%d人", shop.intBeenCount];
    UIColor *textColor = shop.been ? [UIColor whiteColor] : [UIColor colorWithRed:0.647 green:0.718 blue:0.745 alpha:1];
    UIColor *borderColor = shop.been ? [UIColor colorWithRed:0.894 green:0.204 blue:0.184 alpha:1] :[UIColor whiteColor];
    [Utility drawBorderText:beenCount withColor:textColor andBorderColor:borderColor toRect:CGRectMake(235, currentY + 3, 30, 10) inContext:ctx];
    */

//    currentY += 18 + 5;
	currentY += titleSize.height + 5;
	
    // 星星
    [Utility drawStars:CGPointMake(currentX, currentY) score:shop.intScoreTotal];
    
    // 人均
	if (shop.fltAverage > 0.0f) {
		CGContextSaveGState(ctx);
		[[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1] set];
		NSString *average = [NSString stringWithFormat:@"| 人均%.0f元", shop.fltAverage];
		[average drawAtPoint:CGPointMake(93, currentY + 1) withFont:FontWithSize(12)];
		CGContextRestoreGState(ctx);
    }
	currentY += 20;
	
    // 分项打分
    UIFont *sfont12 = [UIFont systemFontOfSize:12];
    for (NSString *key in [shop.arrScore allKeys]) {
        NSString *value = [shop.arrScore objectForKey:key];
        if ([value floatValue] == 0.0) {
            value = @"-";
        }
        CGSize keySize = [key sizeWithFont:sfont12];
        [key drawAtPoint:CGPointMake(currentX, currentY) withFont:sfont12];
        currentX += keySize.width;
        
        CGContextSaveGState(ctx);
        [[UIColor colorWithRed:0.89 green:0 blue:0.075 alpha:1] set];
        [value drawInRect:CGRectMake(currentX, currentY, 20, 15) withFont:sfont12 lineBreakMode:UILineBreakModeCharacterWrap alignment:UITextAlignmentCenter];
        CGContextRestoreGState(ctx);
        currentX += 20 + 5;
    }
	
	
}

- (void)dealloc
{
    [wtfButton release];
    [shop release];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)data
{
    return 0;
}


@end


//////////////////////////////////////////////////////////////////////


@implementation ShopFooterView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del
{
    self = [super initWithFrame:CGRectMake(0, 0, 320, 44)];
    if (self) {
        self.delegate = del;
        self.backgroundColor = [UIColor clearColor];
        
        UIButton *sharedBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [sharedBtn setImage:PNGImage(@"button_share_1") forState:UIControlStateNormal];
        [sharedBtn setImage:PNGImage(@"button_share_0") forState:UIControlStateHighlighted];
        [sharedBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        [sharedBtn setFrame:CGRectMake(10, 0, 143, 32)];
        
        UIButton *reportBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [reportBtn setImage:PNGImage(@"button_reporterror_1") forState:UIControlStateNormal];
        [reportBtn setImage:PNGImage(@"button_reporterror_0") forState:UIControlStateHighlighted];
        [reportBtn addTarget:self action:@selector(report) forControlEvents:UIControlEventTouchUpInside];
        [reportBtn setFrame:CGRectMake(167, 0, 143, 32)];
        
        [self addSubview:sharedBtn];
        [self addSubview:reportBtn];
    }
    return self;
}

- (void)share
{
    if ([delegate respondsToSelector:@selector(share)]) {
        [delegate performSelector:@selector(share)];
    }
}

- (void)report
{
    if ([delegate respondsToSelector:@selector(report)]) {
        [delegate performSelector:@selector(report)];
    }
}

@end


//////////////////////////////////////////////////////////////////////


@implementation ShopCouponCellView

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = NO;
    
    SBShopInfo *shop = dataModel;
    SBCoupon *coupon = [shop.arrCouponList objectAtIndex:0];
    NSInteger currentY = MarginY;
    NSInteger currentX = 50;
    
    UIImage *img = PNGImage(@"shop_coupon");
    [img drawInRect:CGRectMake(-1, -1, 302, 35)];
//    [img drawInRect:CGRectInset(rect, -1, -1)];
	 
    [coupon.topic drawInRect:CGRectMake(currentX, currentY, 190, 15) withFont:FontLiteWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
    NSString *count = [NSString stringWithFormat:@"%d条", [shop.arrCouponList count]];
    [count drawInRect:CGRectMake(240, currentY, 45, 15) withFont:FontLiteWithSize(14) lineBreakMode:UILineBreakModeTailTruncation alignment:UITextAlignmentRight];
}

+ (NSInteger)heightOfCell:(id)data
{
    return 34;
}


@end


//////////////////////////////////////////////////////////////////////


@implementation ShopContactCellView

@synthesize callButton, mapButton;

#define HeightPerRow 55

- (void)drawRect:(CGRect)rect
{
    SBShopInfo *shop = dataModel;
    NSInteger currentY = 10;
    UIFont *font14 = FontWithSize(14);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGSize addrSize = [shop.strAddress sizeWithFont:font14 constrainedToSize:CGSizeMake(200, 30) lineBreakMode:UILineBreakModeTailTruncation];
    if (addrSize.height > 0) {
        currentY = (HeightPerRow - addrSize.height) / 2;
        [@"地址:" drawAtPoint:CGPointMake(10, currentY) withFont:font14];
        CGContextSaveGState(ctx);
        [[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1] set];
        [shop.strAddress drawInRect:CGRectMake(45, currentY, addrSize.width, addrSize.height) withFont:font14 lineBreakMode:UILineBreakModeTailTruncation];
        CGContextRestoreGState(ctx);
        
        UIImage *addrIcon = PNGImage(@"shop_icon_address");
        [addrIcon drawInRect:CGRectMake(260, (HeightPerRow - 29) / 2, 29, 29)];
        
        CGContextSaveGState(ctx);
        [[UIColor colorWithRed:0.863 green:0.863 blue:0.863 alpha:1] set];
        CGContextFillRect(ctx, CGRectMake(0, HeightPerRow, 300, 1));
        CGContextRestoreGState(ctx);
        
        currentY = HeightPerRow;
        
        if (mapButton) {
            [mapButton removeFromSuperview];
        } else {
            self.mapButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        [mapButton setFrame:CGRectMake(0, 0, rect.size.width, currentY)];
        [mapButton addTarget:self action:@selector(showMap:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:mapButton];
    }
    
    
    if ([shop.arrTel count] > 0) {
        NSInteger addressRectY = currentY;
        if ([shop.arrTel count] == 1) {
            currentY += 20;
        } else {
            currentY += 13;
        }
        [@"电话:" drawAtPoint:CGPointMake(10, currentY) withFont:font14];
        CGContextSaveGState(ctx);
        [[UIColor colorWithRed:0.52 green:0.52 blue:0.52 alpha:1] set];
        
        int i = 0;
        for (NSString *tel in shop.arrTel) {
            if (i < 2) {    // 只显示两个号码
                CGSize telSize = [tel sizeWithFont:font14];
                [tel drawInRect:CGRectMake(45, currentY, telSize.width, telSize.height) withFont:font14 lineBreakMode:UILineBreakModeTailTruncation];
                currentY += telSize.height;
                i++;
            }
        }
        CGContextRestoreGState(ctx);
        
        UIImage *phoneIcon = PNGImage(@"shop_icon_phone");
        [phoneIcon drawInRect:CGRectMake(260, HeightPerRow + (HeightPerRow - 29) / 2, 29, 29)];
        
        if (callButton) {
            [callButton removeFromSuperview];
        } else {
            self.callButton = [UIButton buttonWithType:UIButtonTypeCustom];
        }
        
        [callButton setFrame:CGRectMake(0, addressRectY, rect.size.width, currentY - addressRectY)];
        [callButton addTarget:self action:@selector(call:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:callButton];
    }
}

- (void)dealloc
{
    [callButton release];
    [mapButton release];
    [super dealloc];
}

+ (NSInteger)heightOfCell:(id)data
{
    NSInteger h = 0;
    SBShopInfo *shop = data;
    if ([shop.strAddress length] > 0) {
        h += HeightPerRow;
    }
    if ([shop.arrTel count] > 0) {
        h += HeightPerRow;
    }
    return h;
}

- (void)call:(id)sender {
	[Notifier postNotificationName:kShopActionCall object:nil];
}

- (void)showMap:(id)sender {
	[Notifier postNotificationName:kShopActionShowMap object:nil];
}

@end


//////////////////////////////////////////////////////////////////////


@implementation ShopCommodityCellView

@synthesize photoButton;

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"imgCover"];
	[super setDataModel:model];
	[dataModel addObserver:self forKeyPath:@"imgCover" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	SBCommodity* amodel = model;
	[amodel loadImageResource];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    self.clipsToBounds = NO;
    SBCommodity *commodity = dataModel;
    NSInteger currentY = 13;
    NSInteger currentX = 15;
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    UIImage *kuangkuang = PNGImage(@"shop_commodify_kk");
    if (commodity.ccount > 0) {
        if (commodity.imgCover) {
            [indicator stopAnimating];
            [indicator removeFromSuperview];
            [kuangkuang drawInRect:CGRectMake(currentX, currentY, 89, 63)];
            UIImage *cimg = [Utility clipImage:commodity.imgCover toSize:CGSizeMake(77 * 2, 50 * 2)];
            [cimg drawInRect:CGRectMake(currentX + 5, currentY + 5, 77, 50)];
            [Utility drawVote:commodity.cvote at:CGPointMake(currentX - 8, currentY - 5) inContext:ctx];
        } else {
            if (!indicator) {
                indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = CGRectMake(currentX + 20, currentY + 10, 25, 25);
            }
            [indicator startAnimating];
            [self addSubview:indicator];
        }
        [photoButton removeFromSuperview];
    } else {
        [kuangkuang drawInRect:CGRectMake(currentX - 5, currentX - 5, 89, 63)];
        if (photoButton) {
            [photoButton removeFromSuperview];
        } else {
            self.photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
            // Name has been replaced by each other, because of wrong picture name
            [photoButton setImage:PNGImage(@"button_addPhoto_1") forState:UIControlStateNormal];
            [photoButton setImage:PNGImage(@"button_addPhoto_0") forState:UIControlStateHighlighted];
        }
        [photoButton setFrame:CGRectMake(currentX, currentX, 77, 50)];
        [photoButton addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:photoButton];
    }
    
    currentX = commodity.ccount ? 115 : 110;
    
    [[UIColor colorWithRed:0.886 green:0 blue:0.075 alpha:1] set];
    [commodity.cname drawAtPoint:CGPointMake(currentX, currentY) withFont:FontWithSize(16)];
    currentY += 15 + 5;
    
    if (commodity.ccount > 0) {
        [[UIColor colorWithRed:0.286 green:0.267 blue:0.247 alpha:1] set];
        NSString *nPic = [NSString stringWithFormat:@"%d张图", commodity.ccount];
        [nPic drawAtPoint:CGPointMake(currentX, currentY) withFont:FontWithSize(14)];
    }
    
    if (yaoXuXianMa) {
        [PNGImage(@"line_dot") drawInRect:CGRectMake(0, rect.size.height - 1, 320, 1)];
    }
}

+ (NSInteger)heightOfCell:(id)data
{
    return 85;
}

- (void)dealloc
{
    [photoButton release];
    [dataModel removeObserver:self forKeyPath:@"imgCover"];
    [indicator release];
    [super dealloc];
}

- (void)takePhoto:(id)sender
{
    [Notifier postNotificationName:kShopActionTakePhoto 
                            object:dataModel
                          userInfo:[NSDictionary dictionaryWithObject:dataModel forKey:@"commodity"]];
}

@end


//////////////////////////////////////////////////////////////////////


@implementation ShopCommentCellView

- (void)drawRect:(CGRect)rect
{
    SBShopInfo *shop = dataModel;
    NSInteger currentY = MarginY + 3;
    NSInteger currentX = MarginX;
    
    UIFont *font16 = FontWithSize(16);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    SBComment *cmt = [shop.arrCmtList objectAtIndex:0];
    
	// 用户头像
    UIImage *img = cmt.userImg ? cmt.userImg : DefaultUserImage;
	[SBUser drawUserAvatarWithImage:img atRect:vsr(currentX, currentY, 37, 37) andIsVIP:NO];
    
//	UIImage *img = cmt.userImg ? [Utility clipImage:cmt.userImg toSize:CGSizeMake(37, 37)] : DefaultUserImage;
//	CGContextSaveGState(ctx);
//	CGRect imgFrame = CGRectMake(currentX, currentY, 37, 37);
//	[Utility clipContext:ctx toRoundedCornerWithRect:imgFrame andRadius:8];
//	[img drawInRect:imgFrame];
//	CGContextRestoreGState(ctx);
    currentX = 55;
    
    CGSize size = [cmt.userName sizeWithFont:font16];
    CGContextSaveGState(ctx);
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.322 green:0.196 blue:0.043 alpha:1] CGColor]);
    [cmt.userName drawAtPoint:CGPointMake(currentX, currentY) withFont:font16];
    currentX += size.width;
    CGContextRestoreGState(ctx);
     
    currentX = 55;
    currentY += 20;
    
    [Utility drawStars:CGPointMake(currentX, currentY) score:cmt.totalScore];
    currentY += 20;
    
    CGContextSetFillColorWithColor(ctx, [[UIColor colorWithRed:0.525 green:0.525 blue:0.525 alpha:1] CGColor]);
    [cmt.content drawInRect:CGRectMake(currentX, currentY, 210, 50) withFont:FontLiteWithSize(14) lineBreakMode:UILineBreakModeTailTruncation];
}

+ (NSInteger)heightOfCell:(id)data
{
    NSInteger height = 55;
    SBShopInfo *shop = data;
    SBComment *cmt = [shop.arrCmtList objectAtIndex:0];
    CGSize size = [cmt.content sizeWithFont:FontLiteWithSize(14) constrainedToSize:CGSizeMake(210, 50)];
    height += size.height + MarginY;
    return height;
}

@end


//////////////////////////////////////////////////////////////////////


@implementation ShopSectionHeaderCellView

- (id)initWithIcon:(UIImage *)icon andTitle:(NSString *)title {
    if ((self = [super initWithFrame:CGRectMake(0, 0, 320, 35)])) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 18, 18)];
        iconView.image = icon;
        UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 200, 20)];
        titleView.font = FontWithSize(16);
        titleView.text = title;
        [self addSubview:iconView];
        [self addSubview:titleView];
        [iconView release];
        [titleView release];
    }
    return self;
}

@end