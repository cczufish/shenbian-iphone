//
//  SubObjectViewController.h
//  shenbian
//
//  Created by MagicYang on 11-1-6.
//  Copyright 2011 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBTableViewController.h"


typedef enum {
	AreaObject = 0,
	ChannelObject = 1
} ObjectType;	

@interface SubObjectViewController : SBTableViewController {
	ObjectType type;
	NSArray *objectList;
}

@property(assign) ObjectType type;
@property(nonatomic, retain) NSArray *objectList;

@end
