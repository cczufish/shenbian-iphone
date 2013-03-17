//
//  AdShopController.m
//  shenbian
//
//  Created by Leeyan on 11-8-2.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "AdShopController.h"
#import "ShopInfoViewController.h"

@implementation AdShopController

- (id)initWithShopId:(NSString *)shopId andDelegate:(SBAdvertisementView *)delegate {
	if (self = [super init]) {
		m_shopId = shopId;
		m_delegate = delegate;
	}
	return self;
}

- (void)pushShop:(NSString *)shopId {
	ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shopId];
	controller.hidesBottomBarWhenPushed = YES;
	[m_delegate.sender.navigationController pushViewController:controller animated:YES];
	[controller release];
}

- (void)gotoShop {
	[m_delegate doBack];
	[self pushShop:m_shopId];
}

@end
