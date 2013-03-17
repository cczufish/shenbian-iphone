//
//  SBSubcategoryTabCell.h
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSegmentCell.h"
#import "VSSegmentView.h"

@interface SBSubcategoryTabCell : VSSegmentCell
{
	NSString* _name;
	UIImageView* _selectedIndicator;
	UILabel* _titleLabel;
}

- (id)initWithFrame:(CGRect)frame name:(NSString*)name;
//private
- (UIImageView*)_selectedIndicator;

@end

@interface SBSubcategoryTabCellWrapper : VSSegmentView
{
	
}



@end
