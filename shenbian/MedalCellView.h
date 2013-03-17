//
//  MedalCellView.h
//  shenbian
//
//  Created by Leeyan on 11-5-10.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest+Statistic.h"
#import "CustomCellView.h"


@interface MedalCellView : CustomCellView {

}

@end


@interface MedalModel : NSObject
{	
	UIImage* icon;
	NSString* iconURL;
	NSString* name;
	HttpRequest* hcImgFetcher;
	BOOL isImgFetched;
}

@property(nonatomic,retain)UIImage* icon;
@property(nonatomic,copy)NSString* name;
@property(nonatomic,copy)NSString* iconURL;

- (void)loadImageResource;

@end 