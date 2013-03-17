//
//  ShopInfoPopupView.h
//  shenbian
//
//  Created by MagicYang on 11-1-19.
//  Copyright 2011 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SBShopInfo;

@interface ShopInfoPopupView : UIView {
	SBShopInfo *shop;
	NSInteger height;
	
	UIImageView *imgView;
	UITextView *textView;
}

@property(nonatomic, retain) SBShopInfo *shop;

- (ShopInfoPopupView *)initWithShopInfo:(SBShopInfo *)info;

- (void)show;
- (void)hide;

@end
