//
//  SBLocationView.h
//  shenbian
//
//  Created by MagicYang on 4/26/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SBLocationView : UIView {
    NSString *address;
    UILabel *label;
}

@property(nonatomic, copy) NSString *address;

- (SBLocationView *)initWithAddress:(NSString *)addr andPosition:(CGPoint)point;

@end
