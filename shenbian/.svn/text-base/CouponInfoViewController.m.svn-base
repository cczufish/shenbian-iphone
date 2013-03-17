    //
//  CouponInfoViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-20.
//  Copyright 2010 personal. All rights reserved.
//

#import "CouponInfoViewController.h"
#import "ShopInfoViewController.h"
#import "SBJsonParser.h"
#import "HttpRequest+Statistic.h"
#import "Utility.h"
#import "SBCoupon.h"
#import "SBShopInfo.h"
#import "CustomCell.h"
#import "CouponInfoCellView.h"
#import "SBPopupTextField.h"
#import "LoadingView.h"
#import "Notifications.h"
#import "SBApiEngine.h"
#import "AlertCenter.h"


@implementation CouponInfoViewController

@synthesize shopId;
@synthesize phoneNumber;
@synthesize displayShop;
@synthesize selectedCouponId;

- (CouponInfoViewController *)initWithShopId:(NSString *)sid {
	if ((self = [super init])) {
        self.shopId  = sid;
		couponList   = [NSMutableArray new];
		smsRequests  = [NSMutableDictionary new];
	}
	return self;
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[Notifier removeObserver:self name:kCouponShowAllInfo object:nil];
	
	Release(tableView);
    CancelRequest(request);
}

- (void)requestCoupons
{
    if (!loadingView) {
        loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
    }
    
    [self.view addSubview:loadingView];
    
    // http://client.shenbian.com/iphone/getCouponDetail?s_fcrid=xxx
    NSString *url = [NSString stringWithFormat:@"%@/getCouponDetail?s_fcrid=%@", ROOT_URL, shopId];
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:NUM(InfoRequest), @"type", selectedCouponId, @"id", nil];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:dict];
    [request requestGET:url useCache:YES useStat:YES];
}

- (void)loadView {
	[super loadView];
	self.title = @"优惠详情";
    self.view.backgroundColor = [UIColor clearColor];
	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, displayShop ? 367 : 416) style:UITableViewStyleGrouped];	
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview:tableView];
    
    [self requestCoupons];
}

- (void)viewDidAppear:(BOOL)animated
{
    [Notifier addObserver:self selector:@selector(showAllInfo:) name:kCouponShowAllInfo object:nil];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [Notifier removeObserver:self name:kCouponShowAllInfo object:nil];
}

- (void)dealloc {
	CancelRequest(request);
    [shopId release];
	[tableView release];
	[couponList release];
	[phoneNumber release];
	[selectedCouponId release];
	// Cancel request by dealloc request array
	[smsRequests release];

    [super dealloc];
}

- (NSInteger)indexWithCouponId:(NSString *)coupondId {
    for (int i = 0; i < [couponList count]; i++) {
        SBCoupon *coupon = [couponList objectAtIndex:i];
        if ([coupon.couponId isEqualToString:coupondId]) {
            return i;
        }
    }
    
    // Never be here
    return 0;
}

- (void)showAllInfo:(NSNotification *)notification {
    NSInteger section = [self indexWithCouponId:[[notification userInfo] objectForKey:@"id"]];
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:section];
	[tableView reloadSections:indexSet
             withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getSMS:(id)sender {
	// 如果已经发出请求,则不作任何操作
	if ([smsRequests objectForKey:selectedCouponId]) {
		return;
	}
	
	SBCoupon *coupon = [couponList objectAtIndex:((UIButton *)sender).tag];
	self.selectedCouponId = coupon.couponId;
	
	SBPopupTextField *ptf = [[SBPopupTextField alloc] initWithTitle:@"请输入手机号码"
															message:@"\n"
														   delegate:self
												  cancelButtonTitle:@"取消"
												  otherButtonTitles:@"发送", nil];
	UITextField *tf = [ptf textField];
	tf.keyboardType = UIKeyboardTypeNumberPad;
	[tf becomeFirstResponder];
	[ptf show];
	[ptf release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	UITextField *tf = [(SBPopupTextField *)alertView textField];
	[tf resignFirstResponder];
	if (buttonIndex != [alertView cancelButtonIndex]) {
		if ([self.phoneNumber length] != 11) {
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"请输入正确的手机号" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
			[alert show];
			[alert release];
			return;
		}
		
		// http://client.shenbian.com/iphone/sendCoupon?fcrid=xxx&type=int (need cookie)
		NSString *url = [NSString stringWithFormat:@"%@/sendCoupon?fcrid=%@&tel=%@", ROOT_URL, selectedCouponId, tf.text];
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
                              NUM(SMSRequest), @"type", 
                              selectedCouponId, @"id", nil];
		HttpRequest *smsRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:dict];
        [smsRequest requestGET:url useCache:YES useStat:YES];
        [smsRequests setValue:smsRequest forKey:selectedCouponId];
        [smsRequest release];
	}
}

#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return [couponList count];
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {	
	return 2;
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SBCoupon *couponInfo = [couponList objectAtIndex:indexPath.section];
        return [CouponInfoCellView heightOfCell:couponInfo];        
    } else {
        return 60;
    }
}

- (CGFloat)tableView:(UITableView *)table heightForFooterInSection:(NSInteger)section {
	return ((SBCoupon *)[couponList objectAtIndex:section]).hasSMS ? 50 : 0;
}

- (UIView *)tableView:(UITableView *)table viewForHeaderInSection:(NSInteger)section {
	if (section == [couponList count]) {
		UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
		UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 200, 30)];
		label.font = FontWithSize(16);
		label.textColor = [UIColor redColor];
		label.text = @"适用商户:";
		label.backgroundColor = [UIColor clearColor];
		[v addSubview:label];
		[label release];
		return [v autorelease];
	} else {
		return nil;
	}
}

- (UIView *)tableView:(UITableView *)table viewForFooterInSection:(NSInteger)section {
    SBCoupon *coupon = [couponList objectAtIndex:section];
    if (coupon.hasSMS) {
        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 45)];
        footer.backgroundColor = [UIColor clearColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.tag = section;
        [button setFrame:CGRectMake(68, 10, 183, 31)];
        [button setTitle:@"短信下载" forState:UIControlStateNormal];
        // Here button image status has been exchanged due to wrong image name
        [button setImage:PNGImage(@"button_sms_1") forState:UIControlStateNormal];
        [button setImage:PNGImage(@"button_sms_0") forState:UIControlStateHighlighted];
        [button addTarget:self action:@selector(getSMS:) forControlEvents:UIControlEventTouchUpInside];
        [footer addSubview:button];
        return [footer autorelease];
    } else {
        return nil;
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CouponInfoCell = @"CouponInfoCell";
    static NSString *DuringTimeCell = @"DuringTimeCell";
	
	UITableViewCell *cell;
    SBCoupon *couponInfo = [couponList objectAtIndex:indexPath.section];
    if (indexPath.row == 0) {	// 详细信息
        cell = [table dequeueReusableCellWithIdentifier:CouponInfoCell];
        if (cell == nil) {
            cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CouponInfoCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            CustomCellView *cellView = [[CouponInfoCellView alloc] initWithFrame:cell.frame];
            ((CustomCell *)cell).cellView = cellView;
            [cellView release];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        [((CustomCell *)cell) setDataModel:couponInfo];
    } else {	// 有效期
        cell = [table dequeueReusableCellWithIdentifier:DuringTimeCell];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:DuringTimeCell] autorelease];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        
        for (UIView *subView in [cell.contentView subviews]) {
            if ([subView isKindOfClass:[UILabel class]]) {
                [subView removeFromSuperview];
            }
        }
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 200, 20)];
        titleLabel.text = @"有效期:";
        titleLabel.font = FontWithSize(16);
        titleLabel.textColor = [UIColor redColor];
        titleLabel.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:titleLabel];
        [titleLabel release];
        
        UILabel	*timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 30, 200, 20)];
        timeLabel.font = FontLiteWithSize(14);
        timeLabel.textColor = [UIColor blackColor];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = [NSString stringWithFormat:@"%@ 至 %@", [couponInfo startTimeString], [couponInfo endTimeString]];
        [cell.contentView addSubview:timeLabel];
        [timeLabel release];
    }

    return cell;
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest *)req error:(NSError *)error {
	RequestType type = [[req.extraData objectForKey:@"type"] intValue];
	if (type == InfoRequest) {
		Release(request);
	} else {
		[smsRequests removeObjectForKey:[req.extraData objectForKey:@"id"]];
	}
    [loadingView removeFromSuperview];
}

- (void)requestSucceeded:(HttpRequest*)req {
	RequestType type = [[req.extraData objectForKey:@"type"] intValue];
    NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:req.recievedData error:&error];
    if (error) {
        [self requestFailed:req error:error];
        return;
    }
    
	if (type == InfoRequest) {
        for (NSDictionary *d in [dict objectForKey:@"coupon"]) {
            SBCoupon *coupon = [[SBCoupon alloc] initWithDictionary:d];
            [couponList addObject:coupon];
            [coupon release];
        }
        [tableView reloadData];
        Release(request);
	} else {
        Alert(@"下载成功", @"优惠券会以短信形式发送到您手机");
		[smsRequests removeObjectForKey:[req.extraData objectForKey:@"id"]];
	}
    [tableView reloadData];
    [loadingView removeFromSuperview];
}


#pragma mark -
#pragma mark TextFieldDelegate
- (BOOL)textField:(UITextField *)tf shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if ([tf.text isEqualToString:@" "] ||  [tf.text length] >= 11) {
		return NO;
	}
	
	NSString *txt= [tf.text stringByReplacingCharactersInRange:range withString:string];
	self.phoneNumber = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
	return YES;
}

@end
