//
//  PhotoUploadSuccessVC.h
//  shenbian
//
//  Created by xhan on 5/9/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"

typedef enum {
	LITTLE_PHOTOGRAPHER = 1
} MedalType;

@interface PhotoUploadSuccessVC : SBNavigationController //UIViewController
	<UITableViewDelegate,UITableViewDataSource>
{
	UITableView *tableView;
	
	UILabel*	_trVal1;
	UILabel*	_trVal2;
	
	NSDictionary*	_dict;
	
	NSArray*		_badge;
}

@property (nonatomic, retain) UILabel* _trVal1;
@property (nonatomic, retain) UILabel* _trVal2;
@property (nonatomic, retain) UITableView*	_tableView;

- (UIView *)headerViewMaxPhotoUploadToday;
- (UIView*)setTreasureValue1:(NSInteger)val1 value2:(NSInteger)val2;
- (UIView *)headerViewTreasureList:(NSArray *)array;

- (id)initWithResults:(NSDictionary*)dict;

@end























