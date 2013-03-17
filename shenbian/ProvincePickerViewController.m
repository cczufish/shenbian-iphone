//
//  CityListViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-13.
//  Copyright 2010 personal. All rights reserved.
//

#import "ProvincePickerViewController.h"
#import "CityPickerViewController.h"
#import "SBObject.h"
#import "LocationService.h"
#import "SBLocation.h"
#import "Notifications.h"
#import "SBApiEngine.h"
#import "SBApiEngine.h"
#import "AlertCenter.h"


#define HangkongID 2912
#define MacaoID    2911


@implementation ProvincePickerViewController

@synthesize isCascadeCity;
@synthesize needLocating;
@synthesize isForceChoose;
@synthesize currentArea;


- (void)viewDidUnload {
	[super viewDidUnload];
	
	[Notifier removeObserver:self name:kLocationSuccessed object:nil];
	[Notifier removeObserver:self name:kLocationFailed object:nil];
}

- (void)loadView {
	[super loadView];
	
	//	background
	UIImageView* bgImageView = [[UIImageView alloc] initWithImage:PNGImage(@"bg")];
	bgImageView.frame = vsr(0, 0, 320, 416);
	[self.view insertSubview:bgImageView atIndex:0];
	[bgImageView release];
	
	if (!self.title) {
		self.title = @"选择省(直辖市)";
	}
}

- (void)viewDidLoad {
	needLocating = YES;
	[super viewDidLoad];
	
	[Notifier addObserver:self selector:@selector(getLocationSuccessed) name:kLocationSuccessed object:nil];
	[Notifier addObserver:self selector:@selector(getLocationFailed) name:kLocationFailed object:nil];
    
    if (isForceChoose) {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"changecity_into");
}

- (void)dealloc {
	[Notifier removeObserver:self name:kLocationSuccessed object:nil];
	[Notifier removeObserver:self name:kLocationFailed object:nil];
	[hotCityList release];
	[provinceList release];
	[currentArea release];
	[super dealloc];
}

- (void)_loadDataSource {
	hotCityList = [NSMutableArray new];
	provinceList = [NSMutableArray new];
	
	if (needLocating) {
		[[LocationService sharedInstance] startLocation];
	}
	
	//http://client.shenbian.com/iphone/getCityList
	NSString *url = [NSString stringWithFormat:@"%@/getCityList", ROOT_URL];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:YES useStat:YES];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    NSInteger sectionCount = [provinceList count] + [hotCityList count] > 0 ? 2 : 0;
	return needLocating ? sectionCount + 1 : sectionCount;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (needLocating) {
		switch (section) {
			case 0:return 1;
			case 1:return [hotCityList count];
			case 2:return [provinceList count];
		}
	} else {
		switch (section) {
			case 0:return [hotCityList count];
			case 1:return [provinceList count];
		}
	}
	return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {	
	if (needLocating) {
		switch (section) {
			case 0:return @"当前所在城市";
			case 1:return @"热门城市";
			case 2:return @"按省份选择城市（按音序排列）";
		}
	} else {
		switch (section) {
			case 0:return @"热门城市";
			case 1:return @"按省份选择城市（按音序排列）";
		}
	}
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier0 = @"CellIdentifier0";
	static NSString *CellIdentifier1 = @"CellIdentifier1";
    
    UITableViewCell *cell;

	if (needLocating && indexPath.section == 0) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier0] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontLiteWithSize(16);
		
		// 当前城市
		if (self.currentArea) {
			cell.textLabel.text = self.currentArea.name;
		} else {
            if ([LocationService sharedInstance].isLocating) {
                UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                indicator.frame = CGRectMake(20, 10, 20, 20);
                [indicator startAnimating];
                
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
                label.text = @"正在定位...";
                label.font = FontLiteWithSize(16);
                
                [cell.contentView addSubview:indicator];
                [cell.contentView addSubview:label];
                
                [label release];
                [indicator release];
            } else {
                cell.textLabel.text = @"定位失败";
            }
		}

		return cell;
	}
	
	cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier1];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontLiteWithSize(16);
    }
	
	if ((!needLocating && indexPath.section == 0) || (needLocating && indexPath.section == 1)) {
		// 热门城市
		Area *city = [hotCityList objectAtIndex:indexPath.row];
		cell.textLabel.text = city.name;
		cell.accessoryType = UITableViewCellAccessoryNone;
	} else if ((!needLocating && indexPath.section == 1) || (needLocating && indexPath.section == 2)) {
		// 其他省
		Area *area = [provinceList objectAtIndex:indexPath.row];
		cell.textLabel.text = [area name];
		if (isCascadeCity && [area hasChildren]) {
			cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		} else {
			cell.accessoryType = UITableViewCellAccessoryNone;
		}
	}
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (needLocating && indexPath.section == 0) {
		if (self.currentArea) {
			[delegate pickerController:self pickData:currentArea];
		}
	} else if ((!needLocating && indexPath.section == 0) || (needLocating && indexPath.section == 1)) {
		// 热门城市
		SBObject *city = [hotCityList objectAtIndex:indexPath.row];
		[delegate pickerController:self pickData:city];
	} else if ((!needLocating && indexPath.section == 1) || (needLocating && indexPath.section == 2)) {
		// 其他省
		SBObject *province = [provinceList objectAtIndex:indexPath.row];
		if (isCascadeCity && [province hasChildren]) {
			CityPickerViewController *controller = [CityPickerViewController new];
			controller.province = [provinceList objectAtIndex:indexPath.row];
			controller.delegate = self.delegate;
			controller.title = ((Area *)[provinceList objectAtIndex:indexPath.row]).name;
			controller.hasCancelButton = NO;
			controller.hasTabbar = self.hasTabbar;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		} else {
			[delegate pickerController:self pickData:province];
		}
	}
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	[super _dataSourceReady];
	Release(request);
    
    // 第一次使用选择城市时，如果没有网络，则给出提示，此处破坏了Picker组件的设计优雅性，fuck
    if (isForceChoose) {
        // |[error code] == -1004|
        Alert(@"联网失败", @"请检查网络后重试");
    }
}

- (void)requestSucceeded:(HttpRequest*)req {
	NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    NSArray *hotCities  = [dict objectForKey:@"hotCity"];
    NSArray *provinces = [dict objectForKey:@"province"];
    
    for (NSDictionary *d in hotCities) {
        Area *city = [Area new];
        city.id = [[d objectForKey:@"city_code"] intValue];
        city.name = [d objectForKey:@"name"];
        [hotCityList addObject:city];
        [city release];
    }
    
    for (NSDictionary *dict in provinces) {
        Area *province = [Area new];
        province.id = [[dict objectForKey:@"city_code"] intValue];
        province.name = [dict objectForKey:@"name"];
        if ([[dict objectForKey:@"has_children"] boolValue]) {
            [province addChild:province];
        }
        [provinceList addObject:province];
        [province release];
    }
	
	[super _dataSourceReady];
	Release(request);
}


#pragma mark -
#pragma mark LocationServiceCallBack
- (void)getLocationSuccessed {
	SBLocation *location = [[LocationService sharedInstance] currentLocation];
	Area *a = [Area new];
	a.id = location.cityId;
	a.name = location.cityName;
	self.currentArea = a;
	[a release];
	
	[tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getLocationFailed {
	
}

@end

