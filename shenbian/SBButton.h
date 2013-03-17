//
//  SBButton.h
//  shenbian
//
//  Created by MagicYang on 11-1-13.
//  Copyright 2011 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


// For anti-aliasing
@interface SBButton : UIView {
	UIImage *normalImage, *highlightImage;
	UIControlState _state;
	
	id delegate;
	SEL action;
	
	NSString *title;
	NSMutableDictionary *_titleColorDict, *_backgroundColorDict;
	UITextAlignment titleAlignment;
}

@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) UIFont *titleFont;
@property(nonatomic, assign) UITextAlignment titleAlignment;

@property(nonatomic, retain) UIImage *normalImage;
@property(nonatomic, retain) UIImage *highlightImage;

@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) SEL action;

- (void)setTitleColor:(UIColor *)color forState:(UIControlState)state;
- (void)setBackgroundColor:(UIColor *)color forState:(UIControlState)state;
- (void)setImage:(UIImage *)image forState:(UIControlState)state;
- (void)addTarget:(id)target action:(SEL)act forControlEvents:(UIControlEvents)controlEvents;

@end
