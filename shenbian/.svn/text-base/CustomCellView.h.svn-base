//
//  CustomCellView.h
//  shenbian
//
//  Created by MagicYang on 10-11-24.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CustomCellView : UIView {
	id dataModel;
	BOOL isHighlighted;
    BOOL noSeperator; // 不画虚线
}

@property(nonatomic, retain) id dataModel;
@property(nonatomic, assign) BOOL noSeperator;

+ (NSInteger)heightOfCell:(id)data;

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated;

@end
