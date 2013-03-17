//
//  AttentionView.h
//  shenbian
//
//  Created by Dai ≈ on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBAttention.h"
@interface AttentionView : UIView
{
  IBOutlet UIImageView *iv_userPic;
  IBOutlet  UILabel *lb_userName;
  IBOutlet  UILabel *lb_been;
  IBOutlet  UIView *view;
    id target;
	SEL iconBtnSelector;
    IBOutlet UIButton *btn_Avatar;
    SBAttention *userInfo;
}
@property(nonatomic,retain)  SBAttention *userInfo;;
@property (nonatomic,retain) UIView *view;
@property (nonatomic,retain)    UIImageView *iv_userPic;
@property (nonatomic,retain)   UILabel *lb_userName;
@property (nonatomic,retain)   UILabel *lb_been; 
-(void)clearValue;
-(void)loadData:(SBAttention*)attData;
- (void)addIconBtnTarget:(id)target sel:(SEL)selector;
@end