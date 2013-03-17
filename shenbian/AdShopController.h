//
//  AdShopController.h
//  shenbian
//
//  Created by Leeyan on 11-8-2.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

/**
 *	商户跳转广告
 */


#import <Foundation/Foundation.h>
#import "SBAdvertisementView.h"

@interface AdShopController : NSObject {
	NSString *m_shopId;
	SBAdvertisementView *m_delegate;
}

- (id)initWithShopId:(NSString *)shopId andDelegate:(SBAdvertisementView *)delegate;
- (void)gotoShop;

@end
