//
//  SBThumbsViewController.h
//  shenbian
//
//  Created by MagicYang on 10-12-8.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KTThumbsViewController.h"


@class HttpRequest;
@class SBImageDataSource;

@interface SBThumbsViewController : KTThumbsViewController {
	NSInteger total;
	HttpRequest *request;
	NSArray *imageLinks;
	SBImageDataSource *images;
}

@property(nonatomic, retain) NSArray *imageLinks;

- (SBThumbsViewController *)initWithLinks:(NSArray *)links;

@end
