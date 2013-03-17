//
//  CityListViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-13.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBPickerViewController.h"


@class Area;

@interface ProvincePickerViewController : SBPickerViewController {
	NSMutableArray *provinceList;
	NSMutableArray *hotCityList;
	
	BOOL isCascadeCity;
	BOOL needLocating;
	BOOL isForceChoose; // 不提供返回按钮
    
	Area *currentArea;
}

@property(assign) BOOL isCascadeCity;
@property(assign) BOOL needLocating;
@property(assign) BOOL isForceChoose;
@property(nonatomic, retain) Area *currentArea;

@end
