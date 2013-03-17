//
//  SearchResultsViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import "SearchResultsViewController.h"
#import "ShopInfoViewController.h"

#import "CustomCell.h"
#import "CustomCellView.h"
#import "SearchResultsHeader.h"
#import "SearchResultCellView.h"
#import "CancelView.h"
#import "VSPickerView.h"
#import "VSSegmentView.h"
#import "SBLocationView.h"
#import "EGORefreshTableHeaderView.h"
#import "SBNoResultView.h"
#import "UIAdditions.h"

#import "SBObject.h"
#import "SBShopInfo.h"
#import "SBCoupon.h"
#import "SBLocation.h"

#import "CacheCenter.h"
#import "Utility.h"
#import "SBJsonParser.h"
#import "Notifications.h"
#import "LocationService.h"


@interface SearchResultsViewController()

- (void)setPickerDefaultTitle;
- (NSString *)sectionTitle;
- (UIView *)loadHeaderView;
- (void)cleanPicker;

@end



@implementation SearchResultsViewController

@synthesize what, where;
@synthesize cityId;
@synthesize sort;
@synthesize area, category;
@synthesize areaId, categoryId;
@synthesize tabbarHidden, headerHidden;
@synthesize notFoundView;


- (void)dealloc {
    [Notifier removeObserver:self name:kLocationSuccessed object:nil];
    [Notifier removeObserver:self name:kLocationFailed object:nil];
	CancelRequest(request);
	[what release];
	[where release];
	[area release];
	[category release];
	[resultList release];
	[areaList release];
	[categoryList release];
	[header release];
	[picker release];
	[tableHeader release];
	[notFoundView release];
    [super dealloc];
}

- (void)setPickerDefaultTitle {
	[header setLeftTitle:kAllArea];
	[header setRightTitle:kAllCategory];
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, tabbarHidden ? 416 : 367) style:UITableViewStylePlain];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}

- (void)viewDidUnload {
	[super viewDidUnload];
    [Notifier removeObserver:self name:kLocationSuccessed object:nil];
    [Notifier removeObserver:self name:kLocationFailed object:nil];
	[self cleanAll];
    
    Release(header);
    Release(tableHeader);
	Release(picker);
	Release(cancelView);
    
    Release(resultList);
    Release(areaList);
    Release(categoryList);
}

- (void)initRefreshHeader
{
    //refreshView
	refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0, -tableView.height, 320, tableView.height)];
	refreshHeaderView.delegate = self;
	refreshHeaderView.downText = @"下拉刷新";
	refreshHeaderView.releaseText = @"松开刷新数据";
	refreshHeaderView.loadingText = @"正在载入...";
	[tableView addSubview:refreshHeaderView];
}

- (void)loadView {
    isPullLoadMore = YES;
    self.loadingUpText = @"上拉载入更多";
	self.loadingReleaseText = @"松开载入更多";
	self.loadingText = @"正在载入...";
    
	[super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    
    [self initRefreshHeader];
    
    self.title = @"搜索结果";
    resultList   = [NSMutableArray new];
    areaList     = [NSMutableArray new];
    categoryList = [NSMutableArray new];
    
    header = [[SearchResultsHeader alloc] initWithDelegate:self andFrame:CGRectMake(0, 0, 320, 72)];
    [self setPickerDefaultTitle];
    
    tableView.top    = 72;
    tableView.height = 300;
    tableView.tableHeaderView = [self loadHeaderView];
    
	picker = [[VSPickerView alloc] initWithFrame:CGRectMake(0, 844, 320, PickerH)];
	picker.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	picker.delegate = self;
    picker.target = self;
	picker.showsSelectionIndicator = YES;
	
	cancelView = [[CancelView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) bgColor:[UIColor blackColor] andDelegate:nil];
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    locationView = [[SBLocationView alloc] initWithAddress:location.address andPosition:CGPointMake(0, 367 - 15)];
    
	[self addSubview:header];
    [self addSubview:locationView];
	[[[UIApplication sharedApplication] keyWindow] addSubview:picker];
    
    [Notifier addObserver:self selector:@selector(getLocationSuccessed:) name:kLocationSuccessed object:nil];
    [Notifier addObserver:self selector:@selector(getLocationFailed:) name:kLocationFailed object:nil];
}

- (UIView *)loadHeaderView {
	UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 26)];
    headView.backgroundColor = [UIColor whiteColor];
    tableHeader = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 310, 25)];
    tableHeader.font = FontWithSize(12);
    tableHeader.textColor = GrayColor;
    tableHeader.text = [self sectionTitle];
    [headView addSubview:tableHeader];
	
	UIImageView *dotLine = [[UIImageView alloc] initWithImage:PNGImage(@"dot_line_320")];
	dotLine.frame = vsr(0, headView.height, 320, 1);
	[headView addSubview:dotLine];
	[dotLine release];
	
    return [headView autorelease];
}

- (void)viewDidLoad {
	showAddShop = YES;
	
	[self searchRequest];
	
	if ([area length] > 0) {
		[header setLeftTitle:area];
	}
	
	if ([category length] > 0) {
		[header setRightTitle:category];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.view bringSubviewToFront:locationView];
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"search_list_into?what=%@&where=%@", what, where);
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
    [picker hideWithAnimation:NO];
}

- (NSString *)addFilterParametersToUrl:(NSString *)url {
	// 区域检索条件
	if (areaId) {url = [url stringByAppendingFormat:@"&arid=%d", areaId];}
	// 分类检索条件
	if (categoryId) {url = [url stringByAppendingFormat:@"&chid=%d", categoryId];}
	
	return url;
}

- (void)searchRequest {
    header.userInteractionEnabled = NO;
    
	if (currentPage == 0) {
		[self showLoading];
	}
	
    // http://client.shenbian.com/iphone/getSearch?p=int&pn=int&city_id=int&city=string&w=string&x=float&y=float
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    NSString *url;
    if (location) {
        url = [NSString stringWithFormat:@"%@/getSearch?p=%d&pn=%d&city_id=%d&curcity_id=%d&x=%@&y=%@&w=%@&s=%@&st=%d",
               ROOT_URL, currentPage, MessageCountPerPage, CurrentCityId, location.cityId, location.x, location.y, what, where, sort];
    } else {
        url = [NSString stringWithFormat:@"%@/getSearch?p=%d&pn=%d&city_id=%d&w=%@&s=%@&st=%d",
               ROOT_URL, currentPage, MessageCountPerPage, CurrentCityId, what, where, sort];
    }
	url = [self addFilterParametersToUrl:url];
//	[self cleanPicker];
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:YES useStat:YES];
}

- (void)cleanPicker {
    [areaList removeAllObjects];
    [categoryList removeAllObjects];
}

- (void)cleanAll {
	resultCount = 0;
	isSearchFinished = NO;
	isPullLoadMore = YES;
	CancelRequest(request);
	currentPage = 0;
	[resultList removeAllObjects];
	[tableView reloadData];
	[self cleanPicker];
}


#pragma mark -
#pragma mark Override Methods
- (NSString *)sectionTitle {
	what = what ? what : @"";
	where = where ? where : @"";
	
	NSString *shopCount = resultCount == 0 ? @"" : [NSString stringWithFormat:@"[%d家商户]", resultCount];
	
	if (![what isEqualToString:@""]) {
		if ([where isEqualToString:@""]) {
			return [NSString stringWithFormat:@"搜索－%@%@", what, shopCount];
		} else {
			return [NSString stringWithFormat:@"搜索－%@－%@%@", what, where, shopCount];
		}
	} else if ([what isEqualToString:@""] && ![where isEqualToString:@""]) {
		return [NSString stringWithFormat:@"搜索－%@%@", where, shopCount];
	}
	
	NSMutableString *keyword = [NSMutableString string];
	
	if ([area length] > 0) {
		[keyword appendString:area];
	}
	
	if ([category length] > 0) {
		if ([keyword length] > 0) {
			[keyword appendString:@" "];
		}
		[keyword appendString:category];
	}
	
	if ([keyword length] > 0) {
		return [NSString stringWithFormat:@"搜索－%@%@", keyword, shopCount];
	} else {
		return shopCount;
	}
}

- (void)startLoadingData {
	if (currentPage > 0) {
		Stat(@"search_list_upmore");
	}
		
	[self searchRequest];
}

- (void)refreshData {
    
    [self cleanAll];
    
    [self searchRequest];
}

- (void)showLoading {
	if (currentPage == 0) {
		if (!loadingView) {
			loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
		}
		[self.view addSubview:loadingView];
	}
	
    [self.notFoundView removeFromSuperview];
}

- (void)hideLoading {
	[super hideLoading];
}

- (void)showNotFoundView {
	Stat(@"search_list_noresult");
	self.notFoundView = [[[SBNoResultView alloc] initWithFrame:vsr(0, 100, 320, 200) andText:@"没有找到您想要的商户"] autorelease];
	[self.view insertSubview:self.notFoundView belowSubview:tableView];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return [resultList count];
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchResultCellView heightOfCell:[resultList objectAtIndex:indexPath.row]];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *SearchResultCell = @"SearchResultCell";
	CustomCell *cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:SearchResultCell];
    if (cell == nil) {
        cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SearchResultCell] autorelease];
        cell.cellView = [[SearchResultCellView new] autorelease];
        cell.cellView.frame = cell.frame;
        ((SearchResultCellView *)cell.cellView).showDistance = YES;
    }
    cell.cellView.noSeperator = indexPath.row == 0;
    SBShopInfo *shop = [resultList objectAtIndex:indexPath.row];
    [cell setDataModel:shop];
    return cell;
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	
	if (indexPath.row == [resultList count]) {
		[self performSelector:@selector(addShop:)];
	} else {
        SBShopInfo *shop = [resultList objectAtIndex:indexPath.row];
		ShopInfoViewController *controller = [[ShopInfoViewController alloc] initWithShopId:shop.shopId];
		controller.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
		Stat(@"search_list_click?r=%d&s_fcry=%@", indexPath.row, shop.shopId);
	}
}


#pragma mark -
#pragma mark Actions

- (void)selectLeft 
{
    picker.tag = LeftPicker;
	[picker reloadAllComponents];
	[picker showInView:self.view Animation:YES];

	if ([areaList count] != 0) {

//		[picker selectRow:leftMainIndex inComponent:0 animated:NO];
		int selectIndex = (self.areaId > 0 && areaList.count > 1) ? 1 : 0;
		[picker selectRow:selectIndex inComponent:0 animated:NO];
		[self pickerView:picker didSelectRow:selectIndex inComponent:0];
		int areaIndex = 0;
		if (areaList.count > 1) {
			for (Area *d in ((Area *)[areaList objectAtIndex:1]).children) {
				if (d.id == self.areaId) {
					[picker selectRow:areaIndex inComponent:1 animated:NO];
					break;
				}
				areaIndex++;
			}
		}
	}
}

- (void)selectRight 
{
    picker.tag = RightPicker;
    [picker reloadAllComponents];
	[picker showInView:self.view Animation:YES];
    
	if ([categoryList count] != 0) {
//		[picker selectRow:rightMainIndex inComponent:0 animated:NO];
		int selectIndex = (self.categoryId > 0 && categoryList.count > 1) ? 1 : 0;
		[picker selectRow:selectIndex inComponent:0 animated:NO];
		[self pickerView:picker didSelectRow:selectIndex inComponent:0];

		int index = 0;
		if (categoryList.count > 1) {
			for (SBCategory *d in ((SBCategory *)[categoryList objectAtIndex:1]).children) {
				if (d.id == self.categoryId) {
					[picker selectRow:index inComponent:1 animated:NO];
					break;
				}
				index++;
			}
		}
	}
}

- (void)segment:(VSSegmentView*)view clickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent
{
    if (!isCurrent) {
        sort = index;
        [self cleanAll];
        [self searchRequest];
		Stat(@"search_list_sort_click?sort=%d", sort);
    }
}

// 取消筛选
- (void)cancelPick:(id)sender {
    [picker hideWithAnimation:YES];
}

// 完成筛选
- (void)finishPick:(id)sender {
    [picker hideWithAnimation:YES];
    // get data from picker
    NSInteger mainIndex = [picker.selectedIndexPath indexAtPosition:0];
    NSInteger currentCount  = [picker.selectedIndexPath indexAtPosition:1]; // if there's no data in position, return -1 here
    if (picker.tag == LeftPicker) {
        Area *a = [areaList objectAtIndex:mainIndex];
        if (currentCount > 0) {
            Area *subA = [a.children objectAtIndex:currentCount];
            self.areaId = subA.id;
            self.area   = subA.name;
            [header setLeftTitle:subA.name];
        } else {
            self.areaId = a.id;
            self.area   = a.name;
            [header setLeftTitle:a.name];
			leftMainIndex = areaId > 0 ? 1 : 0;
        }
    } else {
        SBCategory *c = [categoryList objectAtIndex:mainIndex];
        if (currentCount > 0) {
            SBCategory *subC = [c.children objectAtIndex:currentCount];
            self.categoryId = subC.id;
            self.category   = subC.name;
            [header setRightTitle:subC.name];
        } else {
            self.categoryId = c.id;
            self.category   = c.name;
            [header setRightTitle:c.name];
			rightMainIndex = categoryId > 0 ? 1 : 0;
        }
    }
	
	Stat(@"search_list_select?what=%@&where=%@", what, where);
	
    // send new request
	[self cleanAll];
	[self searchRequest];
}

#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
    header.userInteractionEnabled = YES;
    NSDictionary *dict = [Utility parseData:req.recievedData];
    if ([[dict objectForKey:@"errno"] intValue] == 0) {
        resultCount = [[dict objectForKey:@"total"] intValue];
        
        // update filter data
        if (currentPage == 0) {
            NSArray *areas = [dict objectForKey:@"district"];
            NSArray *categories = [dict objectForKey:@"sort"];
            for (NSDictionary *d in areas) {
                Area *a = [Area new];
                a.id = [[d objectForKey:@"id"] intValue];
                a.name = [d objectForKey:@"name"];
                [a addChild:[Area allSubArea]];
                for (NSDictionary *sub in [d objectForKey:@"list"]) {
                    Area *subA = [Area new];
                    subA.id = [[sub objectForKey:@"id"] intValue];
                    subA.name = [sub objectForKey:@"name"];
                    [a addChild:subA];
                    [subA release];
                }
                [areaList addObject:a];
                [a release];
            }
            [areaList insertObject:[Area allArea] atIndex:0];

            for (NSDictionary *d in categories) {
                SBCategory *c = [SBCategory new];
                c.id = [[d objectForKey:@"id"] intValue];
                c.name = [d objectForKey:@"name"];
                [c addChild:[SBCategory allSubCategory]];
                for (NSDictionary *sub in [d objectForKey:@"list"]) {
                    SBCategory *subC = [SBCategory new];
                    subC.id = [[sub objectForKey:@"id"] intValue];
                    subC.name = [sub objectForKey:@"name"];
                    [c addChild:subC];
                    [subC release];
                }
                [categoryList addObject:c];
                [c release];
            }
            [categoryList insertObject:[SBCategory allCategory] atIndex:0];
        }
       
        
        NSArray *shops = [dict objectForKey:@"shop"];
        for (NSDictionary *d in shops) {
            SBShopInfo *shop = [SBShopInfo new];
            shop.shopId = [d objectForKey:@"s_fcrid"];
            shop.strName = [d objectForKey:@"s_name"];
            shop.intScoreTotal = [[d objectForKey:@"s_score"] intValue];
            shop.strAddress = [d objectForKey:@"s_addr"];
            shop.distance = [d objectForKey:@"distance_show"];
            shop.intCmtCount = [[d objectForKey:@"s_cmt_count"] intValue];
            shop.fltAverage = [[d objectForKey:@"s_average"] floatValue];
            if ([[d objectForKey:@"s_categories"] length] > 0) {
                shop.tagList = [d objectForKey:@"s_categories"];
            }
            if ([[d objectForKey:@"coupon"] length] > 0) {
                SBCoupon *coupon = [SBCoupon new];
                coupon.topic = [d objectForKey:@"coupon"];
                shop.arrCouponList = [NSArray arrayWithObject:coupon];
                [coupon release];
            }
            [resultList addObject:shop];
            [shop release];
        }
        tableHeader.text = [self sectionTitle];
        
        if ([resultList count] < resultCount) {
            [super addPullLoadMore];
        } else {
            [super noMoreData];
        }
        // record current page
        currentPage++;
        [tableView reloadData];
    } else {
        [super noMoreData];
    }
    
    if (currentPage == 1) {
		[loadingView removeFromSuperview];
		[self performSelector:@selector(finishRefreshingData) withObject:nil afterDelay:0.01];
	} else {
		[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
	}
    
    [super hideLoading];
    
    // Check if there's no result
    if ([resultList count] == 0) {
		[self showNotFoundView];
	}
    Release(request);
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    header.userInteractionEnabled = YES;
    [super hideLoading];
	Release(request);
    
    if (currentPage == 0) {
		[loadingView removeFromSuperview];
		[self performSelector:@selector(finishRefreshingData) withObject:nil afterDelay:0.01];
	} else {
		[super noMoreData];
		[super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
	}
}


#pragma mark -
#pragma mark UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 2;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *data   = pickerView.tag == LeftPicker ? areaList : categoryList;
    NSInteger index = pickerView.tag == LeftPicker ? leftMainIndex : rightMainIndex;
    
	if (component == 0) {
        return [data count];
    } else {
        if ([data count] <= index) return 0;
        SBObject *sb = [data objectAtIndex:index];
        return [sb.children count];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
	return 125;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
	return 40;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component 
{
	NSArray *data   = pickerView.tag == LeftPicker ? areaList : categoryList;
    NSInteger index = pickerView.tag == LeftPicker ? leftMainIndex : rightMainIndex;

    if (component == 0) {
		SBObject *sb = [data objectAtIndex:row];
		return sb.name;
	} else {
		SBObject *sb = [data objectAtIndex:index];
		NSArray *subs = sb.children;
		if ([subs count] > 0) {
			SBObject *sub = [subs objectAtIndex:row];
			return sub.name;
		} else {
			return nil;
		}
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{	
    if (pickerView.tag == LeftPicker) {
		if ([areaList count] != 0 && component == 0) {
			leftMainIndex = row;
        }
    } else {
        if ([categoryList count] != 0 && component == 0) {
			rightMainIndex = row;
        }
    }
    [picker reloadComponent:1];
    return;
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


#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
	[refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
	
	if (isPullLoadMore) {
		[refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
	}

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
	
	if (isPullLoadMore) {
		[refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
	}
}

- (void)finishRefreshingData {
	isRefreshing = NO;
	[refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:tableView];
	
	refreshFooterView.frame = CGRectMake(0.0f, tableView.contentSize.height, tableView.frame.size.width, tableView.bounds.size.height);
}


#pragma mark -
#pragma mark EGORefreshTableFooterDelegate Methods
- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView*)v {
	Stat(@"search_list_downmore");
	isRefreshing = YES;
	[self refreshData];
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView*)v {
	return isRefreshing; // should return if data source model is reloading
}

- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)v {
	return [NSDate date]; // should return date data source was last changed
}


@end

