//
//  SBTextFieldCell.h
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VSTextFieldCell : UITableViewCell {
	id delegate;
	UILabel *_label;
	UITextField *_textField;
}

@property(nonatomic, retain, readonly) UILabel *label;
@property(nonatomic, retain, readonly) UITextField *textField;
@property(nonatomic, assign) id delegate;

- (id)initWithDelegate:(id)del reuseIdentifier:(NSString *)reuseIdentifier;

@end

