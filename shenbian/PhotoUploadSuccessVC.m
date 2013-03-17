//
//  PhotoUploadSuccessVC.m
//  shenbian
//
//  Created by xhan on 5/9/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PhotoUploadSuccessVC.h"
#import "SBApiEngine.h"
#import "SBNavigationController.h"

#import "TreasureView.h"
#import	"MedalCellView.h"

#import "CustomCell.h"
#import "PhotoController.h"

#import "AppDelegate.h"

@implementation PhotoUploadSuccessVC

@synthesize _trVal1, _trVal2;
@synthesize _tableView;

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"photocommit_suc_into");
}

- (void)dealloc
{
	VSSafeRelease(tableView);
		
	self._trVal1 = nil;
	self._trVal2 = nil;
	
	self._tableView = nil;
	
	VSSafeRelease(_dict);
	VSSafeRelease(_badge);

    [super dealloc];
}

- (id)initWithResults:(NSDictionary*)dict
{
    if ((self = [super init]))
    {
		_dict = [dict retain];
/*
		[_dict release];
		_dict = [[NSDictionary dictionaryWithObjectsAndKeys:
				 @"+5", @"photo",
				 @"+3", @"sns",
				 [NSArray arrayWithObjects:
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"111",	@"id",
				   @"hello",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  [NSDictionary dictionaryWithObjectsAndKeys:
				   @"222",	@"id",
				   @"world",	@"detail",
				   @"http://www.dugooglebai.com",	@"pic",
				   nil],
				  nil], @"badge",
				 nil] retain];
// */
		_badge = [(NSArray*)[_dict objectForKey:@"badge"] retain];
	}    
    return self;
}

#pragma mark - View lifecycle




- (void)loadView
{
    [super loadView];
	
//	[self initWithResults:nil];
	
	self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"上传成功";
    self.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"关闭" andAction:@selector(onBtnClose) inDelegate:self];
	
	// setup background
	UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:vsr(0, 0, 320, 416)];
	UIImage *bgImage = PNGImage(@"photo_success_bg");
	bgImageView.image = [bgImage stretchableImageWithLeftCapWidth:0 topCapHeight:1];
	
	[self.view addSubview:bgImageView];
	[bgImageView release];
    
	// setup table header view	
	UIView *headerView;
	if ([[_dict objectForKey:@"phototop"] intValue] == 1) {
		headerView = [self headerViewMaxPhotoUploadToday];
	} else {
		headerView = [self setTreasureValue1:([[_dict objectForKey:@"photo"] intValue])
									  value2:([[_dict objectForKey:@"sns"] intValue])];
	}

//	headerView.left = (320 - headerView.width)/2;
	// badgesView
	tableView = [[UITableView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	tableView = [[UITableView alloc] initWithFrame:vsr(0,0,320,416)];
	tableView.backgroundColor = [UIColor clearColor];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.tableHeaderView = headerView;
	tableView.rowHeight = 90;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	[self addSubview:tableView];
	
	
	[tableView reloadData];
	
	// 遮挡最后一个cell的底边

	
	//	setup buttons (footer view)
	UIButton* buttonTakePhotoAgain = [T createBtnfromPoint:ccp(88, 24)
													  image:PNGImage(@"takePhotoAgain") 
													 target:self
												   selector:@selector(onBtnTakePhotoAgain)];
	/*
	UIButton* buttonReviewPhoto = [T createBtnfromPoint:ccp(168, 12)
													  image:PNGImage(@"reviewPhoto") 
													 target:self
												   selector:@selector(onBtnCheckUpPhoto)];
     */
	
	UIView* footerView = [[UIView alloc] initWithFrame:vsr(0, -100, 320, 80)];
	
	// add shadows
	UIImageView *shadowsView = [[UIImageView alloc] initWithImage:PNGImage(@"photo_success_bg_shadow")];
//	UIView* shadowsView = [T imageViewNamed:@"photo_success_bg_shadow.png"];
//	shadowsView.frame = vsr(0, 0, 320, 20);
//	shadowsView.backgroundColor = [UIColor clearColor];
//	footerView.backgroundColor = [UIColor clearColor];
	[footerView addSubview:shadowsView];
    [shadowsView release];
//	[footerView addSubview:buttonReviewPhoto];
	[footerView addSubview:buttonTakePhotoAgain];
	
    
	tableView.tableFooterView = footerView;
	
	[footerView release];
}


- (UIView *)headerViewMaxPhotoUploadToday {
	UIView *headerWrapper = [[UIView alloc] initWithFrame:vsr(0, 0, 320, 105)];
	UIImageView *v = [[UIImageView alloc] initWithFrame:vsr(10, 10, 300, 85)];
	v.image = PNGImage(@"uploadsucc");
	
	UILabel *label = [[UILabel alloc] initWithFrame:vsrc(150, 42, 250, 85)];
	label.font = FontWithSize(14.0f);
	label.text = @"今日上传图片超过20张了，真是资深拍客哇！";
	label.numberOfLines = 0;
	label.textAlignment = UITextAlignmentCenter;
	label.backgroundColor = [UIColor clearColor];
	
	[v addSubview:label];
	[headerWrapper addSubview:v];
    
    [label release];
	[v release];
	
	return [headerWrapper autorelease];
}

- (UIView*)setTreasureValue1:(NSInteger)val1 value2:(NSInteger)val2
{
	NSMutableArray *arrayList = [NSMutableArray array];
	if (0 != val1) {
		[arrayList addObject:[NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"上传图片", NUM(val1), nil]
														 forKeys: [NSArray arrayWithObjects:@"title", @"score", nil]
						 ]];
	}

	if (0 != val2) {
		[arrayList addObject:[NSDictionary dictionaryWithObjects: [NSArray arrayWithObjects:@"同步到新浪微博", NUM(val2), nil]
														 forKeys: [NSArray arrayWithObjects:@"title", @"score", nil]
						 ]];
	}
	
	return [self headerViewTreasureList:arrayList];
}

- (UIView *)headerViewTreasureList:(NSArray *)array {
	int count = [array count];
	UIView* headerWrapper = [[UIView alloc] initWithFrame:vsr(0,0,300,105)];
	UIImageView *v = [[UIImageView alloc] initWithFrame:vsr(10, 10, 300, 85)];
	
	if (1 == count) {
		headerWrapper.frame = vsr(0, 0, 300, 60);
		v.frame = vsr(10, 10, 300, 48);
		v.image = PNGImage(@"uploadsucc1");
	} else {
		headerWrapper.frame = vsr(0, 0, 300, 105);
		v.frame = vsr(10, 10, 300, 85);
		v.image = PNGImage(@"uploadsucc2");
	}
	
	[headerWrapper addSubview:v];
	[v release];

	UILabel *label1 = nil, *label2 = nil;
	UILabel *score1 = nil, *score2 = nil;
	
	if (count >= 1) {
		//	title
		label1 = [[UILabel alloc] initWithFrame:vsr(27, 23, 150, 20)];
		label1.text = [[array objectAtIndex:0] objectForKey:@"title"];
		label1.font = FontWithSize(14.0f);
		label1.textColor = [UIColor blackColor];
		label1.backgroundColor = [UIColor clearColor];
		
		//	score
		score1 = [[UILabel alloc] initWithFrame:vsr(0, 20, 245, 26)];
		score1.text = [[[array objectAtIndex:0] objectForKey:@"score"] stringValue];
		score1.backgroundColor = [UIColor clearColor];
		score1.font = FontWithSize(26.0f);
		score1.textAlignment = UITextAlignmentRight;
		score1.textColor = [UIColor redColor];
		
		[headerWrapper addSubview:label1];
		[headerWrapper addSubview:score1];
	}
	
	if (count > 1) {
		//	title 
		label2 = [[UILabel alloc] initWithFrame:vsr(27, 63, 150, 20)];
		label2.text = [[array objectAtIndex:1] objectForKey:@"title"];
		label2.font = FontWithSize(14.0f);
		label2.textColor = [UIColor blackColor];
		label2.backgroundColor = [UIColor clearColor];
		
		//	score
		score2 = [[UILabel alloc] initWithFrame:vsr(0, 60, 245, 26)];
		score2.text = [[[array objectAtIndex:1] objectForKey:@"score"] stringValue];
		score2.backgroundColor = [UIColor clearColor];
		score2.font = FontWithSize(26.0f);
		score2.textAlignment = UITextAlignmentRight;
		score2.textColor = [UIColor redColor];
		
		[headerWrapper addSubview:label2];
		[headerWrapper addSubview:score2];
		
		[label2 release];
		[score2 release];
	}
	
	Release(label1);
	Release(score1);

	headerWrapper.backgroundColor = [UIColor whiteColor];
	
	return [headerWrapper autorelease];
}

#pragma mark - actions

- (void)onBtnClose
{
	Stat(@"photocommit_suc_close");
    [[PhotoController singleton] dismissViewController];
}

- (void)onBtnCheckUpPhoto
{
    [[PhotoController singleton] dismissViewController];
    [[AppDelegate sharedDelegate] showLatestTab];
}

- (void)onBtnTakePhotoAgain
{
	Stat(@"photocommit_suc_next");
    PhotoController* control = [PhotoController singleton];
    control.photoLinkID = nil;
    control.neededUploadImg = nil;
    control.commodity = nil;
    [control showActionSheet];
    
}

#pragma mark -
#pragma mark  tableView datasource & delegates


- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section
{
	return [_badge count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	NSInteger row = [indexPath row];
    if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.backgroundColor = [UIColor whiteColor];
//		DLog(@"row: %d, count: %d", row, [_badge count]);
		
		MedalCellView *cellView = [[MedalCellView alloc] initWithFrame:cell.frame];
		((CustomCell *)cell).cellView = cellView;
		[cellView release];
    }
	
	if (row == [_badge count] - 1) {
		((CustomCell *)cell).cellView.noSeperator = YES;
	}
	
	MedalModel* model = [[[MedalModel alloc] init] autorelease];
	
	model.name = (NSString*)[(NSDictionary*)[_badge objectAtIndex:row] objectForKey:@"desc"];
	model.iconURL = (NSString*)[(NSDictionary*)[_badge objectAtIndex:row] objectForKey:@"pic"];
	
	[((CustomCell *)cell) setDataModel:model];
	
    return cell;
}



@end
