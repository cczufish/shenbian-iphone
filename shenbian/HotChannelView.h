//
//  HotChannelView.h
//  shenbian
//
//  Created by MagicYang on 10-12-31.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SBCategory;

@protocol HotChannelViewDelegate

- (void)goChannelSearch:(SBCategory *)ch;

@end


@interface HotChannelView : UIView {
	id delegate;
	NSArray *items;
	NSMutableArray *buttons;
}

@property(nonatomic, retain) NSArray *items;
@property(nonatomic, assign) id delegate;

- (id)initWithDelegate:(id)del andItems:(NSArray *)item;
- (void)show;

@end