//
//  SBTriggleButton.h
//  shenbian
//
//  Created by xhan on 5/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBTriggleButton : UIButton {
    @private
    BOOL isTriggled;
    UIImage* triggledImg;
    UIImage* normalImg;
    id target;
    SEL action;
}
@property(nonatomic,assign) BOOL isTriggled;

- (void)setImage:(UIImage *)image forStateTriggled:(BOOL)triggled;
- (void)addTarget:(id)target action:(SEL)action; 

@end
