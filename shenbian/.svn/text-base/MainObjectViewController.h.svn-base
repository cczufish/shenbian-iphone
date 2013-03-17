//
//  AllCategoryViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-31.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"


typedef enum {
	ShowChannel = 0,
	ShowArea    = 1
} ShowType;


@class HttpRequest;
@class SBSegmentView;

@interface MainObjectViewController : SBTableViewController {
	SBSegmentView *segmentedControl;
	
	NSMutableArray *areaList, *categoryList;
	
	ShowType type;
    
    HttpRequest *areaRequest, *channelRequest;
}

@property(assign) ShowType type;

@end
