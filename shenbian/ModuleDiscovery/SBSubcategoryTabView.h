//
//  SBSubcategoryTabView.h
//  shenbian
//
//  Created by xhan on 4/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBSubcategoryTabCell.h"

@class VSSegmentView;
@interface SBSubcategoryTabView : UIScrollView<VSSegmentViewDelegate> {
    SBSubcategoryTabCellWrapper* _segmentView;
	int _innerContentWidth;
}

// data should be array with nsstring objects
- (void)setDatasource:(NSArray*)source;
- (id)initWithFixedSize;

//VSSegmentViewDelegate
@property(nonatomic,assign) id delegate;
@property(nonatomic,readonly) VSSegmentView* segmentView;
@end
