    //
//  AllCategoryViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-31.
//  Copyright 2010 personal. All rights reserved.
//

#import "MainObjectViewController.h"
#import "Utility.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "SBObject.h"
#import "SearchResultsViewController.h"
#import "SubObjectViewController.h"
#import "LocationService.h"
#import "SBApiEngine.h"
#import "CacheCenter.h"
#import "SBSegmentView.h"

enum {
	AreaRequest    = 0,
	ChannelRequest = 1
};

@implementation MainObjectViewController

@synthesize type;

- (void)viewDidAppear:(BOOL)animated {
}

- (void)dealloc {
	[categoryList release];
	[areaList release];
	[segmentedControl release];
    [super dealloc];
}

- (void)initTableView {	
	tableView = [[UITableView alloc] initWithFrame:TableViewFrameWithoutKeyboard style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	Release(segmentedControl);
    Release(areaList);
    Release(categoryList);
}

- (void)loadData {
	[tableView reloadData];
}

- (void)requestArea
{
    if ([areaList count] == 0) {
        CancelRequest(areaRequest);
        // http://client.shenbian.com/iphone/getAllDistrict?[x=float&y=float]|[&city_id=int]
        NSString *url = [NSString stringWithFormat:@"%@/getAllDistrict?city_id=%d", ROOT_URL, CurrentCityId];
        areaRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:NUM(1)];
        [areaRequest requestGET:url useCache:YES useStat:YES];
    } else {
        [self loadData];
    }
}

- (void)requestChannel
{
    if ([categoryList count] == 0) {
        // http://client.shenbian.com/iphone/getClass?[x=float&y=float]|[&city_id=int]
        NSString *url = [NSString stringWithFormat:@"%@/getClass?city_id=%d", ROOT_URL, CurrentCityId];
        channelRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:NUM(0)];
        [channelRequest requestGET:url useCache:YES useStat:YES];
    } else {
        [self loadData];
    }
}

- (void)switchSelect:(NSInteger)index
{
    if (index == 0) {
		Stat(@"search_all_into?type=1");
        [self requestChannel];
    } else {
		Stat(@"search_all_into?type=0");
        [self requestArea];
    }
}

- (void)viewDidLoad {
	[super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    
    [super setBackTitle:@"返回"];
	
    areaList     = [NSMutableArray new];
    categoryList = [NSMutableArray new];
    
    segmentedControl = [SBSegmentView new];
	segmentedControl.delegate = self;
    [segmentedControl setDatasource:VSArray(@"所有分类", @"所有区域")];
    [segmentedControl setCellWidth:80];
	self.navigationItem.titleView = segmentedControl;
    segmentedControl.selectedIndex = type; 
    [self switchSelect:segmentedControl.selectedIndex];
}


#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return segmentedControl.selectedIndex == 0 ? [categoryList count] : [areaList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontWithSize(16);
    }
    
	if (segmentedControl.selectedIndex == 0) {
		SBCategory *category = [categoryList objectAtIndex:indexPath.row];
		cell.textLabel.text = category.name;
		cell.accessoryType =  [category hasChildren] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	} else {
		Area *area = [areaList objectAtIndex:indexPath.row];
        cell.textLabel.text = area.name;
		cell.accessoryType =  [area hasChildren] ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
	}
	return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (segmentedControl.selectedIndex == 0) {
		SBCategory *category = [categoryList objectAtIndex:indexPath.row];

        if ([category hasChildren]) {
			SubObjectViewController *controller = [SubObjectViewController new];
            controller.type = ChannelObject;
			controller.objectList = category.children;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		} else {
			SearchResultsViewController *controller = [SearchResultsViewController new];
            controller.category   = category.name;
            controller.categoryId = category.id;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
		}
	} else {
		Area *area = [areaList objectAtIndex:indexPath.row];
		
		if ([area hasChildren]) {
			SubObjectViewController *controller = [SubObjectViewController new];
            controller.type = AreaObject;
			controller.objectList = area.children;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		} else {
			SearchResultsViewController *controller = [SearchResultsViewController new];
            controller.area   = area.name;
			controller.areaId = area.id;
			[self.navigationController pushViewController:controller animated:YES];
			[controller release];
		}
	}
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	Release(req);
}

- (void)requestSucceeded:(HttpRequest*)req {
	NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:req.recievedData error:&error];
    
    if (error) {
        [self requestFailed:req error:error];
        return;
    }
    
    if ([req.extraData intValue] == 0) {
        NSArray *arr = [dict objectForKey:@"sort"];
        for (NSDictionary *categoryDict in arr) {
            SBCategory *category = [SBCategory new];
            category.id = [[categoryDict objectForKey:@"id"] intValue];
            category.name = [categoryDict objectForKey:@"name"];
            NSArray *list = [categoryDict objectForKey:@"list"];
            for (NSDictionary *subCategoryDict in list) {
                SBCategory *subCategory = [SBCategory new];
                subCategory.id = [[subCategoryDict objectForKey:@"id"] intValue];
                subCategory.name = [subCategoryDict objectForKey:@"name"];
                [category addChild:subCategory];
                [subCategory release];
            }
            [categoryList addObject:category];
            [category release];
        }
        
        Release(channelRequest);
    } else {
        NSArray *arr = [dict objectForKey:@"district"];
        for (NSDictionary *areaDict in arr) {
            Area *area = [Area new];
            area.id = [[areaDict objectForKey:@"id"] intValue];
            area.name = [areaDict objectForKey:@"name"];
            NSArray *list = [areaDict objectForKey:@"list"];
            for (NSDictionary *subAreaDict in list) {
                Area *subArea = [Area new];
                subArea.id = [[subAreaDict objectForKey:@"id"] intValue];
                subArea.name = [subAreaDict objectForKey:@"name"];
                [area addChild:subArea];
                [subArea release];
            }
            [areaList addObject:area];
            [area release];
        }
        Release(areaRequest);
    }
    
    [self loadData];
}


#pragma mark -
#pragma mark VSSegmentViewDelegate
- (void)segment:(VSSegmentView*)segment clickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    [self switchSelect:index];
}

@end
