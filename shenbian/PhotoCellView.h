//
//  PhotoCellView.h
//  shenbian
//
//  Created by Leeyan on 11-7-13.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PhotoCellView : UIView {
	UIImageView *preloadingImageView;
	UIImage *image;
	UIButton *imageButton;

	id delegate;
	SEL action;
	
	id extra;
	BOOL isLoaded;
}

@property(nonatomic, readonly) UIImageView *preloadingImageView;
@property(nonatomic, readonly) UIButton *imageButton;
@property(nonatomic, retain) UIImage *image;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)_delegate photoPressedAction:(SEL)_action andExtra:(id)_extra;

@end
