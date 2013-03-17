//
//  ShopInfoViewController.m
//  shenbian
//
//  Created by MagicYang on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "ShopInfoViewController.h"
#import "ShopMapInfoViewController.h"
#import "FeedbackViewController.h"
#import "ShopInfoPopupView.h"
#import "CommentListViewController.h"
#import "CommodityPhotoDetailVC.h"
#import "CommodityListViewController.h"
#import "CouponInfoViewController.h"
#import "AlbumViewController.h"
#import "PhotoController.h"

#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "CacheCenter.h"
#import "Notifications.h"

#import "SBShopInfo.h"
#import "SBCoupon.h"
#import "SBComment.h"
#import "SBCommodityList.h"

#import "LoadingView.h"
#import "CustomCell.h"
#import "CustomCellView.h"
#import "ShopInfoCellView.h"

#import "WTFButton2.h"
#import "LoginController.h"
#import "SBVoteRequest.h"
#import "SBApiEngine.h"

enum {
	ShareActionsheet = 1,
	CallActionsheet  = 2,
	MoreActionsheet  = 3
};

// ActionSheet Title
#define kSMS         @"短信"
#define kEmail	     @"邮件"
#define kCancel	     @"取消"
#define kSMSFriend   @"短信告诉朋友"
#define kReportError @"报错"


@interface ShopInfoViewController()

- (CustomCellView *)mappingCellView:(SectionType)type;
- (CGFloat)mappingHeight:(SectionType)type withRow:(NSInteger)row;
- (NSInteger)numberOfRowsOfContactSection;
- (void)requestShopInfo;

- (void)showMap:(id)sender;
- (void)call:(id)sender;
- (void)share;
- (void)report;
- (void)showMoreInfo:(id)sender;

@end


@implementation ShopInfoViewController

- (id)initWithShopId:(NSString *)shopId
{
    self = [super init];
    if (self) {
        self.title = @"商户详情";
        shopInfo = [SBShopInfo new];
        shopInfo.shopId = shopId;
        sections = [NSMutableArray new];
        
//        [Notifier addObserver:self selector:@selector(refreshShopInfo) name:kPhotoSucceed object:nil];
    }
    return self;
}

- (void)dealloc
{
//    [Notifier removeObserver:self name:kPhotoSucceed object:nil];
    
    CancelRequest(request);
    CancelRequest(hcVoteShop);
    [tableView release];
    [loadingView release];
    [sections release];
    [shopInfo release];
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    CancelRequest(request);
    Release(tableView);
    Release(loadingView);
}

- (void)loadView
{
    [super loadView];
    self.view.backgroundColor = [UIColor clearColor];
    
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraBtn.frame = CGRectMake(0, 0, 44, 30);
    [cameraBtn setImage:PNGImage(@"button_navigation_camera_0") forState:UIControlStateNormal];
    [cameraBtn setImage:PNGImage(@"button_navigation_camera_1") forState:UIControlStateHighlighted];
    [cameraBtn addTarget:self action:@selector(takePhoto:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:cameraBtn] autorelease];
    self.navigationItem.rightBarButtonItem.enabled = NO;
    
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];	
	tableView.backgroundColor = [UIColor whiteColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:0.880 green:0.880 blue:0.880 alpha:1];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview:tableView];
    
    [self requestShopInfo];
}

- (void)viewDidAppear:(BOOL)animated
{
	Stat(@"shopdetail_into?s_fcry=%@", shopInfo.shopId);
    [super viewDidAppear:animated];
    [Notifier addObserver:self selector:@selector(call:) name:kShopActionCall object:nil];
    [Notifier addObserver:self selector:@selector(showMap:) name:kShopActionShowMap object:nil];
    [Notifier addObserver:self selector:@selector(takePhotoForCommodity:) name:kShopActionTakePhoto object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [Notifier removeObserver:self name:kShopActionCall object:nil];
    [Notifier removeObserver:self name:kShopActionShowMap object:nil];
    [Notifier removeObserver:self name:kShopActionTakePhoto object:nil];
}

#pragma mark -
#pragma mark PrivateMethods
- (CustomCellView *)mappingCellView:(SectionType)type {	
	switch (type) {
        case SectionCoupon: return [[ShopCouponCellView new] autorelease];
        case SectionContact: return [[ShopContactCellView new] autorelease];
        case SectionCommondity: return [[ShopCommodityCellView new] autorelease];
        case SectionComment: return [[ShopCommentCellView new] autorelease];
        default: return nil;
	}
}

- (CGFloat)mappingHeight:(SectionType)type withRow:(NSInteger)row {
	switch (type) {
        case SectionCoupon: return [ShopCouponCellView heightOfCell:shopInfo];
        case SectionContact: {
            if (row == 1 || (([shopInfo.strAddress length] == 0 && [shopInfo.arrTel count] == 0))) {
                return 40;
            } else {
                return [ShopContactCellView heightOfCell:shopInfo];
            }
        }
        case SectionCommondity: {
            if (row > 2) {
                return 40;
            } else {
                return [ShopCommodityCellView heightOfCell:shopInfo];
            }
        }
        case SectionComment: return [ShopCommentCellView heightOfCell:shopInfo];
        default: return 40;
	}
}

- (NSInteger)numberOfRowsOfContactSection
{
    NSInteger nRow = 0;
    if ([shopInfo.strAddress length] > 0 || [shopInfo.arrTel count] > 0) nRow++;
    if ([[shopInfo.moreInfo allKeys] count] > 0)             nRow++;
    return nRow;
}

- (void)requestShopInfo
{
	if (!loadingView)
		loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
	[self.view addSubview:loadingView];
	
	// http://bb-wiki-test06.vm.baidu.com:8060/iphone/getshopdetail?s_fcrid=3172b409d924e0723d38ecf0 （其他任意ID为美食类商户）
	NSString *url = [NSString stringWithFormat:@"%@/getShopDetail?s_fcrid=%@", ROOT_URL, shopInfo.shopId];
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[request requestGET:url useCache:NO useStat:YES];
}

// 查看地图
- (void)showMap:(id)sender {
	Stat(@"shopdetail_map");
	BaiduLocation location = {shopInfo.fltPositionX, shopInfo.fltPositionY};
	ShopMapInfoViewController *controller = [[ShopMapInfoViewController alloc] initWithLocation:location];
	controller.shopName = shopInfo.strName;	
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
	[self presentModalViewController:navController animated:YES];
	[navController release];
	[controller release];
}

- (void)takePhotoForCommodity:(NSNotification *)notification {
    SBCommodity *commodity = [[notification userInfo] objectForKey:@"commodity"];
    PhotoController *pc = [PhotoController singleton];
    pc.shopId = shopInfo.shopId;
    pc.shopName = shopInfo.strName;
    pc.commodity = commodity.cname;
    [pc showActionSheet];
}

// 拨打商户电话
- (void)call:(id)sender {
	Stat(@"shopdetail_call");
	// 非iPhone的iOS设备禁用拨打电话功能
	if ([[[UIDevice currentDevice] model] isEqualToString:@"iPhone"]) {
		UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择商户电话" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
		sheet.tag = CallActionsheet;
		for (NSString *tel in shopInfo.arrTel) {
			[sheet addButtonWithTitle:tel];
		}
		[sheet addButtonWithTitle:@"取消"];
		[sheet setCancelButtonIndex:[shopInfo.arrTel count]];
		[sheet showInView:self.view];
		[sheet release];
	}
}

// 分享商户信息
- (void)share 
{
	UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"分享商户信息"
													   delegate:self
											  cancelButtonTitle:nil
										 destructiveButtonTitle:nil
											  otherButtonTitles:nil];
	sheet.tag = ShareActionsheet;
	NSInteger index = 0;
	if([MFMessageComposeViewController canSendText]) {
		[sheet addButtonWithTitle:kSMS];
		index++;
	}
	[sheet addButtonWithTitle:kEmail]; index++;
	[sheet addButtonWithTitle:kCancel];
	sheet.cancelButtonIndex = index;
	[sheet showInView:self.view];
	[sheet release];
}

// 报错
- (void)report {
	Stat(@"report_into");
	FeedbackViewController *controller = [FeedbackViewController new];
	controller.shopId = shopInfo.shopId;
	[self.navigationController pushViewController:controller animated:YES];
	[controller release];
}

// 查看更多信息
- (void)showMoreInfo:(id)sender {
	Stat(@"shopdetail_more");
	if (![self.navigationController.topViewController isEqual:self]) return;
	
	ShopInfoPopupView *popupView = [[ShopInfoPopupView alloc] initWithShopInfo:shopInfo];
	[popupView show];
	[popupView release];
}

- (void)takePhoto:(id)sender {
	Stat(@"shopdetail_clickphoto");
    PhotoController *pc = [PhotoController singleton];
    pc.shopId   = shopInfo.shopId;
    pc.shopName = shopInfo.strName;
    pc.commodity = shopInfo.isCommodityShop ? nil : @"";
    [pc showActionSheet];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	[sections removeAllObjects];
	
	if ([shopInfo.arrCouponList count] > 0) {
		[sections addObject:NUM(SectionCoupon)];
	}
    
    if ([shopInfo.strAddress length] > 0 || [shopInfo.arrTel count] > 0 || [[shopInfo.moreInfo allKeys] count] > 0) {
		[sections addObject:NUM(SectionContact)];
	}
    
    if ([shopInfo.commodityList count] > 0) {
        [sections addObject:NUM(SectionCommondity)];
    }
    
	if ([shopInfo.arrCmtList count] > 0) {
		[sections addObject:NUM(SectionComment)];
	}
    
    if (shopInfo.intPicCount > 0) {
        [sections addObject:NUM(SectionPicCount)];
    }
	
	return [sections count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    SectionType st = [[sections objectAtIndex:section] intValue];
    if (st == SectionContact) {
        return [self numberOfRowsOfContactSection];
    } else if (st == SectionCommondity) {
        return shopInfo.intCommodityCount > 3 && [shopInfo.commodityList count] >= 3 ? 4 : [shopInfo.commodityList count]; // Here need to know #shopInfo.commodityList# count >= 3, there's some error data from server
    } else {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return [self mappingHeight:[[sections objectAtIndex:indexPath.section] intValue] withRow:indexPath.row];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    SectionType st = [[sections objectAtIndex:section] intValue];
    if (st == SectionCommondity || st == SectionComment) {
        return 35;
    } else {
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SectionType st = [[sections objectAtIndex:section] intValue];
    if (st == SectionCommondity) {
        return [[[ShopSectionHeaderCellView alloc] initWithIcon:PNGImage(@"shop_icon_commodity") 
                                                       andTitle:[NSString stringWithFormat:@"菜单(%d)", shopInfo.intCommodityCount]] autorelease];
    } else if (st == SectionComment) {
        return [[[ShopSectionHeaderCellView alloc] initWithIcon:PNGImage(@"shop_icon_comment")
                                                       andTitle:[NSString stringWithFormat:@"点评(%d)", shopInfo.intCmtCount]] autorelease];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SectionType st = [[sections objectAtIndex:indexPath.section] intValue];
	NSString *CellIdentifier = [NSString stringWithFormat:@"CellID-%d-%d", indexPath.section, indexPath.row];
	
    if ((st == SectionContact && (indexPath.row == 1 || ([shopInfo.strAddress length] == 0 && [shopInfo.arrTel count] == 0)))
        || (st == SectionCommondity && indexPath.row > 2)
        || st == SectionPicCount) {
        // 普通Cell
        UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.textLabel.font = FontWithSize(16);
        }
        cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.accessoryType = UITableViewCellAccessoryNone;
        if (st == SectionContact) {
            cell.textLabel.text = @"查看更多信息";
        } else if (st == SectionCommondity) {
            cell.textLabel.text = @"查看全部菜单";
        } else if (st == SectionPicCount){
            cell.textLabel.text = [NSString stringWithFormat:@"更多图片(%d)", shopInfo.intPicCount];
        }
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        return cell;
    } else {
        // 定制Cell
        CustomCell *cell = (CustomCell *)[table dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
            cell.cellView = [self mappingCellView:st];
            cell.cellView.frame = cell.frame;
        }
        
        cell.accessoryType = (st == SectionContact || st == SectionCoupon) ? UITableViewCellAccessoryNone : UITableViewCellAccessoryDisclosureIndicator;
        
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.selectionStyle = UITableViewCellSelectionStyleGray;
        if (st == SectionCommondity) {
            SBCommodity *commodity = [shopInfo.commodityList objectAtIndex:indexPath.row];
            [cell setDataModel:commodity];
            cell.accessoryType = commodity.ccount > 0 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        } else {
            [cell setDataModel:shopInfo];
        }
        
        return cell;
    }
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [table deselectRowAtIndexPath:indexPath animated:YES];
    
    SectionType st = [[sections objectAtIndex:indexPath.section] intValue];
	DLog(@"row: %d", st);
    switch (st) {
        case SectionCoupon: {
            CouponInfoViewController *controller = [[CouponInfoViewController alloc] initWithShopId:shopInfo.shopId];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case SectionContact: {
            if (indexPath.row == 1 || ([shopInfo.strAddress length] == 0 && [shopInfo.arrTel count] == 0)) {
                [self showMoreInfo:nil];
            }
        } break;
        case SectionCommondity: {
            if (indexPath.row == 3) {
                CommodityListViewController *controller = [CommodityListViewController new];
                controller.shopId   = shopInfo.shopId;
                controller.shopName = shopInfo.strName;
                [self.navigationController pushViewController:controller animated:YES];
                [controller release];
            } else {
                SBCommodity *com = [shopInfo.commodityList objectAtIndex:indexPath.row];
                if (com.ccount > 0) {
					Stat(@"shopdetail_clickitem?r=%d&p_fcry=%@", indexPath.row, com.pid);
                    CommodityPhotoDetailVC *controller = [[CommodityPhotoDetailVC alloc] initWithCommdity:com displayType:CommodityPhotoDetailTypeCommodityOnly];
                    controller.from = CommodityPhotoSourceFromShopInfo;
                    [self.navigationController pushViewController:controller animated:YES];
                    [controller release];
                }
            }
        } break;
        case SectionComment: {
            if (shopInfo.intCmtCount == 0) {
                return;
            }
            
            CommentListViewController *controller = [[CommentListViewController alloc] initCommentListControllerWithShop:shopInfo];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case SectionPicCount: {
            AlbumViewController *controller = [[AlbumViewController alloc] initWithShopId:shopInfo.shopId];
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
    }
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {
    
    if (req == hcVoteShop) {
        NSError* error = nil;
        [SBApiEngine parseHttpData:req.recievedData
                             error:&error];
        if (error) {
            [self requestFailed:req error:error];
        }else{
            WTFButton2* button = hcVoteShop.withObj;
            [button setVisited:YES];
            button.enabled = NO;
            hcVoteShop.withObj = nil;
        }
        return;
    }
    
	if (req.statusCode == 200) {
        self.navigationItem.rightBarButtonItem.enabled = YES;
        
        //TODO: replace these codes by SBAPIengine
        NSError *outError = NULL;
        SBJsonParser *parser = [SBJsonParser new];
        NSString *str = [[NSString alloc] initWithData:req.recievedData encoding:NSUTF8StringEncoding];
        NSDictionary *dict = [parser objectWithString:str error:&outError];
        [str release];
        [parser release];
        if (outError) {
            DLog(@"Request shop info, error:%@", outError);
        } else {
            // 基本信息
            if (!IMG_BASE_URL) {
                [CacheCenter sharedInstance].imagePath = [dict objectForKey:@"pic_path"];
            }
            
            NSDictionary *shopDict     = [dict objectForKey:@"shop"];
            shopInfo.isCommodityShop   = [[dict objectForKey:@"show_mode"] boolValue];
            shopInfo.intPicCount       = [[dict objectForKey:@"albums_total"] intValue];
            shopInfo.intCmtCount       = [[dict objectForKey:@"cmt_total"] intValue];
            shopInfo.intCommodityCount = [[dict objectForKey:@"c_total"] intValue];
            shopInfo.strName           = [shopDict objectForKey:@"s_name"];
            shopInfo.fltAverage        = [[shopDict objectForKey:@"s_average"] floatValue];
            shopInfo.intScoreTotal     = [[shopDict objectForKey:@"s_score"] intValue];
            shopInfo.intBeenCount      = [[shopDict objectForKey:@"s_vote"] intValue];
            shopInfo.been              = [[shopDict objectForKey:@"is_vote"] boolValue];
            if ([[shopDict objectForKey:@"s_subscore"] isKindOfClass:[NSDictionary class]]) {
                shopInfo.arrScore      = [shopDict objectForKey:@"s_subscore"];
            }
            shopInfo.strAddress        = [shopDict objectForKey:@"s_addr"];
            shopInfo.arrTel            = [shopDict objectForKey:@"s_tel"];
            if ([[shopDict objectForKey:@"s_minfo"] isKindOfClass:[NSDictionary class]]) {
                shopInfo.moreInfo = [shopDict objectForKey:@"s_minfo"]; // 更多信息
            }
            shopInfo.fltPositionX      = [[shopDict objectForKey:@"s_x"] floatValue];
            shopInfo.fltPositionY      = [[shopDict objectForKey:@"s_y"] floatValue];
            
            // 优惠
            NSArray *couponList = [dict objectForKey:@"coupon"];
            NSMutableArray *couponArr = [NSMutableArray array];
            for (NSDictionary *couponDict in couponList) {
                SBCoupon *coupon = [SBCoupon new];
                coupon.topic   = [couponDict objectForKey:@"title"];
                coupon.type    = [couponDict objectForKey:@"type"];
                [couponArr addObject:coupon];
                [coupon release];
            }
            shopInfo.arrCouponList = couponArr;
            
            // 菜单 (美食类)
            NSArray *commodityList = [dict objectForKey:@"commodity"];
            NSMutableArray *commodityArr = [NSMutableArray array];
            for (NSDictionary *commodityDict in commodityList) {
                NSMutableDictionary *newDict = [NSMutableDictionary dictionaryWithDictionary:commodityDict];
                [newDict setObject:shopInfo.shopId forKey:@"s_fcrid"];
                SBCommodity *commodity = [[SBCommodity alloc] initWithDict:newDict imagePrefix:IMG_BASE_URL];
                [commodityArr addObject:commodity];
                [commodity release];
            }
            shopInfo.commodityList = commodityArr;
            
            // 点评
            if ([[dict objectForKey:@"comment"] count] > 0) {
                NSDictionary *cmtDict = [[dict objectForKey:@"comment"] objectAtIndex:0];
                SBComment *cmt   = [SBComment new];
                cmt.userName   = [cmtDict objectForKey:@"cmt_uname"];
                cmt.totalScore = [[cmtDict objectForKey:@"cmt_rate"] intValue] * 2;
                cmt.content    = [cmtDict objectForKey:@"cmt_content_show"] ?
				[cmtDict objectForKey:@"cmt_content_show"] : [cmtDict objectForKey:@"cmt_content"];
                cmt.userImg    = nil;
                cmt.userImgUrl = [IMG_BASE_URL stringByAppendingString:[cmtDict objectForKey:@"cmt_uavatar"]];
                shopInfo.arrCmtList = [NSArray arrayWithObject:cmt];
                [cmt release];
            }

            [tableView reloadData];
            ShopBasicInfoView* headerView = [[ShopBasicInfoView alloc] initWithShop:shopInfo];
            if (headerView.wtfButton.isVisited) {
                headerView.wtfButton.enabled = NO;
            }
            [headerView.wtfButton addTarget:self
                                     action:@selector(onBtnVisited:)
                           forControlEvents:UIControlEventTouchUpInside];
            tableView.tableHeaderView =  headerView;
            [headerView release];
            tableView.tableFooterView = [[[ShopFooterView alloc] initWithFrame:CGRectMake(0, 0, 320, 40) andDelegate:self] autorelease];
			
            
			[[CacheCenter sharedInstance] recordBrowsedShop:shopInfo];
        }
    }
    Release(request);
    [loadingView removeFromSuperview];
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    
    if (req == hcVoteShop) {
        WTFButton2* btn =  hcVoteShop.withObj;
        btn.enabled = YES;
        hcVoteShop.withObj = nil;
        return;
    }
    
    if (req == request) {
        Release(request);
        [loadingView removeFromSuperview];
    }

}


- (void)onBtnVisited:(WTFButton2*)button
{
	Stat(@"shopdetail_beento");
    LoginController* loginC = [LoginController sharedInstance];
    if (![loginC isLogin]) {
        [loginC showLoginView];
    }else{
        if (!hcVoteShop) {
            hcVoteShop = [[SBVoteRequest alloc] init];
            hcVoteShop.delegate = self;
        }
        hcVoteShop.withObj = button;
        button.enabled = NO;
        [hcVoteShop voteForType:SBVoteRequestTypeShop
                           item:shopInfo.shopId
                         action:YES];
    }
}




#pragma mark -
#pragma mark UIActionSheetDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mailto://"]];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == ShareActionsheet) {
		if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:kSMS]) {
			// 短信分享
			Stat(@"shopdetail_friend?m=0");
            MFMessageComposeViewController *controller = [MFMessageComposeViewController new];
			controller.messageComposeDelegate = self;
			controller.body = [NSString stringWithFormat:@"[%@]", shopInfo.strName];
			if ([shopInfo.arrTel count] > 0) {
				controller.body = [controller.body stringByAppendingFormat:@" %@", [shopInfo.arrTel objectAtIndex:0]];
			}
			if ([shopInfo.strAddress length] > 0) {
				controller.body = [controller.body stringByAppendingFormat:@" %@", shopInfo.strAddress];
			}
			if ([shopInfo hasRecommend]) {
				controller.body = [controller.body stringByAppendingFormat:@" [%@] %@", shopInfo.strRecommendName, [shopInfo recommendString]];
			}			
			[self presentModalViewController:controller animated:YES];
			[controller release];
		} else if ([[actionSheet buttonTitleAtIndex:buttonIndex] isEqual:kEmail]) {
			// 邮件分享
			Stat(@"shopdetail_friend?m=1");
			if (![MFMailComposeViewController canSendMail]) {
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
																message:@"您还没有设置邮箱，需要马上设置吗?"
															   delegate:self
													  cancelButtonTitle:@"不，谢谢"
													  otherButtonTitles:@"好的", nil];
				[alert show];
				[alert release];
				return;
			}
			MFMailComposeViewController *controller = [MFMailComposeViewController new];
			controller.mailComposeDelegate = self;
			NSString *body = [NSString stringWithFormat:@"[%@]", shopInfo.strName];
			if ([shopInfo.arrTel count] > 0) {
				body = [body stringByAppendingFormat:@" %@", [shopInfo.arrTel objectAtIndex:0]];
			}
			if ([shopInfo.strAddress length] > 0) {
				body = [body stringByAppendingFormat:@" %@", shopInfo.strAddress];
			}
			if ([shopInfo hasRecommend]) {
				body = [body stringByAppendingFormat:@" [%@] %@", shopInfo.strRecommendName, [shopInfo recommendString]];
			}
			[controller setMessageBody:body isHTML:NO];
			[self presentModalViewController:controller animated:YES];
			[controller release];
		} else {
			// Click cancel, do nothing
			Stat(@"shopdetail_friend?m=2");
		}
	} else if (actionSheet.tag == CallActionsheet) {
		if (buttonIndex != actionSheet.cancelButtonIndex) {
			NSString *tel = [actionSheet buttonTitleAtIndex:buttonIndex];
			NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@", tel]];
			if ([[UIApplication sharedApplication] canOpenURL:url]) {
				[[UIApplication sharedApplication] openURL:url];
			}	
		}
	} else {
        [self report];
	}
}


#pragma mark -
#pragma mark MFMailComposeViewControllerDelegate
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error {
	[controller dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark MFMessageComposeViewControllerDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
	[controller dismissModalViewControllerAnimated:YES];
}

@end
