//
//  SBSubcategoryTabCell.m
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBSubcategoryTabCell.h"
//////////////////////////////////////////////////////////////////////

#define SBSubcategoryTabCellLabelColorNormal [T colorR:0x54 g:0x54 b:0x54]
#define SBSubcategoryTabCellLabelColorHighlight [T colorR:0xc3 g:0x00 b:0x00]

@implementation SBSubcategoryTabCell

- (id)initWithFrame:(CGRect)aframe name:(NSString*)name
{

	self = [self initWithFrame:aframe];
	self.backgroundColor = [UIColor clearColor];
	_name = [name copy];
	
	_titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
	_titleLabel.height = 22;
	_titleLabel.top = 4;
    _titleLabel.left -= 1;
	_titleLabel.backgroundColor = [UIColor clearColor];
	_titleLabel.font = FontWithSize(16);
	_titleLabel.textAlignment = UITextAlignmentCenter;
	_titleLabel.text = _name;
	_titleLabel.textColor = SBSubcategoryTabCellLabelColorNormal;
	
	[self addSubview:_titleLabel];
	
	return self;	
}

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
		self.selected = NO;
		self.highlighted = NO;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}



- (void)dealloc {
	VSSafeRelease(_selectedIndicator);
	VSSafeRelease(_name);
	VSSafeRelease(_titleLabel);
    [super dealloc];
}

- (UIImageView*)_selectedIndicator
{
	if (!_selectedIndicator) {
		_selectedIndicator = [[T imageViewNamed:@"listcategory_tab_selected.png"] retain];
        
		_selectedIndicator.left = 13;
		_selectedIndicator.top = 4;
		_selectedIndicator.animationImages = 
		[NSArray arrayWithObjects:
		 PNGImage(@"listcategory_tab_selected1"),
		 PNGImage(@"listcategory_tab_selected2"),
		 PNGImage(@"listcategory_tab_selected3"),
		 PNGImage(@"listcategory_tab_selected4"),
		 PNGImage(@"listcategory_tab_selected5"),
		 PNGImage(@"listcategory_tab_selected6"),nil
		 ];
		_selectedIndicator.animationDuration = 0.3;
		_selectedIndicator.animationRepeatCount = 1;
	}
	return _selectedIndicator;
}



- (void)onViewDidBecameNormal
{
	_titleLabel.textColor = SBSubcategoryTabCellLabelColorNormal;
	if ([_selectedIndicator superview]) {
		[_selectedIndicator stopAnimating];
		[_selectedIndicator removeFromSuperview];
	}
}
- (void)onViewDidBecameSelected
{
	_titleLabel.textColor = SBSubcategoryTabCellLabelColorHighlight;	    
	[self addSubview:[self _selectedIndicator]];
    [self  bringSubviewToFront:_titleLabel];
	[_selectedIndicator startAnimating];
	
//	[[UIImageView alloc] ini]
//	UIImageView* imgView = [self _selectedIndicator];
	
}

- (void)setHighlighted:(BOOL)value{
	[super setHighlighted:value];
	if (value == YES) {
		_titleLabel.textColor = SBSubcategoryTabCellLabelColorHighlight;
	}else {
		if (self.selected) {
			_titleLabel.textColor = SBSubcategoryTabCellLabelColorHighlight;
		}else {
			_titleLabel.textColor = SBSubcategoryTabCellLabelColorNormal;
		}

	}

}

@end

///////////////////////////////////////////////////////////////
@implementation SBSubcategoryTabCellWrapper

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	self.backgroundColor = [UIColor clearColor];
	return self;
}

#define LeftTag 87001
#define RightTag 87002
#define OffsetSize 3
- (void)layoutSubviews
{
    UIImage* tiledImg = [UIImage imageNamed:@"listcategory_tab_bg.png"]; 
    float imgWidth = tiledImg.size.width;
    //check if have the offsets view
    if (![self viewWithTag:LeftTag]) {
        //left part
        UIView* leftView = [[UIView alloc] initWithFrame:self.bounds];
        leftView.width = OffsetSize * imgWidth;
        leftView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i<OffsetSize; i++) {
            UIView* v = [T imageViewNamed:@"listcategory_tab_bg.png"];
            v.left = i * imgWidth;
            [leftView addSubview:v];
        }
        [self addSubview:leftView];
        leftView.tag = LeftTag;
        [leftView release];
        leftView.right = 0;
        
        //right part
        UIView* rightView = [[UIView alloc] initWithFrame:self.bounds];
        rightView.width = OffsetSize * imgWidth;
        rightView.backgroundColor = [UIColor clearColor];
        for (int i = 0; i<OffsetSize; i++) {
            UIView* v = [T imageViewNamed:@"listcategory_tab_bg.png"];
            v.left = i * imgWidth;
            [rightView addSubview:v];
        }
        [self addSubview:rightView];
        rightView.tag = RightTag;
        [rightView release];
//        rightView.left = self.width;
    }
    UIView* rightView = [self viewWithTag:RightTag];
    rightView.left = self.width;
    [super layoutSubviews];     
}

- (void)drawRect:(CGRect)rect
{
	UIImage* tiledImg = [UIImage imageNamed:@"listcategory_tab_bg.png"]; 
	float imgWidth = tiledImg.size.width;
	int xPos = 0;
	
	while (xPos <= rect.size.width) {
		[tiledImg drawAtPoint:CGPointMake(xPos, 0)];
		xPos += imgWidth ;
	}
}

@end
