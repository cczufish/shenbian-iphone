//
//  VSTabController.h
//  shenbian
//
//  Created by xhan on 5/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSegmentView.h"

// TODO: 干掉 tabBarHeight
// TODO: 使用 contentHeight 替换


@interface VSTabBarController : UIViewController<VSSegmentViewDelegate> {
@private	
	NSArray *viewControllers;
	VSSegmentView *tabBarView;
	UIView *currentVCView;
	UIView *_transitionView;
	int _selectedIndex;	
	int contentHeight;
	int tabBarHeight;
	id<UITabBarControllerDelegate> delegate;
    
    //tabBar animation control
    BOOL isTabBarProcessingAnimation;
    BOOL isTabBarVisible;
}
@property(nonatomic,retain) VSSegmentView *tabBarView;
@property(nonatomic,assign) int selectedIndex;
@property(nonatomic,readonly) UIViewController* selectedViewController;
@property(nonatomic,copy) NSArray *viewControllers;

@property(nonatomic,readonly) int contentHeight;
@property(nonatomic,assign) int tabBarHeight;

/* this delegate has only two methods
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController 
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController; 
 */
@property(nonatomic,assign) id delegate;

- (id)initWithTabBar:(VSSegmentView*)tabBar viewControllers:(NSArray*)viewControllers;
- (void)setupTabBar:(VSSegmentView*)tabBar viewControllers:(NSArray*)viewControllers;
- (void)hiddenTabBar:(BOOL)isHidden animated:(BOOL)isAnimated;
@end

@interface UIViewController (VSTabBarControllerCategory)

@property(nonatomic,readonly) VSTabBarController *vstabBarController;

- (void)showModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;

@end

@interface VSNavigationController : UINavigationController<UINavigationControllerDelegate>
//private
- (void)_checkIfModifyTabBar:(UIViewController*)current willAppear:(UIViewController*)next animated:(BOOL)animated;
@end
