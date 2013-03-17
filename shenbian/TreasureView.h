//
//  TreasureView.h
//  shenbian
//
//  Created by Leeyan on 11-5-10.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TreasureView : UIView {
	NSDictionary	*_treasures;
	
	unsigned int _iTreasureTop;
	unsigned int _iTreasureLeft;
	unsigned int _iTreasureCellHeight;
	unsigned int _iTreasureCellWidth;
	
}

@end
