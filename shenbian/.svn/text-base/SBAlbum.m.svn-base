//
//  SBAlbum.m
//  shenbian
//
//  Created by MagicYang on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBAlbum.h"
#import "HttpRequest+Statistic.h"
#import "SDImageCache.h"
#import "CacheCenter.h"


@implementation SBPhoto

@synthesize photoId;
@synthesize title;
@synthesize url;
@synthesize img;
@synthesize date;

- (void)dealloc
{
    [photoId release];
    [title release];
    [url release];
    [img release];
    [super dealloc];
}

- (SBPhoto *)initWithDictionary:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        self.photoId = [dict objectForKey:@"p_fcrid"];
        self.url     = [NSString stringWithFormat:@"%@/%@", IMG_BASE_URL, photoId];
        self.title   = [dict objectForKey:@"title"];
        self.date    = [[dict objectForKey:@"date"] intValue];
    }
    return self;
}

- (void)setUrl:(NSString *)u {
	if ([url isEqual:u]) {
		return;
	}
	[url release];
	url = [[u stringByAppendingString:@".jpg"] retain];
    
	UIImage *imgInDisk = [[SDImageCache sharedImageCache] imageFromKey:url];
	if (imgInDisk) {
		self.img = imgInDisk;
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
		self.img = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:img imageData:UIImagePNGRepresentation(img) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
	}
	
	Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Release(request);
}

@end



@implementation SBAlbumRow

- (id)init
{
    self = [super init];
    if (self)
    {
        albumRow = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc
{
    [albumRow release];
    [super dealloc];
}

- (BOOL)addPhoto:(SBPhoto *)photo
{
    if ([albumRow count] < PHOTO_COUNT_PER_ROW)
    {
        [albumRow addObject:photo];
        return YES;
    }
    return NO;
}

- (SBPhoto *)photoAtColumn:(NSInteger)index
{
    if (index < [albumRow count]) {
        return [albumRow objectAtIndex:index];
    } else {
        return nil;
    }
}

- (NSArray *)albumRow
{
    return albumRow;
}

@end