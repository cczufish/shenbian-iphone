//
//  CityListViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-13.
//  Copyright 2010 personal. All rights reserved.
//

#import "CityPickerViewController.h"
#import "SBApiEngine.h"


@implementation CityPickerViewController

@synthesize province;


- (void)dealloc {
	[cityList release];
	[province release];
    [super dealloc];
}

- (void)loadView {
	[super loadView];

	//	background
	UIImageView* bgImageView = [[UIImageView alloc] initWithImage:PNGImage(@"bg")];
	bgImageView.frame = vsr(0, 0, 320, 416);
	[self.view insertSubview:bgImageView atIndex:0];
	[bgImageView release];
	
	if (!self.title) {
		self.title = @"选择城市";
	}
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// New model navigationController must implement navigationItem after loadView()
	if (!hasCancelButton) {
		[self setBackTitle:@"返回"];
	}
}

- (void)_loadDataSource {
	cityList = [NSMutableArray new];
	// http://client.shenbian.com/iphone/getAllDistrict?[x=float&y=float]|[&city_id=int]
	NSString *url = [NSString stringWithFormat:@"%@/getAllDistrict?city_id=%d", ROOT_URL, province.id];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:YES useStat:YES];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [cityList count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontLiteWithSize(16);
    }
    
	Area *city = [cityList objectAtIndex:indexPath.row];
	cell.textLabel.text = city.name;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	SBObject *city = [cityList objectAtIndex:indexPath.row];
	[delegate pickerController:self pickData:city];
}



#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	[self _dataSourceReady];
	Release(request);
}

- (void)requestSucceeded:(HttpRequest*)req {
	NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    NSArray *arr = [dict objectForKey:@"district"];
    for (NSDictionary *areaDict in arr) {
        Area *city = [Area new];
        city.id = [[areaDict objectForKey:@"id"] intValue];
        city.name = [areaDict objectForKey:@"name"];
        NSArray *list = [areaDict objectForKey:@"list"];
        for (NSDictionary *areaDict in list) {
            Area *area = [Area new];
            area.id = [[areaDict objectForKey:@"id"] intValue];
            area.name = [areaDict objectForKey:@"name"];
            [city addChild:area];
            [area release];
        }
        [cityList addObject:city];
        [city release];
    }
    
	[self _dataSourceReady];
	Release(request);
}


@end

