//
//  SearchViewController.m
//  shenbian
//
//  Created by MagicYang on 10-11-22.
//  Copyright 2010 personal. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchResultsViewController.h"
#import "ShopInfoViewController.h"

#import "AppDelegate.h"
#import "CacheCenter.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "Utility.h"
#import "LocationService.h"
#import "Notifications.h"

#import "SBObject.h"
#import "SBSuggestion.h"
#import "SBShopInfo.h"

#import "SBLocationView.h"
#import "CustomCell.h"
#import "SearchCellView.h"


@interface SearchViewController()

- (void)hideNearbyBar;
- (void)showNearbyBar;
- (void)initSearchMainView;
- (void)loadWhatKeywordHistory;
- (void)loadWhereKeywordHistory;

@end


@implementation SearchViewController


- (void)dealloc {
    CancelRequest(request);
    [Notifier removeObserver:self name:kLocationSuccessed object:nil];
    [Notifier removeObserver:self name:kLocationFailed object:nil];
	[searchMainView release];
	[searchBar release];
	[nearbyBar release];
	[searchTableView release];
	[locationView release];
	[resultList release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [Notifier removeObserver:self name:kLocationSuccessed object:nil];
    [Notifier removeObserver:self name:kLocationFailed object:nil];
    
    Release(searchMainView);
    Release(searchBar);
    Release(nearbyBar);
    Release(searchTableView);
    Release(locationView);
    Release(resultList);
}

- (void)viewDidLoad
{
    self.title = @"搜索";
    self.view.backgroundColor = [UIColor clearColor];
    [navShadow removeFromSuperview];    // no shadow here
    
    self.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"取消" andAction:@selector(cancel:) inDelegate:self];
    self.navigationItem.hidesBackButton = YES;
    
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    locationView = [[SBLocationView alloc] initWithAddress:location.address andPosition:CGPointMake(0, 367 - 15)];
    
    cacheCenter = [CacheCenter sharedInstance];
    [self initSearchMainView];
    [self addSubview:searchMainView];
    [self addSubview:locationView];
    
    resultList = [NSMutableArray new];
    [self loadWhatKeywordHistory];
    
    [Notifier addObserver:self selector:@selector(getLocationSuccessed:) name:kLocationSuccessed object:nil];
    [Notifier addObserver:self selector:@selector(getLocationFailed:) name:kLocationFailed object:nil];
}

- (void)initSearchMainView {
	searchMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
	
    UIColor *labelColor = [UIColor colorWithRed:0.631 green:0.631 blue:0.631 alpha:1];
	UILabel *searchLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	searchLabel.text = @"找:";
	searchLabel.font = [UIFont boldSystemFontOfSize:14];
	searchLabel.textColor = labelColor;
	UILabel *nearbyLabel = [[UILabel alloc] initWithFrame:CGRectZero];
	nearbyLabel.text = @"在:";
	nearbyLabel.font = [UIFont boldSystemFontOfSize:14];
	nearbyLabel.textColor = labelColor;
	searchBar = [[SBSearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, CommonHeaderHeight) delegate:self andTitleView:searchLabel];
	nearbyBar = [[SBSearchBar alloc] initWithFrame:CGRectMake(0, 0, 320, CommonHeaderHeight) delegate:self andTitleView:nearbyLabel];
    [nearbyBar showSawtooth];
    
	[searchBar setPlaceHolder:@"商户名等"];
	[nearbyBar setPlaceHolder:@"默认当前位置"];
	[searchLabel release];
	[nearbyLabel release];
	
	searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CommonHeaderHeight, 320, 375 - CommonHeaderHeight * 2) style:UITableViewStylePlain];
	searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	searchTableView.delegate = self;
	searchTableView.dataSource = self;

    [searchMainView addSubview:searchTableView];
	[searchMainView addSubview:nearbyBar];
	[searchMainView addSubview:searchBar];
}

- (void)viewWillAppear:(BOOL)animated {
	searchTableView.alpha = 0;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	searchTableView.alpha = 1;
	[UIView commitAnimations];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"search_input_into");
    [super viewDidAppear:animated];
	
    [searchBar becomeFirstResponder];
    [self showNearbyBar];
}

- (void)goSearch {
	NSString *what  = searchBar.searchText ? searchBar.searchText : @"";
	NSString *where = nil;
    where = nearbyBar.searchText ? nearbyBar.searchText : @"";
	// 去空格和换行符
	what = [what stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	where = [where stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    SearchResultsViewController *controller = [SearchResultsViewController new];
    controller.what  = what;
    controller.where = where;
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)doCacnel {
	[self.navigationController popViewControllerAnimated:NO];
}

- (void)cancel:(id)sender {
    [self hideNearbyBar];
    
	searchTableView.alpha = 1;
	[UIView beginAnimations:nil context:NULL];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(doCacnel)];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	searchTableView.alpha = 0;
	[UIView commitAnimations];
}

- (void)loadWhatKeywordHistory
{
    for (NSString *keyword in cacheCenter.whatSearchHistory) {
        SBSuggestKeyword *sug = [SBSuggestKeyword new];
        sug.keyword = keyword;
        [resultList addObject:sug];
        [sug release];
    }
}

- (void)loadWhereKeywordHistory
{
    for (NSString *keyword in cacheCenter.whereSearchHistory) {
        SBSuggestKeyword *sug = [SBSuggestKeyword new];
        sug.keyword = keyword;
        [resultList addObject:sug];
        [sug release];
    }
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	if (currentSearchType == SearchTypeChannel) {
		return [resultList count];
	} else {
		return [resultList count];
	}
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSObject *obj = [resultList objectAtIndex:indexPath.row];
    if ([obj isKindOfClass:[SBSuggestShop class]]) {
        return 60;
    } else {
        return 40;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellSuggestKeyword = @"CellSuggestKeyword";
    static NSString *CellSuggestShop    = @"CellSuggestShop";

	if (currentSearchType == SearchTypeChannel) {
        CustomCell *cell;
        NSObject *sug = [resultList objectAtIndex:indexPath.row];
        
        if ([sug isKindOfClass:[SBSuggestShop class]]) {
            cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestShop];
            if (cell == nil) {
                cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestShop] autorelease];
                CustomCellView *cellView = [[SearchShopCellView alloc] initWithFrame:cell.frame];
                cell.cellView = cellView;
                [cellView release];
            }
            [cell setDataModel:sug];
        } else {
            cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestKeyword];
            if (cell == nil) {
                cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestKeyword] autorelease];
                CustomCellView *cellView = [[SearchSuggestCellView alloc] initWithFrame:cell.frame];
                cell.cellView = cellView;
                [cellView release];
            }
            [cell setDataModel:sug];
        }
        return cell;
	} else {
        CustomCell *cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestKeyword];
        SBSuggestKeyword *sug = [resultList objectAtIndex:indexPath.row];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestKeyword] autorelease];
            CustomCellView *cellView = [[SearchSuggestCellView alloc] initWithFrame:cell.frame];
            cell.cellView = cellView;
            [cellView release];
        }
        [cell setDataModel:sug];
        return cell;
	}
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (currentSearchType == SearchTypeChannel) {
        NSObject *obj = [resultList objectAtIndex:indexPath.row];
        if ([obj isKindOfClass:[SBSuggestKeyword class]] || [obj isKindOfClass:[NSString class]]) {
            SearchResultsViewController *controller = [SearchResultsViewController new];
            controller.what  = [obj isKindOfClass:[SBSuggestKeyword class]] ? 
            ((SBSuggestKeyword *)obj).keyword : (NSString *)obj;
            controller.where = nearbyBar.searchText;
            UITextField *tf = [searchBar valueForKey:@"textField"];
            tf.text = controller.what;
            [[CacheCenter sharedInstance] recordWhatSearch:controller.what];
            if ([controller.where length] > 0) {
                [[CacheCenter sharedInstance] recordWhereSearch:controller.where];
            }
            [self.navigationController pushViewController:controller animated:YES];
			Stat(@"search_input_click_whatsug?r=%d&sug=%@", indexPath.row, controller.what);
            [controller release];
        } else {
            SBShopInfo *shop = [resultList objectAtIndex:indexPath.row];
            ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shop.shopId];
            controller.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        }
	} else {
        SBSuggestKeyword *sug = [resultList objectAtIndex:indexPath.row];
        nearbyBar.searchText = sug.keyword;
        UITextField *tf = [nearbyBar valueForKey:@"textField"];
        tf.text = sug.keyword;
	}
}


#pragma mark -
#pragma mark SBSearchBarDelegate
- (void)searchBarDidBeginEditing:(SBSearchBar *)bar {
	currentSearchType = [bar isEqual:searchBar] ? SearchTypeChannel : SearchTypeArea;
	[searchTableView reloadData];
    
    [resultList removeAllObjects];
    if (currentSearchType == SearchTypeChannel) {
        [self loadWhatKeywordHistory];
    } else {
        [self loadWhereKeywordHistory];
    }
    [searchTableView reloadData];
}

- (void)searchBarDidChange:(SBSearchBar *)bar {
    NSString *keyword = [bar.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    if ([bar isEqual:searchBar]) {
        if ([keyword length] == 0) {
            [resultList removeAllObjects];
            [self loadWhatKeywordHistory];
            [searchTableView reloadData];
        } else {
            CancelRequest(request);
            // http://bb-wiki-test06.vm.baidu.com:8060/iphone/getsugs?w=a
            NSString *url = [NSString stringWithFormat:@"%@/getsugs?w=%@&city_id=%d", ROOT_URL, keyword, CurrentCityId];
            request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
            [request requestGET:url useCache:YES useStat:YES];
        }
    } else {
        if ([keyword length] == 0) {
            [resultList removeAllObjects];
            [self loadWhereKeywordHistory];
            [searchTableView reloadData];
        } else {
            
        }
    }
}

- (void)searchBarSearch:(SBSearchBar *)bar {
    NSString *whatKeyword = [searchBar.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *whereKeyword = [nearbyBar.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([whatKeyword length] > 0) {
        [[CacheCenter sharedInstance] recordWhatSearch:searchBar.searchText];
    }
    
    if ([whereKeyword length] > 0) {
        [[CacheCenter sharedInstance] recordWhereSearch:nearbyBar.searchText];
    }
    
	[self goSearch];
}

- (void)hideNearbyBar {
	if (nearbyBar.frame.origin.y != searchBar.frame.origin.y) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		NSInteger offset = 4 - CommonHeaderHeight;
		[Utility moveView:nearbyBar p:offset];
		[Utility moveView:searchTableView p:offset];
		[UIView commitAnimations];
	}
	[searchBar becomeFirstResponder];
}

- (void)showNearbyBar {
	if (nearbyBar.frame.origin.y == searchBar.frame.origin.y) {
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:0.3];
		[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
		NSInteger offset = CommonHeaderHeight - 4;
		[Utility moveView:nearbyBar p:offset];
		[Utility moveView:searchTableView p:offset];
		[UIView commitAnimations];
	}	
	[searchBar becomeFirstResponder];
}

- (void)setSearchText:(NSString *)text {
	if (currentSearchType == SearchTypeChannel) {
		searchBar.searchText = text;
	} else {
		nearbyBar.searchText = text;
	}
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
	if (req.statusCode == 200) {
		NSError *outError = NULL;
		SBJsonParser *parser = [SBJsonParser new];
			NSString *str = [[NSString alloc] initWithData:req.recievedData encoding:NSUTF8StringEncoding];
			NSDictionary *dict = [parser objectWithString:str error:&outError];
			[str release];
			[parser release];
		if (outError) {
			DLog(@"Request shop info, error:%@", outError);
		} else {
			[resultList removeAllObjects];
            NSArray *results = [dict objectForKey:@"results"];
            for (NSDictionary *d in results) {
                id<SBSuggestion> sug;
                if ([[d objectForKey:@"is_shop"] intValue] == 1) {
                    sug = [SBSuggestShop new];
                    ((SBSuggestShop *)sug).shopId = [d objectForKey:@"s_fcrid"];
                    ((SBSuggestShop *)sug).shopName = [d objectForKey:@"s_name"];
                    ((SBSuggestShop *)sug).shopAddress = [d objectForKey:@"s_addr"];
                } else {
                    sug = [SBSuggestKeyword new];
                    ((SBSuggestKeyword *)sug).keyword = [d objectForKey:@"s_name"];
                    ((SBSuggestKeyword *)sug).count   = [[d objectForKey:@"count"] intValue];
                }
                [resultList addObject:sug];
                [(NSObject *)sug release];
            }
            [searchTableView reloadData];
		}
	}
	
	Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	Release(request);
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate 
{
	[searchBar resignFirstResponder];
	[nearbyBar resignFirstResponder];
}


#pragma mark -
#pragma mark LocationService
- (void)getLocationSuccessed:(NSNotification *)notification 
{    
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    locationView.address = location.address;
}

- (void)getLocationFailed:(NSNotification *)notification
{
    
}

@end

