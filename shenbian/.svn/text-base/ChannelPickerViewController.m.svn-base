    //
//  ChannelPickerViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-20.
//  Copyright 2010 personal. All rights reserved.
//

#import "ChannelPickerViewController.h"
#import "SBObject.h"
#import "SBApiEngine.h"


#define NULLID -1

@implementation ChannelPickerViewController

@synthesize cityId;
@synthesize channelList;
@synthesize subChannelList;

- (id)init {
	if ((self = [super init])) {
		cityId = NULLID;
	}
	return self;
}

- (void)dealloc {
	[channelList release];
	[subChannelList release];
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	self.title = @"选择分类";
	
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// New model navigationController must implement navigationItem after loadView()
	if (!hasCancelButton) {
		[self setBackTitle:[self defaultBackTitle]];
	}
}

- (void)_loadDataSource {
	if (channelList && [channelList count] > 0) {
		[self _dataSourceReady];
	} else {
		channelList = [NSMutableArray new];
		subChannelList = [NSMutableDictionary new];
		//	http://123.125.115.79/client/index/131/catmore?d 
		NSString *url = [NSString stringWithFormat:@"%@/index/%d/catmore", ROOT_URL, cityId];
		request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
		[request requestGET:url useCache:YES useStat:YES];
	}
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return [channelList count];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontLiteWithSize(16);
    }
    
	SBCategory *channel = [channelList objectAtIndex:indexPath.row];
	cell.textLabel.text = channel.name;
	
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (cityId == NULLID) {
		SBObject *channel = [channelList objectAtIndex:indexPath.row];
		[delegate pickerController:self pickData:channel];
	} else {
		ChannelPickerViewController *controller = [ChannelPickerViewController new];
		controller.delegate = delegate;
		controller.hasTabbar = YES;
		SBObject *channel = [channelList objectAtIndex:indexPath.row];
		controller.channelList = [subChannelList objectForKey:[NSString stringWithFormat:@"%d", channel.id]];
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
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
        SBCategory *channel = [SBCategory new];
        channel.id = [[d objectForKey:@"id"] intValue];
        channel.name = [d objectForKey:@"name"];
        NSArray *arr = [d objectForKey:@"list"];
        
        NSMutableArray *subChannelArr = [NSMutableArray array];
        for (NSDictionary *subDict in arr) {
            SBCategory *subchannel = [SBCategory new];
            subchannel.id = [[subDict objectForKey:@"id"] intValue];
            subchannel.name = [subDict objectForKey:@"name"];
            [subChannelArr addObject:subchannel];
            [subchannel release];
        }
        [subChannelList setObject:subChannelArr forKey:[NSString stringWithFormat:@"%d", channel.id]];
        [channelList addObject:channel];
        [channel release];
    }

	[self _dataSourceReady];
	Release(request);
}


@end
