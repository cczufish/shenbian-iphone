//
//  SBUser.m
//  shenbian
//
//  Created by MagicYang on 5/13/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBUser.h"
#import "HttpRequest+Statistic.h"
#import "SDImageCache.h"
#import "Utility.h"

@implementation SBUser

@synthesize uid, name;
@synthesize imgUrl, img;
@synthesize level;
@synthesize photoCount, beenCount, badgeCount;
@synthesize mammon;
@synthesize isWeiboBind;
@synthesize isVIP;
@synthesize funsCount,attentionCount;

- (void)setImgUrl:(NSString *)url {
	if ([imgUrl isEqual:url]) {
		return;
	}
	[imgUrl release];
	//	imgUrl = [[url stringByAppendingString:@".jpg"] retain];
    imgUrl = [url retain];
    
	UIImage *imgInDisk = [[SDImageCache sharedImageCache] imageFromKey:imgUrl];
	if (imgInDisk) {
		self.img = imgInDisk;
	} else {
		if (imgUrl) {
			CancelRequest(request);
			request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
			[request requestGET:imgUrl];
		}
	}
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
	if (req.statusCode == 200) {
		self.img = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:img imageData:UIImagePNGRepresentation(img) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
	}
	
	Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Release(request);
}


+ (void)drawUserAvatarWithImage:(UIImage *)image atRect:(CGRect)rect andIsVIP:(BOOL)isVIP {
	CGContextRef ctx = UIGraphicsGetCurrentContext();	
	
	CGContextSaveGState(ctx);
	[Utility clipContext:ctx toRoundedCornerWithRect:rect andRadius:4];
	[image drawInRect:rect];
	
	//vip
	if (isVIP) {
		UIImage *imgVip = PNGImage(@"v");
		[imgVip drawInRect:vsr(rect.origin.x + rect.size.width - imgVip.size.width, 
							   rect.origin.y + rect.size.height - imgVip.size.height,
							   imgVip.size.width, imgVip.size.height)];
	}
	CGContextRestoreGState(ctx);
	
}


- (void)dealloc
{
    [uid release];
    [name release];
    [imgUrl release];
    [img release];
    [super dealloc];
}

- (void)cleanProfile
{
    self.uid = nil;
    self.name = nil;
    self.imgUrl = nil;
    self.img = nil;
    self.level = 0;
    self.photoCount = self.beenCount = self.badgeCount = 0;
    self.mammon = 0;
    self.isWeiboBind = NO;
	self.isVIP = NO;
    self.funsCount=self.attentionCount=0;
}

@end
