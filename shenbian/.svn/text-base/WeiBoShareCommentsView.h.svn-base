//
//  WeiBoShareCommentsView.h
//  shenbian
//
//  Created by xu xhan on 5/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>



@protocol WeiBoShareCommentsViewDelegate;
@interface WeiBoShareCommentsView : UIView
{
    id<WeiBoShareCommentsViewDelegate> delegate;
    UIView* containerView;
    UITextView* textView;
}

- (id)initWithDelegate:(id)delegate;

- (void)showInWindow:(UIWindow*)win;
- (void)showInMainWindow;
- (void)dismiss;

@property(nonatomic,assign)id withOjbAssign;

//privates
- (void)_setupSubviews;
- (void)_showKeyboard;
- (void)_hidenKeyboard;
@end


@protocol WeiBoShareCommentsViewDelegate <NSObject>

- (void)weiboShareView:(WeiBoShareCommentsView*)view cancelBtnPressed:(NSString*)content;
- (void)weiboShareView:(WeiBoShareCommentsView*)view confirmBtnPressed:(NSString*)content;

@end