//
//  SBBadge.m
//  shenbian
//
//  Created by xhan on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBBadge.h"
#import "SDImageCache.h"
#import "HttpRequest+Statistic.h"


@implementation SBBadge
@synthesize bid, name, picURL, description, isPromo, promoInfo;
@synthesize picImage, picBigURL;
@synthesize useableCount, userId;

- (id)initWithRemoteDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        if (!bid)     self.bid = VSDictV(dict, @"id");
        if (!name)    self.name = VSDictV(dict, @"name");
        if (!description) self.description = VSDictV(dict, @"desc");
        if (!picURL)  self.picURL = VSDictV(dict, @"pic");
        self.isPromo = [VSDictV(dict, @"is_promo") boolValue];
        self.promoInfo = VSDictV(dict, @"promo");
        self.useableCount = [VSDictV(dict, @"use") intValue];
    }
    
    return self;
}

- (void)dealloc
{
    CancelRequest(request);
    VSSafeRelease(bid);
    VSSafeRelease(name);
    VSSafeRelease(picURL);
    VSSafeRelease(description);
    VSSafeRelease(promoInfo);
    VSSafeRelease(picImage);
    VSSafeRelease(picBigURL);
	VSSafeRelease(userId);
    [super dealloc];
}

- (void)fetchPicByURL:(NSString*)url
{
	UIImage *imgInDisk = [[SDImageCache sharedImageCache] imageFromKey:url];
	if (imgInDisk) {
		self.picImage = imgInDisk;
	} else {
		if (url) {
			CancelRequest(request);
			request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
			[request requestGET:url];
		}
	}
}

#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
	if (req.statusCode == 200) {
		self.picImage = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:picImage imageData:UIImagePNGRepresentation(picImage) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
	}
	
	Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Release(request);
}


@end
