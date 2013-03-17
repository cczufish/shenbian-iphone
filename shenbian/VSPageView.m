//
//  VSPageView.m
//  shenbian
//
//  Created by xhan on 4/22/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSPageView.h"


@implementation VSPageView

@synthesize pageCount, pageDelegate, currentIndex, contentViewOffset;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        self.pagingEnabled = YES;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.scrollsToTop = NO;
		self.delegate = self;
		self.alwaysBounceHorizontal = YES;
//		self.delaysContentTouches = YES; //default is yes
		
		/*
		_pageControl = [[UIPageControl alloc] init];
		_pageControl.numberOfPages = pages;
		_pageControl.currentPage = 0 ;
		[_pageControl sizeToFit];
		[self.view addSubview:_pageControl];
		_pageControl.center = CGPointMake(self.view.center.x , self.view.frame.size.height - _pageControl.frame.size.height / 2);
		[_pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
		 */
		
		currentIndex = 0;
		pageCount = 0;
		cachedViewsDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}



- (void)dealloc 
{	
	VSSafeRelease(cachedViewsDict);
    [super dealloc];
}


#pragma mark ScrollView Delegate methods;
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
	/*
	if (_pageControlUsed) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	 */
	int page = floor((self.contentOffset.x - self.width / 2) / self.width) + 1;
//    _pageControl.currentPage = page;
	
	[self setCurrentIndex:page];
	
}

/*
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    NSLog(@"did end");
	if ([pageDelegate respondsToSelector:@selector(pageView:indexChanged:)]) {
        [pageDelegate pageView:self indexChanged:currentIndex];
    }
}
 */

- (void)_changePageTo:(NSInteger)index
{
	[self _loadPageContentAtIndex:index - 1];
	[self _loadPageContentAtIndex:index];
	[self _loadPageContentAtIndex:index + 1];
}

- (void)_loadPageContentAtIndex:(int)index
{
	if (index >=0 && index < pageCount) {
		UIView* view = [cachedViewsDict objectForKey:NUM(index)];
		if (view) {
			[self addSubview:view];
		}else {
			view = [pageDelegate pageView:self viewForPageAtIndex:index];
			[cachedViewsDict setObject:view forKey:NUM(index)];
			view.origin = ccp(contentViewOffset.width + index*self.width,
							  contentViewOffset.height );
			[self addSubview:view];
		}
		 
	}
}

- (void)cleanCaches
{
	[self _cleanUnusedViews];
}

- (void)_cleanUnusedViews
{
	[self _cleanCachedViewsExcept:NSMakeRange(currentIndex -1, 3)];
}

- (void)_cleanCachedViewsExcept:(NSRange)range
{
	for (int i = 0; i < pageCount; i++) {
		if(i < range.location || i >= range.location + range.length)
		{
			UIView* cachedView = [cachedViewsDict objectForKey:NUM(i)];
			if (cachedView) {
				[cachedView removeFromSuperview];
				[cachedViewsDict removeObjectForKey:NUM(i)]; 
			}
		}
	}
}

- (void)setCurrentIndex:(int)index
{
	if (index != currentIndex && index >=0 && index < pageCount) {
		currentIndex = index;
		[self _changePageTo:currentIndex];
        if ([pageDelegate respondsToSelector:@selector(pageView:indexChanged:)]) {
            [pageDelegate pageView:self indexChanged:currentIndex];
        }
	}
}

- (void)setPageCount:(int)value
{
	if (!pageDelegate) {
		[NSException raise:@"pageDelegate should not be nil" format:@"!!"];
	}
	pageCount = value;
	self.contentSize = CGSizeMake(self.width* pageCount, self.height );
	[self _changePageTo:currentIndex];
}


@end
