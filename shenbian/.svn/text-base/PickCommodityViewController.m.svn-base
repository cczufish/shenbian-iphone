//
//  PickCommodityViewController.m
//  shenbian
//
//  Created by MagicYang on 4/29/11.
//  Copyright 2011 百度. All rights reserved.
//

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


@implementation PickCommodityViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.title = @"填写菜名";
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"photobutton_selitem_into");
}

- (void)showLoading {
	isLoading = YES;
	[super showLoading];
}

- (void)hideLoading {
	isLoading = NO;
	[super hideLoading];
}

- (void)request
{
    CancelRequest(request);
    NSString *url = nil;
    switch (requestType) {
        case RequestTypeDefault:
            // http://bb-wiki-test06.vm.baidu.com:8060/iphone/getdefaultcommodity
            url = [NSString stringWithFormat:@"%@/getdefaultcommodity?s_fcrid=%@&p=%d&pn=999", 
				   ROOT_URL, [PhotoController singleton].shopId, currentPage];
            break;
        case RequestTypeSuggest:
            // http://client.shenbian.com/iphone/getsugC?w=xx
            url = [NSString stringWithFormat:@"%@/getsugC?w=%@", ROOT_URL, searchBar.searchText];
            break;
        case RequestTypeSearch:
            // no search here
            break;
    }
	
	[self showLoading];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestGET:url useStat:YES];
}

- (void)startLoadingData
{
    [self request];
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
    // do nothing
}

- (BOOL)showLastPhotoShop
{
    return requestType == RequestTypeDefault && [[CacheCenter sharedInstance] lastPhotoShop] != nil;
}

- (BOOL)needAddNewCommodity
{
    needNew = YES;
    NSString *kw = [searchBar.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (SBSuggestKeyword *sug in list) {
        if ([kw isEqualToString:sug.keyword]) {
            needNew = NO;
        }
    }
    return needNew;
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (requestType == RequestTypeDefault) {
		return [list count];
//        return [list count] + 1;
    } else {
        if ([self needAddNewCommodity]) {
            SBSuggestKeyword *sug = [SBSuggestKeyword new];
            sug.keyword = searchBar.searchText;
            [list insertObject:sug atIndex:0];
            [sug release];
        }
        return [list count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [SearchSuggestCellView heightOfCell:nil];
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellSuggestKeyword = @"CellSuggestKeyword";
    
    CustomCell *cell;
    
    if (YES) {
        cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellSuggestKeyword];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellSuggestKeyword] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            CustomCellView *cellView = [[SearchSuggestCellView alloc] initWithFrame:cell.frame];
            cell.cellView = cellView;
            [cellView release];
        }
        SBSuggestKeyword *sug = nil;
        if (indexPath.row == [list count]) {
            sug = [[SBSuggestKeyword new] autorelease];
            sug.keyword = @"环境等其他图片";
            ((SearchSuggestCellView *)cell.cellView).icon = PNGImage(@"camera_icon_arrow");
        } else {
			NSString *kw = [searchBar.searchText stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            if (needNew && indexPath.row == 0 && ![kw isEqualToString:@""]) {
                ((SearchSuggestCellView *)cell.cellView).icon = PNGImage(@"camera_icon_add");
            } else {
                ((SearchSuggestCellView *)cell.cellView).icon = nil;
            }
            sug = [list objectAtIndex:indexPath.row];
        }
        [cell setDataModel:sug];
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)_tableView heightForFooterInSection:(NSInteger)section {
	CGFloat height = 0;
	switch (section) {
		case 0:
//			if (!isLoading) {
				height = [SearchSuggestCellView heightOfCell:nil];
//			}
			break;
		default:
			break;
	}
	
	return height;
}

- (UIView *)tableView:(UITableView *)table viewForFooterInSection:(NSInteger)section {
	UIView *footerView = nil;
	if (0 == section/* && !isLoading */) {
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		button.frame = vsr(0, 0, 320, 40);
		button.backgroundColor = [Utility colorWithHex:0xf2efe8];
		
		[button addTarget:self 
				   action:@selector(onOtherSectionFooterDidTouched)
		 forControlEvents:UIControlEventTouchUpInside];
		
		//	箭头
		UIImageView *arrowImageView = [[UIImageView alloc] 
									   initWithFrame:vsrc(16, button.size.height / 2, 13, 13)];
		arrowImageView.image = PNGImage(@"camera_icon_arrow");
		
		[button addSubview:arrowImageView];
		[arrowImageView release];
		
		//	文字label
		UILabel *label = [[UILabel alloc] initWithFrame:vsr(30, 0, 200, button.size.height)];
		label.text = @"环境等其他图片";
		label.font = FontLiteWithSize(16);
        label.backgroundColor = [UIColor clearColor];
		
		[button addSubview:label];
		[label release];
		
		UIView *theView = [[UIView alloc] initWithFrame:button.frame];
		[theView addSubview:button];
		
		footerView = theView;
	}
	
	return [footerView autorelease];
}

- (void)onOtherSectionFooterDidTouched {
	[PhotoController singleton].commodity = @"";
	Stat(@"photobutton_selitem_click_other");
	
    PhotoSubmitVC* controller = [[PhotoSubmitVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
//    if ([list count] == indexPath.row) {
//        [PhotoController singleton].commodity = @"";
//		Stat(@"photobutton_selitem_click_other");
//    } else {
        SBSuggestKeyword *sug = [list objectAtIndex:indexPath.row];
        [PhotoController singleton].commodity = sug.keyword;
		Stat(@"photobutton_selitem_click_default?r=%d&total=%d&item_name=%@", indexPath.row, totalCount, sug.keyword);
//    }
    
    PhotoSubmitVC* controller = [[PhotoSubmitVC alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest *)req error:(NSError *)error {
	[self hideLoading];
    if (requestType == RequestTypeDefault) {
        [super noMoreData];
    }
    
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (void)requestSucceeded:(HttpRequest*)req {
	[self hideLoading];
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:request.recievedData error:&error];
	
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
    switch (requestType) {
        case RequestTypeDefault: {
            NSArray *arr = [dict objectForKey:@"results"];
			totalCount = [[dict objectForKey:@"total"] intValue];
            for (NSDictionary *d in arr) {
                SBSuggestKeyword *sug = [SBSuggestKeyword new];
                sug.keyword = [d objectForKey:@"c_name"];
                [list addObject:sug];
                [sug release];
            }
			
			[m_menu release];
			m_menu = [[NSArray alloc] initWithArray:list];
			
            if ([list count] < totalCount) {
//				isPullLoadMore = YES;
				[super addPullLoadMore];
            } else {
//				isPullLoadMore = NO;
                [super noMoreData];
            }
            // record current page
            currentPage++;
        } break;
        case RequestTypeSuggest: {
            [list removeAllObjects];

			NSString *keyword = [NSString stringWithString:searchBar.searchText];
			
			NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", keyword];
			
			for (SBSuggestKeyword *k in m_menu) {
				if ([predicate evaluateWithObject:k.keyword]) {
					[list addObject:k];
				}
			}
			
			NSInteger matchCount = [list count];
			
            NSArray *arr = [dict objectForKey:@"results"];
            for (NSDictionary *d in arr) {
				NSString *cname = [d objectForKey:@"c_name"];
				
				BOOL isContained = NO;
				for (int i = 0; i < matchCount; i++) {
					if ([((SBSuggestKeyword *)[list objectAtIndex:i]).keyword isEqualToString:cname]) {
						isContained = YES;
						break;
					}
				}
				
				if (!isContained) {
					SBSuggestKeyword *sug = [SBSuggestKeyword new];
					sug.keyword = cname;
					[list addObject:sug];
					[sug release];
				}
            }
			
        } break;
        case RequestTypeSearch:break; 
    }
    [tableView reloadData];
    
    Release(request);
    [loadingView removeFromSuperview];
    [super performSelector:@selector(finishLoadingData) withObject:nil afterDelay:0.01];
}

- (id)init {
    self = [super init];
	if (self) {
		m_menu = [NSArray array];
		isLoading = YES;
	}
	
	return self;
}

- (void)dealloc {
	[m_menu release];
	
	[super dealloc];
}
@end
