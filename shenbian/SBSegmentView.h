//
//  SBSegmentView.h
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VSSegmentView.h"

@interface SBSegmentView : VSSegmentView {

}

- (id)init;

// data should be array with nsstring objects
- (void)setDatasource:(NSArray*)source;
- (void)setCellWidth:(CGFloat)w;

@end
