//
//  SBLoadingView.h
//  shenbian
//
//  Created by MagicYang on 11-01-24.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define CENTER_FLAG (UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin)

@interface SBLoadingView : NSObject {
	UIView *container;
	UIImageView *loading;
	UILabel *promtLabel;
	UIImageView *spinner;
}

@property (nonatomic, readonly) UIImageView *loading;

- (SBLoadingView *)initWithContainer:(UIView *)v;
- (SBLoadingView *)initWithContainer:(UIView *)v andLoadingText:(NSString *)loadingText;

- (void)show;
- (void)hideWithStatus:(BOOL)successed andText:(NSString *)txt;

@end
