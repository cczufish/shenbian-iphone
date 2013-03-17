//
//  ShopInfoCellView.h
//  shenbian
//
//  Created by MagicYang on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellView.h"


@class SBShopInfo;
@class WTFButton2;
@interface ShopBasicInfoView : UIView {
    SBShopInfo *shop;
    WTFButton2* wtfButton;
}
@property(nonatomic, retain) SBShopInfo *shop;
@property(nonatomic,readonly) WTFButton2* wtfButton;

- (id)initWithShop:(SBShopInfo *)shopInfo;

@end


//////////////////////////////////////////////////////////////////////


@interface ShopFooterView : UIView {
    id delegate;
}

@property(assign) id delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del;

@end


//////////////////////////////////////////////////////////////////////


@interface ShopCouponCellView : CustomCellView {

}

@end


//////////////////////////////////////////////////////////////////////


@interface ShopContactCellView : CustomCellView {
    UIButton *callButton, *mapButton;
}
@property(nonatomic, retain) UIButton *callButton;
@property(nonatomic, retain) UIButton *mapButton;
@end


//////////////////////////////////////////////////////////////////////


@interface ShopCommodityCellView : CustomCellView {
    UIActivityIndicatorView *indicator;
    UIButton *photoButton;
    BOOL yaoXuXianMa;
}
@property(nonatomic, retain) UIButton *photoButton;
@end


//////////////////////////////////////////////////////////////////////


@interface ShopCommentCellView : CustomCellView {

}

@end


//////////////////////////////////////////////////////////////////////


@interface ShopSectionHeaderCellView : UIView {
    
}

- (id)initWithIcon:(UIImage *)icon andTitle:(NSString *)title;

@end
