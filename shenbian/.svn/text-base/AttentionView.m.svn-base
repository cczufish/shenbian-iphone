//
//  AttentionView.m
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "AttentionView.h"

#import <QuartzCore/QuartzCore.h>
#import "Utility.h"
@class initWithUserID;
@implementation AttentionView
@synthesize iv_userPic;
@synthesize lb_been;
@synthesize lb_userName;
@synthesize view;
@synthesize userInfo;
- (void)dealloc {
    [userInfo release];
    [iv_userPic release];
    [lb_been release];
    [lb_userName release];
    [view release];
    [super dealloc];
}
-(void)clearValue
{
    
    lb_been.text=@"";
    lb_userName.text=@"";
    iv_userPic.image=nil;
    target=nil;
    iconBtnSelector=nil;

}
- (id)initWithFrame:(CGRect)frame 
{
    self = [super initWithFrame:frame];
    if (self) 
    {
        // Initialization code.
        [[NSBundle mainBundle] loadNibNamed:@"AttentionView" owner:self options:nil];
        [btn_Avatar addTarget:self
					  action:@selector(avatarDidTouched)
			forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.view];
        self.view.frame=frame;
        
//        lb_userName.textColor=[Utility colorWithHex:0x9e754c];
        lb_userName.font=FontWithSize(12);
//        lb_been.textColor =GrayColor;
//        lb_been.font=FontLiteWithSize(11);
        [self clearValue];
    }
    return self;
}
- (void) awakeFromNib
{
    [super awakeFromNib];
    
    [[NSBundle mainBundle] loadNibNamed:@"AttentionView" owner:self options:nil];
    [self addSubview:self.view];
}
-(void)loadData:(SBAttention*)attData

{   self.userInfo=attData;
    iv_userPic.layer.cornerRadius = 4;
    iv_userPic.layer.masksToBounds = YES;
    lb_userName.text=userInfo.uName;
    lb_been.text=[NSString stringWithFormat:@"去过(%d)" ,userInfo.shopTotal];
    if (attData.img==nil) 
    {
        [iv_userPic  setImage: PNGImage(@"bg_pic_no")];
    }
    else
    {
        iv_userPic.image=attData.img;
    }
    attData.showImg=iv_userPic;
    

}

- (void)addIconBtnTarget:(id)atarget sel:(SEL)selector
{
	target = atarget;
	iconBtnSelector = selector;
	
}
- (void)avatarDidTouched {
	[target performSelector:iconBtnSelector withObject:userInfo.uFcrid];
}

@end
