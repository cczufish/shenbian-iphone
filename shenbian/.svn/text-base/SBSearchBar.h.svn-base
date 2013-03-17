//
//  SBSearchBar.h
//  shenbian
//
//  Created by MagicYang on 10-12-14.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBSearchBar : UIView<UITextFieldDelegate> {
	id delegate;
	UITextField *textField;
	UIView      *titleView;
	UIImageView *sawtooth;
    
	NSString *searchText;
	UIButton *historyButton;
	
	BOOL isAlwaysShowHistoryButton;
	BOOL isAlwaysHideHistoryButton;
}

@property(nonatomic, assign) BOOL isAlwaysShowHistoryButton;
@property(nonatomic, assign) BOOL isAlwaysHideHistoryButton;
@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSString *searchText;

- (id)initWithFrame:(CGRect)frame delegate:(id)del andTitleView:(UIView *)ttView;
- (void)setPlaceHolder:(NSString *)txt;
- (BOOL)becomeFirstResponder;
- (BOOL)resignFirstResponder;
- (BOOL)isFirstResponder;
- (void)disable;

- (void)showHistoryButton;
- (void)hideHistoryButton;

- (void)showSawtooth;
- (void)hideSawtooth;

@end


@protocol SBSearBarDelegate

@optional
- (void)searchBarDidBeginEditing:(SBSearchBar *)bar;
- (void)searchBarDidChange:(SBSearchBar *)bar;
- (void)searchBarDidEndEditing:(SBSearchBar *)bar;
- (void)searchBarSearch:(SBSearchBar *)bar;
- (void)searchBarCleared:(SBSearchBar *)bar;
- (void)showHistory:(SBSearchBar *)bar;

@end