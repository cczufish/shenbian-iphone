//
//  VSEffectLabel.h
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

//glow effects was copied from Andrew's TextGlowDemo project

#import <UIKit/UIKit.h>

//注意: stroke 使用了 kvc 强制修改了 UILabel 的私有变量 _color

@interface VSEffectLabel : UILabel {
@private	
	BOOL isEnableGrow;
	CGSize glowOffset;
    UIColor *glowColor;
    CGFloat glowAmount;
	
	BOOL isEnableStroke;
	CGFloat strokeWidth;
	UIColor *strokeColor;
}

- (void)setEffectGlow:(UIColor*)color offset:(CGSize)offset amount:(CGFloat)amount;
- (void)setEffectStroke:(UIColor*)color width:(CGFloat)width;

// call -setNeedsDisplay after change these ivars values
@property(nonatomic,assign)BOOL isEnableGrow;
@property(nonatomic,assign)BOOL isEnableStroke;

@end
