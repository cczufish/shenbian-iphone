//
//  SBTabBar.m
//  shenbian
//
//  Created by xhan on 5/9/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBTabBar.h"
#import "VSSegmentCell.h"


@interface SBTabBarCell : VSSegmentCell {
@private
    UIImage* normalImg;
    UIImage* selectedImg;
    UIImageView* imageView;
}
- (id)initWithNormalImg:(UIImage*)nor HighlightImg:(UIImage*)high;
@end

@implementation SBTabBarCell

- (id)initWithNormalImg:(UIImage*)nor HighlightImg:(UIImage*)high
{
    self = [super initWithFrame:vsr(0, 0, nor.size.width, nor.size.height)];
    if (self) {
        normalImg = [nor retain];
        selectedImg = [high retain];
        imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        imageView.clipsToBounds = YES;
        [self addSubview:imageView];
        self.selected = NO;
    }
    return self;
}

- (void)dealloc
{
    VSSafeRelease(normalImg);
    VSSafeRelease(selectedImg);
    VSSafeRelease(imageView);
    [super dealloc];
}

- (void)onViewDidBecameNormal
{
	imageView.image = normalImg;
}

- (void)onViewDidBecameSelected
{
	imageView.image = selectedImg;
}

@end

@implementation SBTabBar

- (id)init
{
    self = [super initWithFrame:vsr(0, 0, 320, 52)];
    if (self) {
        [self _loadTabBar];
    }
    return self;
}

- (void)exchangeCellsAtIndex:(int)indexA by:(int)indexB
{
    UIView* cellA = [self.cells objectAtIndex:indexA];
    UIView* cellB = [self.cells objectAtIndex:indexB];
    
    CGPoint tmpFrame = cellA.origin;
    cellA.origin = cellB.origin;
    cellB.origin = tmpFrame;
    
    [self.cells exchangeObjectAtIndex:indexA withObjectAtIndex:indexB];
    
}

- (void)_loadTabBar
{
    
    [self addSubview:[T imageViewNamed:@"tabbar_bg.png"]];
    SBTabBarCell* discoveryTab = [[SBTabBarCell alloc] initWithNormalImg:PNGImage(@"tab_discovery_n") HighlightImg:PNGImage(@"tab_discovery_h")];
    SBTabBarCell* searchTab = [[SBTabBarCell alloc] initWithNormalImg:PNGImage(@"tab_search_n") HighlightImg:PNGImage(@"tab_search_h")];
    SBTabBarCell* meTab = [[SBTabBarCell alloc] initWithNormalImg:PNGImage(@"tab_me_n") HighlightImg:PNGImage(@"tab_me_h")];
    SBTabBarCell* moreTab = [[SBTabBarCell alloc] initWithNormalImg:PNGImage(@"tab_more_n") HighlightImg:PNGImage(@"tab_more_h")];
    btnTakePhoto = [[T createBtnfromPoint:CGPointZero
                                   image:PNGImage(@"tab_camera_n")
                            highlightImg:PNGImage(@"tab_camera_h")
                                  target:nil
                                 selector:NULL] retain];
    
    //setup positions
    discoveryTab.bottom = self.height;
    
    searchTab.bottom = self.height;
    searchTab.left = discoveryTab.right;
    
    btnTakePhoto.bottom = self.height;
    btnTakePhoto.left = searchTab.right;
    
    meTab.bottom = self.height;
    meTab.left = btnTakePhoto.right;
    
    moreTab.bottom = self.height;
    moreTab.left = meTab.right;
    
    [self addCells:VSArray(discoveryTab,searchTab,meTab,moreTab)];
    [self addSubview:btnTakePhoto];
    
    VSSafeRelease(discoveryTab);
    VSSafeRelease(searchTab);
    VSSafeRelease(meTab);
    VSSafeRelease(moreTab);
}

- (void)cameraBtnAddTarget:(id)target action:(SEL)action
{
    [btnTakePhoto addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

- (void)dealloc{
    VSSafeRelease(btnTakePhoto);
    [super dealloc];
}
@end
