//
//  PhotoHeaderView.h
//  shenbian
//
//  Created by xhan on 4/19/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommodityPhotoDetailVC.h"

@class SBCommodityPhotoInfo;

typedef enum{
    PhotoHeaderViewTypeNil, //nothing on the header
    PhotoHeaderViewTypeNonCommodity,
    PhotoHeaderViewTypeCommodity
}PhotoHeaderViewType;


@interface PhotoHeaderView : UIControl {

	SBCommodityPhotoInfo* _info;
    
    UIButton *shopInfoButton; 
    UILabel *commodifyLabel, *shopNameLabel;
    UILabel *addressLabel;  // 包括（去过人数，商户地址)
    UIImageView* clickIndicatorView;    //右边的小尖头
}


//- (id)initWithType:(PhotoHeaderViewType)type info:(SBCommodityPhotoInfo*)info;
- (id)inityWithInfo:(SBCommodityPhotoInfo*)info from:(CommodityPhotoSourceFrom)from;


- (void)addTargetForShopInfo:(id)target action:(SEL)action;

- (void)disableShopInfoButton;


@end
