//
//  SearchResultCellView.h
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellView.h"


@interface SearchResultCellView : CustomCellView {
	BOOL showDistance;
	BOOL showTag;
}

@property(assign) BOOL showDistance;
@property(assign) BOOL showTag;

@end
