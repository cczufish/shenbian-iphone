    //
//  VSTabController.m
//  shenbian
//
//  Created by xhan on 5/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSTabBarController.h"

@interface VSTabBarController(Private)

- (void)changeViewToIndex:(int)index;
// same as selectedIndex
- (void)updateViewAndTabBarToIndex:(int)index;

@end
@implementation VSTabBarController

@synthesize tabBarView, contentHeight, delegate, tabBarHeight, viewControllers;
@synthesize selectedIndex = _selectedIndex;

- (id)initWithTabBar:(VSSegmentView*)tabBar viewControllers:(NSArray*)aviewControllers
{
    self = [super init];
	if (self) {
		tabBarView = [tabBar retain];
		tabBarView.delegate = self;
		viewControllers = [aviewControllers retain];
	}
	return self;
}

- (void)dealloc {
	VSSafeRelease(tabBarView);
	VSSafeRelease(viewControllers);
	VSSafeRelease(_transitionView);
    [super dealloc];
}

- (void)setupTabBar:(VSSegmentView*)tabBar viewControllers:(NSArray*)aviewControllers
{
	//only allow this method be invoked once
	if (tabBarView || viewControllers) return;
	//else
	tabBarView = [tabBar retain];
	tabBarView.delegate = self;
	viewControllers = [aviewControllers retain];
}

#pragma mark -


- (void)loadView {
    [super loadView];
    
	UIView* view_ = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
	view_.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	view_.backgroundColor = [UIColor clearColor];
	
	self.view = view_;
	[view_ release];
	
    isTabBarVisible = YES;
	if (tabBarHeight == 0) {
		tabBarHeight = tabBarView.height;
		contentHeight = self.view.height - tabBarView.height;
	}
	
	_transitionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, contentHeight)];
	_transitionView.clipsToBounds = YES;
	[_transitionView setNeedsLayout];
	_transitionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	[self.view addSubview:_transitionView];
	[self.view addSubview:tabBarView];
	tabBarView.top = self.view.height - tabBarView.height;
	[self updateViewAndTabBarToIndex:_selectedIndex];
}


- (void)viewDidUnload {
    [super viewDidUnload];
    currentVCView = nil;    // because currentVCView is assign value, set it to nil in case of prevent BadAccess
	VSSafeRelease(_transitionView);
}
/*
- (void)viewDidLoad{
	[self updateViewAndTabBarToIndex:_selectedIndex];
}
*/

#pragma mark -
#pragma mark Action

- (void)hiddenTabBar:(BOOL)isHidden animated:(BOOL)animated
{
    if (isTabBarProcessingAnimation)  return;
	if (isTabBarVisible == !isHidden) return;
	int flag = isHidden ? 1 : -1;
	isTabBarVisible = !isHidden;
	if (animated) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.25];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	}
	tabBarView.top += tabBarHeight * flag * 2; // *2是为了让tabbarView藏到window外（tabbarView可视区域>高度）
	if (animated) {
        isTabBarProcessingAnimation = YES;
		[UIView commitAnimations];
	}
	_transitionView.height += tabBarHeight * flag;
	[_transitionView setNeedsLayout];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context
{
    isTabBarProcessingAnimation = NO;
}

- (UIViewController*)selectedViewController
{
	return [viewControllers objectAtIndex:self.selectedIndex];
}

- (void)setSelectedIndex:(int)value{
	[self updateViewAndTabBarToIndex:value];
	_selectedIndex = value;
}

- (void)setcontentHeight:(int)value
{
	contentHeight = value;
	_transitionView.height = value;
}

- (void)setTabBarHeight:(int)value
{
	tabBarHeight = value;
	contentHeight = 460 - tabBarHeight;
	_transitionView.height = contentHeight;
}


#pragma mark -
#pragma mark private


- (void)updateViewAndTabBarToIndex:(int)index
{
	[self changeViewToIndex:index];
	tabBarView.selectedIndex = index;
	
}

- (void)changeViewToIndex:(int)index
{
	BOOL animated = YES;
	UIViewController* oldVC = self.selectedViewController;
		
	_selectedIndex = index;
	UIViewController* curVC = self.selectedViewController;
	
	[oldVC viewWillDisappear:animated];
	[curVC viewWillAppear:animated];
	
	[currentVCView removeFromSuperview];		
	currentVCView = [(UIViewController*)[viewControllers objectAtIndex:_selectedIndex] view];
	
	//	
	currentVCView.autoresizingMask = _transitionView.autoresizingMask;
//	currentVCView.height = _transitionView.height;
	currentVCView.frame = _transitionView.bounds;	
	[_transitionView addSubview:currentVCView];
	
	[oldVC viewDidDisappear:animated];
	[curVC viewDidAppear:animated];
	
	
}

#pragma mark -
#pragma mark delegate of segment view

- (void)segment:(VSSegmentView*)view clickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    if (!isCurrent) {
        [self changeViewToIndex:index];
        if ([delegate respondsToSelector:@selector(tabBarController:didSelectViewController:)]) {
            [delegate tabBarController:(id)self didSelectViewController:self.selectedViewController];
        }
    }
}

- (BOOL)segment:(VSSegmentView*)view willClickAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    BOOL result = YES;
    if ([delegate respondsToSelector:@selector(tabBarController:shouldSelectViewController:)]) {
        UIViewController* vc = (UIViewController*)[viewControllers objectAtIndex:index];
        result = [delegate tabBarController:(id)self shouldSelectViewController:vc];
    }
    return result;
}

@end


@implementation UIViewController (VSTabBarControllerCategory)

- (void)showModalViewController:(UIViewController *)modalViewController animated:(BOOL)animated;
{
    UIViewController* topVC = [self vstabBarController];
    if (!topVC) {
        topVC = self;
    }
    [topVC presentModalViewController:modalViewController animated:animated];
}

- (VSTabBarController*)vstabBarController
{
	for (UIResponder* next = self; next; next = [next nextResponder]) {
		if ([next isKindOfClass:[VSTabBarController class]]) {
			return (VSTabBarController*)next;
		}
	}
	return nil;	
}


@end


@implementation VSNavigationController
/*
- (id)init{
	self = [super init];
	self.delegate = self;
	return self;
}

- (void)navigationController:(UINavigationController *)anavigationController willShowViewController:(UIViewController *)vc animated:(BOOL)animated
{
	//hidden tabbar
	VSTabBarController* currentTabControl = [self visibleViewController].vstabBarController;
	if (currentTabControl && vc.hidesBottomBarWhenPushed) {		
		[currentTabControl hiddenTabBar:YES animated:animated];
		return;
	}	
	
	//show tabbar
	if ([self topViewController].hidesBottomBarWhenPushed &&
		vc.vstabBarController) {
		[vc.vstabBarController hiddenTabBar:NO animated:animated];
		return;
	}
}
*/

- (void)_checkIfModifyTabBar:(UIViewController*)current willAppear:(UIViewController*)next animated:(BOOL)animated
{
	/*
	if (viewController.hidesBottomBarWhenPushed) {
		VSTabBarController* vc = [self topViewController].vstabBarController
		[vc hiddenTabBar:YES animated:animated];
	}
	 if (viewController.hidesBottomBarWhenPushed) {
	 VSTabBarController* vc = [self topViewController].vstabBarController
	 [vc hiddenTabBar:YES animated:animated];
	 }
	*/
	if (current.hidesBottomBarWhenPushed != next.hidesBottomBarWhenPushed) {
		BOOL isNeedHidden = next.hidesBottomBarWhenPushed;
		[current.vstabBarController hiddenTabBar:isNeedHidden
										animated:animated];
	}
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //push 隐藏tabbar的规则,遇到任意hiden=YES,则接下来都为hiden
    /*
	[self _checkIfModifyTabBar:self.visibleViewController
					willAppear:viewController
					  animated:animated];
     */
    if (self.visibleViewController.hidesBottomBarWhenPushed != YES) {
        if (viewController.hidesBottomBarWhenPushed == YES) {
            [self.visibleViewController.vstabBarController hiddenTabBar:YES animated:animated];
        }
    }

	[super pushViewController:viewController animated:animated];

}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
	//the vc that will be poped to be visible to user
	UIViewController* vcWillBeVisible = nil;
	int count = [self.viewControllers count];
	if (count >= 2) {
		vcWillBeVisible = [self.viewControllers objectAtIndex:count -2];
	}
	
	if(vcWillBeVisible){
        /*
		[self _checkIfModifyTabBar:self.visibleViewController
						willAppear:vcWillBeVisible
						  animated:animated];
         */
        
        //当前hiden是唯一的yes
        // pop 返回的规则,当前hiden为yes, 前一个为no, 则显示
        if (self.visibleViewController.hidesBottomBarWhenPushed == YES && vcWillBeVisible.hidesBottomBarWhenPushed == NO) {
            int currentIndex = [self.viewControllers indexOfObject:self.visibleViewController];
            BOOL isTheOnlyHiden = YES;
            for (int i = 0; i< currentIndex; i++) {
                UIViewController* vc = [self.viewControllers objectAtIndex:i];
                if (vc.hidesBottomBarWhenPushed) {
                    isTheOnlyHiden = NO;
                    break;
                }
            }
            if (isTheOnlyHiden) {
                [self.visibleViewController.vstabBarController hiddenTabBar:NO animated:animated];
            }
        }
	}
	
	return [super popViewControllerAnimated:animated];	
}

@end
