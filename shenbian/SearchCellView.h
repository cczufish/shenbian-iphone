//
//  SearchCellView.h
//  shenbian
//
//  Created by MagicYang on 5/5/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CustomCellView.h"


@interface SearchShopCellView : CustomCellView {
    
}

@end


@interface SearchSuggestCellView : CustomCellView {
    UIImage *icon;
}

@property(nonatomic, retain) UIImage *icon;

@end