//
//  PhotoHeaderView.m
//  shenbian
//
//  Created by xhan on 4/19/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PhotoHeaderView.h"
#import "SBCommodityPhoto.h"
#import "Utility.h"


@implementation PhotoHeaderView

#define PhotoHeaderViewAlphaShadowHeight 3
- (id)inityWithInfo:(SBCommodityPhotoInfo*)info from:(CommodityPhotoSourceFrom)from
{
	self = [super init];
	if (self) {
		self.backgroundColor = [UIColor clearColor];
        
        if (from == CommodityPhotoSourceFromShopAlbum) {
            // only a simple background
            UIImageView* bgView = [T imageViewNamed:@"photo_header_none.png"];
            self.size = CGSizeMake(320, bgView.height - PhotoHeaderViewAlphaShadowHeight);
            [self addSubview:bgView];
        }else{
            shopInfoButton = [[T createBtnfromPoint:CGPointZero
                                              image:PNGImage(@"button_pd_title_0")
                                       highlightImg:PNGImage(@"button_pd_title_1")
                                             target:nil
                                           selector:nil] retain];
            [shopInfoButton setBackgroundImage:PNGImage(@"button_pd_title_0")
                                      forState:UIControlStateDisabled];
            
            self.size = CGSizeMake(320, shopInfoButton.height - PhotoHeaderViewAlphaShadowHeight);
            [self addSubview:shopInfoButton];
            
            // left some space for RateButton of CommodityPhoto
            
            int leftSpace = info.isCommodity ? 75 : 10;
            
            if ([info.sname length] > 0 ) {
                // Labels
                const int maxTextLength = 220;
                UIFont *titleFont = FontWithSize(15);
                UIFont *addressFont = FontLiteWithSize(12);
                CGSize size = [info.cname sizeWithFont:titleFont];
                commodifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 10, size.width, size.height)];
                commodifyLabel.font = titleFont;
                commodifyLabel.textColor = [UIColor colorWithRed:0.78 green:0 blue:0.059 alpha:1];
                commodifyLabel.backgroundColor = [UIColor clearColor];
                commodifyLabel.text = info.cname;
                float x = leftSpace + size.width;
                float w = maxTextLength - size.width;
                //添加菜名和商户名长度处理
                int cNameWidth=size.width;
                size = [info.sname sizeWithFont:titleFont];
              
                
                shopNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(x, 10, w, size.height)];
                shopNameLabel.font = titleFont;
                shopNameLabel.backgroundColor = [UIColor clearColor];
                shopNameLabel.text = [NSString stringWithFormat:@"@%@", info.sname];
                int totalWidth=240;
                int sNameWidth=size.width;
                if ((cNameWidth+sNameWidth)>totalWidth) {
                    if (cNameWidth>totalWidth/2&&sNameWidth>totalWidth/2) {
                        commodifyLabel.frame=CGRectMake(commodifyLabel.frame.origin.x, commodifyLabel.frame.origin.y,totalWidth/2, commodifyLabel.frame.size.height);
                         shopNameLabel.frame=CGRectMake(leftSpace+totalWidth/2, shopNameLabel.frame.origin.y,totalWidth/2, shopNameLabel.frame.size.height);
                    }
                    else if(cNameWidth>totalWidth/2){
                        commodifyLabel.frame=CGRectMake(commodifyLabel.frame.origin.x, commodifyLabel.frame.origin.y,totalWidth-sNameWidth, commodifyLabel.frame.size.height);
                    }
                    else if(sNameWidth>totalWidth/2){
                        shopNameLabel.frame=CGRectMake(leftSpace+cNameWidth, shopNameLabel.frame.origin.y,totalWidth-cNameWidth, shopNameLabel.frame.size.height);
                    }
                }
                
                addressLabel = [[UILabel alloc] initWithFrame:CGRectMake(leftSpace, 28, maxTextLength, 15)];
                addressLabel.font = addressFont;
                addressLabel.textColor = [UIColor colorWithRed:0.522 green:0.525 blue:0.525 alpha:1];
                addressLabel.backgroundColor = [UIColor clearColor];
                addressLabel.text = [NSString stringWithFormat:@"%d人去过 | %@", info.svoteCount, info.saddress];
                [self addSubview:commodifyLabel];
                [self addSubview:shopNameLabel];
                [self addSubview:addressLabel]; 
                
                clickIndicatorView = [[T imageViewNamed:@"arrow_right.png"] retain];
                clickIndicatorView.origin = ccp(300, 18);
                [self addSubview:clickIndicatorView];
            }

            
            _info = [info retain];            
        }

        if (from == CommodityPhotoSourceFromShopInfo) {
            [self disableShopInfoButton];
        }
	}
	return self;
}



- (void)dealloc {
	VSSafeRelease(_info);
    VSSafeRelease(shopInfoButton);
    VSSafeRelease(clickIndicatorView);
    Release(commodifyLabel);
    Release(shopNameLabel);
    Release(addressLabel);
    [super dealloc];
}


- (void)addTargetForShopInfo:(id)target action:(SEL)action
{
    [shopInfoButton addTarget:target 
                       action:action
             forControlEvents:UIControlEventTouchUpInside];
}

- (void)disableShopInfoButton
{
    shopInfoButton.enabled = NO;
    [clickIndicatorView removeFromSuperview];
}



@end
