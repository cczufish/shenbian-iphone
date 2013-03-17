//
//  PhotoDetailTitleView.h
//  shenbian
//
//  Created by MagicYang on 6/17/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WTFButton;
@class SBCommodityPhotoInfo;
@interface PictureDetailTitleView : UIView {
    id delegate;
    WTFButton *recommendButton;
    UIButton *shopInfoButton;
    UILabel *commodifyLabel, *shopNameLabel;
    UILabel *addressLabel;  // 包括（去过人数，商户地址)
    BOOL isNonCommodity;
}
@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) BOOL isNonCommodity;

- (id)initWithFrame:(CGRect)frame delegate:(id)del commodityInfo:(SBCommodityPhotoInfo *)info hasRecommend:(BOOL)flag;
- (void)updateRecommendCount:(NSInteger)count andRecommendStat:(BOOL)stat;

@end
