    //
//  AreaPickerViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import "AreaPickerViewController.h"
#import "SBObject.h"
#import "SBApiEngine.h"


@implementation AreaPickerViewController

@synthesize city;

- (id)initWithAreaList:(NSArray *)list
{
    self = [super init];
    if (self) {
        areaList = [NSMutableArray new];
        [areaList addObjectsFromArray:list];
    }
    return self;
}

- (void)dealloc {
	[areaList release];
	[city release];
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	self.title = city.name;
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// New model navigationController must implement navigationItem after loadView()
	if (!hasCancelButton) {
		[self setBackTitle:[self defaultBackTitle]];
	}
}

- (void)_loadDataSource {
    if ([areaList count] == 0) {
        //	http://123.125.115.79/client/index/23/city?d 
        NSString *url = [NSString stringWithFormat:@"%@/index/%d/citymore", ROOT_URL, city.id];
        request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
        [request requestGET:url useCache:YES useStat:YES];
    } else {
        [tableView reloadData];
    }
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [areaList count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontLiteWithSize(16);
    }
    
	Area *area = [areaList objectAtIndex:indexPath.row];
	cell.textLabel.text = area.name;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	SBObject *area = [areaList objectAtIndex:indexPath.row];
	[delegate pickerController:self pickData:area];
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

    NSDictionary *list = [dict objectForKey:@"list"];
    for (NSDictionary *d in list) {
        Area *area = [Area new];
        area.id = [[d objectForKey:@"id"] intValue];
        area.name = [d objectForKey:@"name"];
        [areaList addObject:area];
        [area release];
    }
	
	[self _dataSourceReady];
	Release(request);
}


@end
