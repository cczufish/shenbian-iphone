    //
//  SubObjectViewController.m
//  shenbian
//
//  Created by MagicYang on 11-1-6.
//  Copyright 2011 personal. All rights reserved.
//

#import "SubObjectViewController.h"
#import "SearchResultsViewController.h"
#import "SBObject.h"


@implementation SubObjectViewController

@synthesize objectList;
@synthesize type;

- (void)dealloc {
	[objectList release];
	[super dealloc];
}

- (void)initTableView {	
	tableView = [[UITableView alloc] initWithFrame:TableViewFrameWithoutKeyboard style:UITableViewStylePlain];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

- (void)loadView {
	[super loadView];
	self.view.backgroundColor = [UIColor clearColor];
    
	self.title = type == AreaObject ? @"选择区域" : @"选择分类";
	
	[super setBackTitle:@"返回"];
}


#pragma mark -
#pragma mark UITableViewDelegate
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [objectList count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"CellIdentifier";
	
	UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
		cell.textLabel.font = FontWithSize(16);
    }
	
	SBObject *sb = [objectList objectAtIndex:indexPath.row];
	cell.textLabel.text = sb.name;
	
	return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	SBObject *sb = [objectList objectAtIndex:indexPath.row];
	
	SearchResultsViewController *controller = [SearchResultsViewController new];
	if (type == AreaObject) {
        controller.area   = sb.name;
		controller.areaId = sb.id;
	} else {
        controller.category   = sb.name;
		controller.categoryId = sb.id;
	}
	
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

@end
