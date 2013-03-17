//
//  SBNavigationController.h
//  shenbian
//
//  Created by MagicYang on 10-12-2.
//  Copyright 2010 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 *	Custom view controller which is set to root controller
 *	1.Navigation bar with background image
 *	2.Navigation bar button in custom image
 */
@interface SBNavigationController : UIViewController {
	UIImageView *navShadow;
    BOOL isShowing;
}

- (NSString *)defaultBackTitle;
- (void)setBackTitle:(NSString *)backTitle;
- (void)addSubview:(UIView *)subview;
+ (UIBarButtonItem *)buttonItemWithTitle:(NSString *)aTitle andAction:(SEL)action inDelegate:(id)delegate;

@end

@interface UINavigationBar(CustomBackground)

@end