//
//  SBTextFieldSubtitleCell.h
//  shenbian
//
//  Created by Leeyan on 11-5-18.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VSTextFieldCell.h"

@interface SBTextFieldSubtitleCell : VSTextFieldCell {
	NSString* subtitle;
	
	@private
	UILabel*  subtitleLabel;
}

@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) UILabel*  subtitleLabel;

@end
