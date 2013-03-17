//
//  VSPageView.h
//  shenbian
//
//  Created by xhan on 4/22/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


// this delegate contains datasource too
@class VSPageView;
@protocol VSPageViewDelegate <NSObject>
@required
- (UIView*)pageView:(VSPageView*)pageview viewForPageAtIndex:(NSInteger)index;

@optional
//- (void)pageView:(VSPageView*)pageview willShowViewAtIndex:(NSInteger)index;
- (void)pageView:(VSPageView*)pageview indexChanged:(NSInteger)index;
@end


@interface VSPageView : UIScrollView<UIScrollViewDelegate> {
 @private
//	NSMutableArray* cachesView;
	NSMutableDictionary* cachedViewsDict;
//	int additionCachePageCount;
	int currentIndex;
	
	// might better to move this function to subclass
	//BOOL showPageControl;
	int pageCount;
	id<VSPageViewDelegate> pageDelegate;
	CGSize contentViewOffset;
}

@property(nonatomic,assign) int pageCount;
@property(nonatomic,assign) id  pageDelegate;
@property(nonatomic,assign) int currentIndex;
// the offset for each PageContentView
@property(nonatomic,assign) CGSize contentViewOffset;

// for dynamic loading more pages
//- (void)reloadPageCount;

- (void)_changePageTo:(NSInteger)index;
- (void)_loadPageContentAtIndex:(int)index;
- (void)_cleanUnusedViews;
- (void)_cleanCachedViewsExcept:(NSRange)range;
- (void)cleanCaches;

@end
