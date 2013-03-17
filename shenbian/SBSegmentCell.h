//
//  SBSegmentCell.h
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "VSSegmentCell.h"

//A basic SBSegment sytle cell contains two status backgroundView(red and white one), and a textLabel in the center.

typedef enum
{
	SBSegmentCellTypeLeft,
	SBSegmentCellTypeMid,
	SBSegmentCellTypeRight
}SBSegmentCellType;

extern const int SBSegmentCellWidth;
extern const int SBSegmentCellHeight;

@interface SBSegmentCell : VSSegmentCell {
	UILabel* _titleLabel;
	UIImageView* _bgView;
	UIImage* _imgNormal;
	UIImage* _imgHover;
}

- (id)initWithType:(SBSegmentCellType)type title:(NSString*)title;
- (void)setCellWidth:(CGFloat)w;

@end
