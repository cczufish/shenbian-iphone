//
//  VSSwitchCell.m
//  shenbian
//
//  Created by MagicYang on 6/13/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSSwitchCell.h"


@implementation VSSwitchCell

@synthesize delegate;
@synthesize label = _label;
@synthesize switchView = _switchView;

- (id)initWithDelegate:(id)del reuseIdentifier:(NSString *)reuseIdentifier {
    if ((self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier])) {
		self.delegate = del;
		CGRect rect = self.frame;
		_label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 180, rect.size.height - 10)];
		_label.font = FontWithSize(16);
		_label.backgroundColor = [UIColor clearColor];
		
        _switchView = [[UISwitch alloc] initWithFrame:CGRectMake(200, 5, 50, rect.size.height - 10)];        
		[_switchView addTarget:delegate action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        
		[self.contentView addSubview:_label];
		[self.contentView addSubview:_switchView];
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    //    [super setSelected:selected animated:animated];
}

- (void)dealloc {
	Release(_label);
	Release(_switchView);
    [super dealloc];
}

@end
