//
//  SearchResultsHeader.h
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SBPickerButton;
@class SBSubcategoryTabView;

@interface SearchResultsHeader : UIView {
    id delegate;
	NSArray *sortTerms;
	NSString *leftTitle, *rightTitle;
	SBPickerButton *leftButton, *rightButton;
    SBSubcategoryTabView *headerTabView;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSString *leftTitle;
@property(nonatomic, retain) NSString *rightTitle;

- (id)initWithDelegate:(id)del andFrame:(CGRect)frame;

@end
