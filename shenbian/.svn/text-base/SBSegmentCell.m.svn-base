//
//  SBSegmentCell.m
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBSegmentCell.h"

const int SBSegmentCellWidth =54;
const int SBSegmentCellHeight =30;
#define SBSegmentCellColorNormal [T colorR:0xc3 g:0x00 b:0x00]
#define SBSegmentCellColorHover  [UIColor whiteColor]

@implementation SBSegmentCell
- (id)initWithType:(SBSegmentCellType)type title:(NSString*)title
{
	self = [super initWithFrame:CGRectMake(0, 0, SBSegmentCellWidth, SBSegmentCellHeight)];
	
	//background view
	switch (type) {
		case SBSegmentCellTypeLeft:
			self.backgroundColor = [UIColor clearColor];
			_imgNormal = [UIImage imageNamed:@"sb_segment_left_n.png"];
			_imgHover  = [UIImage imageNamed:@"sb_segment_left_h.png"];
			break;
		case SBSegmentCellTypeMid:
			_imgNormal = [UIImage imageNamed:@"sb_segment_mid_n.png"];
			_imgHover  = [UIImage imageNamed:@"sb_segment_mid_h.png"];
			break;
		case SBSegmentCellTypeRight:
			self.backgroundColor = [UIColor clearColor];
			_imgNormal = [UIImage imageNamed:@"sb_segment_right_n.png"];
			_imgHover  = [UIImage imageNamed:@"sb_segment_right_h.png"];
			break;	
		default:
			[NSException raise:@"WTF" format:@"F**"];
	}
    
    _imgNormal = [[_imgNormal stretchableImageWithLeftCapWidth:20 topCapHeight:0] retain];
    _imgHover  = [[_imgHover  stretchableImageWithLeftCapWidth:20 topCapHeight:0] retain];
    
	_bgView = [[UIImageView alloc] initWithImage:_imgNormal];
	[self addSubview:_bgView];
	
	//title label
	_titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_titleLabel.height = 22;
	_titleLabel.top = 4;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = FontWithSize(16);
	_titleLabel.textAlignment = UITextAlignmentCenter;
	_titleLabel.text = title;
	_titleLabel.textColor = SBSegmentCellColorNormal;
	[self addSubview:_titleLabel];
	
	return self;
}

- (void)setCellWidth:(CGFloat)w
{
    self.width = w;
    _bgView.width = w;
    _titleLabel.width = w;
}

- (void)onViewDidBecameNormal
{
	_bgView.image = _imgNormal;
	_titleLabel.textColor = SBSegmentCellColorNormal;
}
- (void)onViewDidBecameSelected
{
	_bgView.image = _imgHover;	
	_titleLabel.textColor = SBSegmentCellColorHover;
}

- (void)dealloc{
	VSSafeRelease(_titleLabel);
	VSSafeRelease(_bgView);
	VSSafeRelease(_imgHover);
	VSSafeRelease(_imgNormal);
	[super dealloc];
}
@end
