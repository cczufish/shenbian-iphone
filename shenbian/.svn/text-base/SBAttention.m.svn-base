//
//  SBAttention.m
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "SBAttention.h"
#import "HttpRequest.h"
@implementation SBAttention
@synthesize uFcrid;
@synthesize uName;
@synthesize uAvatar;
@synthesize followedCount,shopTotal;
@synthesize uVip;
@synthesize grade;
@synthesize gradeId;
@synthesize attention;
@synthesize sName;
@synthesize time;
@synthesize img;
@synthesize showImg;
- (void)dealloc {
    [showImg release];
    [uFcrid release];
    [uName release];
    [sName release];
    [img release];
    [super dealloc];
}
- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)setUAvatar:(NSString *)url {
	if ([uAvatar isEqual:url]) {
		return;
	}
	[uAvatar release];
	//	imgUrl = [[url stringByAppendingString:@".jpg"] retain];
    uAvatar = [url retain];
    
	UIImage *imgInDisk = [[SDImageCache sharedImageCache] imageFromKey:uAvatar];
	if (imgInDisk) {
		self.img = imgInDisk;
	} else {
		if (uAvatar) {
			CancelRequest(request);
			request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
			[request requestGET:uAvatar];
		}
	}
}
#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
	if (req.statusCode == 200) {
		self.img = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:img imageData:UIImagePNGRepresentation(img) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
        showImg.image=self.img;
	}
	
	Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Release(request);
}

@end
