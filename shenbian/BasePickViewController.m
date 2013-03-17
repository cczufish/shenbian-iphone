//
//  BasePickViewController.m
//  shenbian
//
//  Created by MagicYang on 4/29/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "BasePickViewController.h"


@implementation BasePickViewController

- (void)dealloc
{
    CancelRequest(request);
    [searchBar release];
    [list release];
    [super dealloc];
}

- (void)initTableView 
{
    tableView = [[UITableView alloc] initWithFrame:TableViewFrameWithoutKeyboard style:UITableViewStylePlain];
    tableView.top = CommonHeaderHeight + 3;
    tableView.height += 5;
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
}

- (void)loadView
{
    isPullLoadMore = YES;
    [super loadView];
    
	UIImageView *bgView = [[UIImageView alloc] initWithFrame:vsr(0, 0, 320, 430)];
	bgView.image = PNGImage(@"bg");
//	[self.view insertSubview:bgView atIndex:0];
	tableView.backgroundView = bgView;
	[bgView release];
	
	
    UIImageView *magnfiyingGlass = [[UIImageView alloc] initWithImage:PNGImage(@"searchbar_magnfiyingGlass")];
    magnfiyingGlass.frame = CGRectZero;
    searchBar = [[SBSearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, CommonHeaderHeight) delegate:self andTitleView:magnfiyingGlass];
    [searchBar setPlaceHolder:@""];
    [searchBar showSawtooth];
    [magnfiyingGlass release];
    [self addSubview:searchBar];
    
    list = [NSMutableArray new];
}

- (void)viewDidLoad
{
    [self showDefault];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    Release(searchBar);
    Release(list);
}

- (void)cleanAll
{
    [super noMoreData];
    [list removeAllObjects];
    totalCount = 0;
    currentPage = 0;
    [tableView reloadData];
}

- (void)showDefault
{
    NSAssert(NO, @"Never use directly, please implement by subclass");
}

- (void)doSuggest
{
    NSAssert(NO, @"Never use directly, please implement by subclass");
}

- (void)doSearch
{
    NSAssert(NO, @"Never use directly, please implement by subclass");
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;    // fixed height
}

- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section {
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
//	if (cell == nil) {
//		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
//		CustomCellView *cellView = [[AlbumCellView alloc] initWithFrame:cell.frame andDelegate:self];
//		((CustomCell *)cell).cellView = cellView;
//		[cellView release];
//		cell.selectionStyle = UITableViewCellSelectionStyleNone;
//		cell.backgroundColor = [UIColor whiteColor];
//	}
//	
//    SBAlbumRow *ar = [albumList objectAtIndex:indexPath.row];
//	[((CustomCell *)cell) setDataModel:ar];
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark -
#pragma mark SBSearchBarDelegate
- (void)searchBarDidBeginEditing:(SBSearchBar *)bar 
{
	[tableView reloadData];
}

- (void)searchBarDidChange:(SBSearchBar *)bar 
{
    [self doSuggest];
}

- (void)searchBarSearch:(SBSearchBar *)bar 
{
    [bar resignFirstResponder];
	[self doSearch];
}

- (void)searchBarCleared:(SBSearchBar *)bar 
{
    [self showDefault];
}


#pragma mark -
#pragma UIScrollView
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
    [super scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
	[searchBar resignFirstResponder];
}


@end
