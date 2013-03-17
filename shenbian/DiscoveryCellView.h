//
//  DiscoveryCellView.h
//  shenbian
//
//  Created by xhan on 4/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellView.h"

@interface DiscoveryCellView : CustomCellView {
    // latest tab displayed createdTime instead distance info
    BOOL isLatestTab;
    BOOL isAlbumStyle;  //displayed createdTime , and not show the voteThumb 
}

@property(nonatomic,assign) BOOL isLatestTab;
@property(nonatomic,assign) BOOL isAlbumStyle;

+ (NSInteger)heightOfCell:(id)model;

@end
