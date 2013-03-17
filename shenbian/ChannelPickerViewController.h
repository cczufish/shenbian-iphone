//
//  ChannelPickerViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-20.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerViewController.h"


@interface ChannelPickerViewController : SBPickerViewController {
	NSMutableArray *channelList;
	NSMutableDictionary *subChannelList;
	NSInteger cityId;
}

@property(nonatomic, retain) NSMutableArray *channelList;
@property(nonatomic, retain) NSMutableDictionary *subChannelList;
@property(nonatomic, assign) NSInteger cityId;

@end
