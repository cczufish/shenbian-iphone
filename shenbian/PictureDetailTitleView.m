//
//  PhotoDetailTitleView.m
//  shenbian
//
//  Created by MagicYang on 6/17/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PictureDetailTitleView.h"
#import "Utility.h"
#import "SBCommodityPhoto.h"
#import "WTFButton.h"

static NSInteger maxTextLength = 220;

@implementation PictureDetailTitleView
@synthesize delegate;
@synthesize isNonCommodity;

- (id)initWithFrame:(CGRect)frame delegate:(id)del commodityInfo:(SBCommodityPhotoInfo *)info hasRecommend:(BOOL)flag
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = del;
        
        // Buttons
        shopInfoButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shopInfoButton setFrame:frame];
        [shopInfoButton setImage:PNGImage(@"button_pd_title_0") forState:UIControlStateNormal];
        [shopInfoButton setImage:PNGImage(@"button_pd_title_1") forState:UIControlStateHighlighted];
        [shopInfoButton addTarget:self action:@selector(showShopInfo) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:shopInfoButton];
        
        NSInteger labelStartX = 75; // Labels start from x
        if (flag) {
            recommendButton = [WTFButton new];
            recommendButton.origin = ccp(10,5);
            [recommendButton setVoted:info.isCVoted];
            [recommendButton setVoteNum:[info cvoteCount]];
            [recommendButton addTarget:self action:@selector(recommend) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:recommendButton];
        } else {
            labelStartX = 10;
        }
        
        // Labels
        UIFont *titleFont = FontWithSize(15);
        UIFont *addressFont = FontLiteWithSize(12);
        CGSize size = [info.cname sizeWithFont:titleFont];
		
        commodifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX, 10, size.width, size.height)];
        commodifyLabel.font = titleFont;
        commodifyLabel.textColor = [UIColor colorWithRed:0.78 green:0 blue:0.059 alpha:1];
        commodifyLabel.backgroundColor = [UIColor clearColor];
        commodifyLabel.text = info.cname;
		
        shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX + size.width, 10, maxTextLength - size.width, size.height)];
        shopNameLabel.font = titleFont;
        shopNameLabel.backgroundColor = [UIColor clearColor];
        shopNameLabel.text = [NSString stringWithFormat:@"@%@", info.sname];
		
        addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelStartX, 30, maxTextLength, 15)];
        addressLabel.font = addressFont;
        addressLabel.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.525 alpha:1];
        addressLabel.backgroundColor = [UIColor clearColor];
        addressLabel.text = [NSString stringWithFormat:@"%d人去过 | %@", info.svoteCount, info.saddress];
        [self addSubview:commodifyLabel];
        [self addSubview:shopNameLabel];
        [self addSubview:addressLabel];
    }
    return self;
}

- (void)dealloc
{
    Release(recommendButton);
    Release(commodifyLabel);
    Release(shopNameLabel);
    Release(addressLabel);
    [super dealloc];
}

- (void)updateRecommendCount:(NSInteger)count andRecommendStat:(BOOL)stat
{
    if (recommendButton) {
        [recommendButton setVoted:stat];
        [recommendButton setVoteNum:count];
    }
}

- (void)showShopInfo
{
    if ([delegate respondsToSelector:@selector(showShopInfo)]) {
        [delegate performSelector:@selector(showShopInfo)];
    }
}

- (void)recommend
{
    if ([delegate respondsToSelector:@selector(recommend)]) {
        [delegate performSelector:@selector(recommend)];
    }    
}


@end
