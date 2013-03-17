//
//  MedalCellView.m
//  shenbian
//
//  Created by Leeyan on 11-5-10.
//  Copyright 2011 百度. All rights reserved.
//

#import "MedalCellView.h"
#import "SDImageCache.h"

@implementation MedalCellView

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
		self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"icon"];
	[super setDataModel:model];
	[dataModel addObserver:self forKeyPath:@"icon" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];

	[(MedalModel*)model loadImageResource];
	[self setNeedsDisplay];
}

- (void)dealloc
{
	[dataModel removeObserver:self forKeyPath:@"icon"];
	[super dealloc];
}

- (void)drawRect:(CGRect)rect {
	MedalModel* model = dataModel;
	
	//draw icon
	UIImage* iconImg = SETNIL(model.icon, PNGImage(@"medal_default"));

	int cellHeight = rect.size.height;
	int iconHeight = iconImg.size.height / 2;
	int iconWidth = iconImg.size.width / 2;
	
	[iconImg drawInRect:vsr((cellHeight - iconHeight)/2, (cellHeight - iconHeight)/2, iconHeight, iconWidth)];

	//draw text
	//TODO: add　”获得“
	NSString *obtainString = [NSString stringWithFormat:@"『%@』徽章", model.name];
	[PNGImage(@"obtain") drawAtPoint:ccp(90, 38)];
	[[UIColor blackColor] set];
    [obtainString drawInRect:CGRectMake(123, 38, 180, 15)
                    withFont:FontLiteWithSize(14)
               lineBreakMode:UILineBreakModeWordWrap];
	if (!noSeperator) {
		[PNGImage(@"dot_line_320") drawAtPoint:ccp(0, self.frame.size.height - 1)];
	}
}

@end



@implementation MedalModel
@synthesize icon, name, iconURL;

- (void)requestSucceeded:(HttpRequest*)req 
{
	if (req.statusCode == 200) {
		self.icon = [UIImage imageWithData:req.recievedData];
		[[SDImageCache sharedImageCache] storeImage:icon imageData:UIImagePNGRepresentation(icon) forKey:[[req.URLRequest URL] absoluteString] toDisk:YES];
	}
	isImgFetched = YES;
	VSSafeRelease(hcImgFetcher);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	isImgFetched = YES;
	VSSafeRelease(hcImgFetcher);
}


- (void)loadImageResource
{
//	NSLog(@"load image resource");
	if (self.icon) {
		return;
	}
	
//	NSLog(@"icon not exist.");
	if (isImgFetched) {
//		NSLog(@"image fetched");
		return;
	}	
	
//	NSLog(@"try to load from cache");
	UIImage* iconTmp = [[SDImageCache sharedImageCache] imageFromKey:self.iconURL];
	if (iconTmp) {
		self.icon = iconTmp;
		return;
	}
	
	if (!hcImgFetcher) {
		hcImgFetcher = [[HttpRequest alloc] init];
		hcImgFetcher.delegate = self;
	}
	[hcImgFetcher requestGET:iconURL useStat:YES];
}

- (void)dealloc
{
	CancelRequest(hcImgFetcher);
	VSSafeRelease(icon);
	VSSafeRelease(name);
	VSSafeRelease(iconURL);
	[super dealloc];
}
@end
