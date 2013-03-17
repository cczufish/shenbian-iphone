//
//  PickShopViewController.m
//  shenbian
//
//  Created by MagicYang on 4/29/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PickShopViewController.h"
#import "PickCommodityViewController.h"
#import "PhotoSubmitVC.h"

#import "Utility.h"
#import "LocationService.h"
#import "CacheCenter.h"
#import "PhotoController.h"

#import "SBObject.h"
#import "SBShopInfo.h"
#import "SBSuggestion.h"

#import "CustomCell.h"
#import "SearchCellView.h"
#import "SBApiEngine.h"


@implementation PickShopViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"选择商户";
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"photobutton_selshop");
}

- (void)request
{
    if (currentPage == 0 && (requestType == RequestTypeDefault || requestType == RequestTypeSearch)) {
        [super showLoading];
    }
    
    CancelRequest(request);
    NSString *url = nil;
    switch (requestType) {
        case RequestTypeDefault: {
            isPullLoadMore = YES;
            SBLocation *location = [[LocationService sharedInstance] currentLocation];
            if (location) {
                // http://client.shenbian.com/iphone/getNearbyShop?x=xxx&y=xxx
                url = [NSString stringWithFormat:@"%@/getNearbyShop?city_id=%d&x=%@&y=%@&p=%d&pn=%d", ROOT_URL, location.cityId, location.x, location.y, currentPage, MessageCountPerPage];
            } else {
                // http://client.shenbian.com/iphone/getNearbyShop?x=xxx&y=xxx
                url = [NSString stringWithFormat:@"%@/getNearbyShop?city_id=%d&p=%d&pn=%d", ROOT_URL, CurrentCityId, currentPage, MessageCountPerPage];
            }
            
        } break;
        case RequestTypeSuggest:
            isPullLoadMore = NO;
            // http://client.shenbian.com/iphone/getsugShop?w=xx&city_id=int
            url = [NSString stringWithFormat:@"%@/getsugShop?w=%@&city_id=%d", ROOT_URL, searchBar.searchText, CurrentCity.id];
            break;
        case RequestTypeSearch: {
            isPullLoadMore = YES;
            // http://client.shenbian.com/iphone/getSearchShop?p=int&pn=int&city_id=int&city=string&w=string[&x=float&y=float]
            SBLocation *location = [[LocationService sharedInstance] currentLocation];
            if (location) {
                url = [NSString stringWithFormat:@"%@/getSearchShop?p=%d&pn=%d&city_id=%d&curcity_id=%d&w=%@&x=%@&y=%@&st=%d",
                       ROOT_URL, currentPage, MessageCountPerPage, CurrentCityId, location.cityId, searchBar.searchText, location.x, location.y, 0];
            } else {
                url = [NSString stringWithFormat:@"%@/getSearchShop?p=%d&pn=%d&city_id=%d&w=%@&st=%d",
                       ROOT_URL, currentPage, MessageCountPerPage, CurrentCityId, searchBar.searchText, 0];
            }
        } break;
    }
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestGET:url useStat:YES];
}

- (void)showDefault
{
    requestType = RequestTypeDefault;
    [self cleanAll];
    [self request];
}

- (void)doSuggest
{
    if ([searchBar.searchText length] == 0) {
        [self showDefault];
    } else {
        requestType = RequestTypeSuggest;
        [self cleanAll];
        [self request];
    }
}

- (void)doSearch
{
    requestType = RequestTypeSearch;
    [self cleanAll];
    [self request];
}

- (BOOL)showLastPhotoShop
{
    return requestType == RequestTypeDefault && [[CacheCenter sharedInstance] lastPhotoShop] != nil;
}

- (void)startLoadingData
{
    [self request];
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self showLastPhotoShop]) {
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self showLastPhotoShop] && section == 0) {
        return 1;
    } else {
        return [list count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (([self showLastPhotoShop] && indexPath.section == 0) ||
        requestType == RequestTypeSuggest) {
        return [SearchSuggestCellView heightOfCell:nil];
    } else {
        return [SearchShopCellView heightOfCell:nil];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (requestType == RequestTypeDefault) {
        return 25;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section {
    if (requestType == RequestTypeDefault) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 25)];
        header.backgroundColor = [UIColor colorWithRed:0.949 green:0.941 blue:0.898 alpha:1];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 25)];
        label.backgroundColor = [UIColor clearColor];
        label.font = FontLiteWithSize(15);
        if ([self showLastPhotoShop] && section == 0) {
            label.text = @"最新去过";
        } else {
            label.text = @"附近商户";
        }
        [header addSubview:label];
        [label release];
        return [header autorelease];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellSuggestKeyword = @"CellSuggestKeyword";
    static NSString *CellSuggestShop    = @"CellSuggestShop";
    CustomCell *cell;
    
    if (([self showLastPhotoShop] && indexPath.section == 0) ||
        requestType == RequestTypeSuggest) {
        cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestKeyword];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestKeyword] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            CustomCellView *cellView = [[SearchSuggestCellView alloc] initWithFrame:cell.frame];
            cell.cellView = cellView;
            [cellView release];
        }
        
        if ([table numberOfSections] == 2 && indexPath.section == 0) {
            cell.cellView.noSeperator = YES;
            SBShopInfo *shopInfo = [[CacheCenter sharedInstance] lastPhotoShop];
            SBSuggestShop *sugShop = [SBSuggestShop new];
            sugShop.shopId   = shopInfo.shopId;
            sugShop.shopName = shopInfo.strName;
            [cell setDataModel:sugShop];
            [sugShop release];
        } else if ([list count]){
            cell.cellView.noSeperator = NO;
            SBSuggestKeyword *sug = [list objectAtIndex:indexPath.row];
            [cell setDataModel:sug];
        }
    } else {        
        SBSuggestShop *sug = [list objectAtIndex:indexPath.row];
        cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestShop];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestShop] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            CustomCellView *cellView = [[SearchShopCellView alloc] initWithFrame:cell.frame];
            cell.cellView = cellView;
            [cellView release];
        }
        [cell setDataModel:sug];
    }
	
    cell.backgroundColor = [UIColor clearColor];
	
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
    PhotoController *pc = [PhotoController singleton];
    if ([self showLastPhotoShop] && indexPath.section == 0) {
        SBShopInfo *shop = [[CacheCenter sharedInstance] lastPhotoShop];
        pc.shopId   = shop.shopId;
        pc.shopName = shop.strName;
        pc.isCommodityShop = shop.isCommodityShop;
        if (!shop.isCommodityShop) {
            pc.commodity = @"";
        }
        NSString *action = [NSString stringWithFormat:@"photobutton_selshop_click_been?s_fcry=%@", pc.shopId];
        Stat(action);
    } else {
        SBSuggestShop *shop = [list objectAtIndex:indexPath.row];
        pc.shopId   = shop.shopId;
        pc.shopName = shop.shopName;
        pc.isCommodityShop = shop.isCommodityShop;
        if (!shop.isCommodityShop) {
            pc.commodity = @"";
        }
        NSString *action = [NSString stringWithFormat:@"photobutton_selshop_click_default?r=%d&s_fcry=%@", 
                            indexPath.row, pc.shopId];
        Stat(action);
    }
    
    UIViewController *controller = pc.isCommodityShop ? [PickCommodityViewController new] : [PhotoSubmitVC new];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest *)req error:(NSError *)error {
    [super noMoreData];
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)requestSucceeded:(HttpRequest*)req {
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    switch (requestType) {
        case RequestTypeDefault: {
            totalCount = [[dict objectForKey:@"total"] intValue];
            NSArray *arr = [dict objectForKey:@"results"];
            for (NSDictionary *d in arr) {
                SBSuggestShop *shop = [SBSuggestShop new];
                shop.shopId         = [d objectForKey:@"s_fcrid"];
                shop.shopName       = [d objectForKey:@"s_name"];
                shop.shopAddress    = [d objectForKey:@"s_addr"];
                shop.distance       = [d objectForKey:@"distance_show"];
                shop.isCommodityShop= [[d objectForKey:@"hasCommodity"] boolValue];
                [list addObject:shop];
                [shop release];
            }
            
            if ([list count] < totalCount) {
                [super addPullLoadMore];
            } else {
                [super noMoreData];
            }
            // record current page
            currentPage++;
            if (currentPage == 1) {
                [loadingView removeFromSuperview];
            }
        } break;
        case RequestTypeSuggest: {
            [list removeAllObjects];
            NSArray *arr = [dict objectForKey:@"results"];
            for (NSDictionary *d in arr) {
                SBSuggestShop *sug = [SBSuggestShop new];
                sug.shopId         = [d objectForKey:@"s_fcrid"];
                sug.shopName       = [d objectForKey:@"s_name"];
                sug.isCommodityShop= [[d objectForKey:@"hasCommodity"] boolValue];
                [list addObject:sug];
                [sug release];
            }
        } break;
        case RequestTypeSearch: {
            totalCount = [[dict objectForKey:@"total"] intValue];
            NSArray *arr = [dict objectForKey:@"results"];
            
            for (NSDictionary *d in arr) {
                SBSuggestShop *shop = [SBSuggestShop new];
                shop.shopId         = [d objectForKey:@"s_fcrid"];
                shop.shopName       = [d objectForKey:@"s_name"];
                shop.shopAddress    = [d objectForKey:@"s_addr"];
                shop.distance       = [d objectForKey:@"show_distance"];
                shop.isCommodityShop= [[d objectForKey:@"hasCommodity"] boolValue];
                [list addObject:shop];
                [shop release];
            }
            
            if ([list count] < totalCount) {
                [super addPullLoadMore];
            } else {
                [super noMoreData];
            }
            // record current page
            currentPage++;
            if (currentPage == 1) {
                [loadingView removeFromSuperview];
            }
        } break;
    }
    [tableView reloadData];
    
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}


@end
