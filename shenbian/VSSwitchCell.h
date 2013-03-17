//
//  VSSwitchCell.h
//  shenbian
//
//  Created by MagicYang on 6/13/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface VSSwitchCell : UITableViewCell {
    id delegate;
	UILabel *_label;
	UISwitch *_switchView;
}

@property(nonatomic, retain, readonly) UILabel *label;
@property(nonatomic, retain, readonly) UISwitch *switchView;
@property(nonatomic, assign) id delegate;

- (id)initWithDelegate:(id)del reuseIdentifier:(NSString *)reuseIdentifier;

@end
