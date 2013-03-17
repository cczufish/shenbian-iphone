//
//  SBTextFieldCell.m
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import "VSTextFieldCell.h"


@implementation VSTextFieldCell

@synthesize delegate;
@synthesize label = _label;
@synthesize textField = _textField;

- (id)initWithDelegate:(id)del reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.delegate = del;
		CGRect rect = self.frame;
		_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 80, rect.size.height - 10)];
		_label.font = FontWithSize(16);
		_label.backgroundColor = [UIColor clearColor];
		
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(100, 5, 200, rect.size.height - 10)];
		_textField.font = FontWithSize(16);
		_textField.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
		[_textField addTarget:delegate action:@selector(searchTextChanged:) forControlEvents:UIControlEventEditingChanged];
        
		[self.contentView addSubview:_label];
		[self.contentView addSubview:_textField];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	Release(_label);
	Release(_textField);
    [super dealloc];
}

@end
