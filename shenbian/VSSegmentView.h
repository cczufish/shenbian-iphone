//
//  VSSegmentView.h
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>

@class VSSegmentView;
@protocol VSSegmentViewDelegate<NSObject>

@optional
- (BOOL)segment:(VSSegmentView*)view willClickAtIndex:(int)index onCurrentCell:(BOOL)isCurrent;
- (void)segment:(VSSegmentView*)view clickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent;

@end

@class VSSegmentCell;
@interface VSSegmentView : UIView {
	NSMutableArray* _items;
//	UIImageView* _backgroundImageView;
	int _selectedIndex;
	id<VSSegmentViewDelegate> delegate;
}

@property (nonatomic, readonly) NSMutableArray* cells;
@property (nonatomic, assign) int selectedIndex;
@property (nonatomic, assign) id delegate;


- (void)addCells:(NSArray*)cells;

- (void)addCell:(VSSegmentCell*)cell;

- (void)cleanCells;

@end
