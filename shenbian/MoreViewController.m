//
//  MoreViewController.m
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "MoreViewController.h"
#import "CacheCenter.h"
#import "ProvincePickerViewController.h"
#import "IntroViewController.h"
#import "FeedbackViewController.h"
#import "AboutViewController.h"
#import "LoginController.h"
#import "WeiboBindController.h"
#import "Notifications.h"
#import "AppDelegate.h"
#import "VSSwitchCell.h"
#import "HttpRequest+Statistic.h"
#import "SBApiEngine.h"
#import "SBAdvertisementView.h"
#import "Utility.h"

@interface MoreViewController ()
	

- (void) setLoginButtonTitle;
- (void)setSigninButtonTitle;
- (void)setSignoutButtonTitle;

@end

@implementation MoreViewController

@synthesize _dataSource, cityLabel = _cityLabel, loginButton;
//@synthesize adModel;

- (void)loadTableData
{
	self._dataSource = [NSArray arrayWithObjects:
						[NSArray arrayWithObjects: @"切换城市", nil],
						[NSArray arrayWithObjects: @"最近浏览", @"玩转身边", @"意见反馈",@"去App Store给好评", @"关于我们", @"绑定新浪微博", nil],
						nil];
	
}

- (void)dealloc
{
	self._dataSource = nil;
	self.cityLabel = nil;
	
    [super dealloc];
}

- (void)initTableView {
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 367) style:UITableViewStyleGrouped];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
}

#pragma mark -
#pragma mark Advertisement
- (void)loadAdvertisement {
	[adController release];
	adController = [[AdvertisementController alloc] initWithFrame:vsr(0, 0, 320, 40)
													  andDelegate:self
													  andDuration:0
														   andUrl:nil];
	[adController loadAdvertisement];
}


- (void)advertisementLoadSuccess:(id)sender {
	tableView.frame = vsr(0, 40, 320, 332);
	[self.view bringSubviewToFront:navShadow];
}

- (void)advertisementWillHide:(SBAdvertisementView *)adObject {
	[UIView beginAnimations:@"hideAdInMorePage" context:nil];
	[UIView setAnimationDuration:0.75f];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(animationDone:finished:context:)];
	[UIView setAnimationTransition:UIViewAnimationCurveEaseInOut forView:adObject cache:YES];
	
	adObject.origin = CGPointMake(0, -40);
	tableView.height = 367;
	
	[UIView commitAnimations];	
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	historyCount = [[CacheCenter sharedInstance].shopBrowseHistory count];
	[tableView reloadData];
	
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
	Stat(@"more_into");
}

- (void)loadView
{
	[super loadView];
	self.view.backgroundColor = [UIColor clearColor];
	self.title = @"更多";
	
	//	bg image
	UIImageView* bgImageView = [[UIImageView alloc] initWithImage:PNGImage(@"common_bg")];
	bgImageView.frame = vsr(0, -108, 320, 480);
	[self.view insertSubview:bgImageView atIndex:0];
	[bgImageView release];
	
	UIView* loginButtonView = [[UIView alloc] initWithFrame:vsr(0, 0, 320, 44)];
	UIButton* _loginButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	_loginButton.frame = vsr(10, 0, 300, loginButtonView.size.height);
	
	self.loginButton = _loginButton;
	[self setLoginButtonTitle];
	[loginButtonView addSubview:loginButton];
	tableView.tableFooterView = loginButtonView;
	[loginButtonView release];
	
}

- (void) setLoginButtonTitle
{
	if ([[LoginController sharedInstance] isLogin]) {
		[self setSignoutButtonTitle];
	} else {
		[self setSigninButtonTitle];
	}
	[tableView reloadData];
}

- (void)setSigninButtonTitle {
	[loginButton removeTarget:self
					   action:@selector(btnSignoutTouched)
			 forControlEvents:UIControlEventAllEvents];
	[loginButton setTitle:@"登录" forState:UIControlStateNormal];
	[loginButton addTarget:self
					action:@selector(btnSigninTouched)
		  forControlEvents:UIControlEventTouchUpInside];
	[tableView reloadData];
}

- (void)setSignoutButtonTitle {
	[loginButton removeTarget:self
					   action:@selector(btnSigninTouched)
			 forControlEvents:UIControlEventAllEvents];
	[loginButton setTitle:@"注销" forState:UIControlStateNormal];
	[loginButton addTarget:self
					action:@selector(btnSignoutTouched)
		  forControlEvents:UIControlEventTouchUpInside];
	[tableView reloadData];
}

- (void) btnSigninTouched
{
	[[LoginController sharedInstance] showLoginView];
}

- (void) btnSignoutTouched
{
	UIActionSheet *as = [[UIActionSheet alloc] initWithTitle:@"确定要注销吗？"
													delegate:self
										   cancelButtonTitle:@"取消"
									  destructiveButtonTitle:nil
										   otherButtonTitles:@"确认", nil];
	[as setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
	[as showInView:[AppDelegate sharedDelegate].window];
	[as release];
}

#pragma mark - actionsheet delegates

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//pressed cancel button
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
	
	[[LoginController sharedInstance] logout];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self loadTableData];
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setSignoutButtonTitle)
												 name:kLoginSucceeded
											   object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(setSigninButtonTitle)
												 name:kLogoutSucceeded
											   object:nil];
	historyCount = [[CacheCenter sharedInstance].shopBrowseHistory count];
	[self loadAdvertisement];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:kLoginSucceeded object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:kLogoutSucceeded object:nil];	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)switchCity:(id)sender
{
    ProvincePickerViewController *controller = [[ProvincePickerViewController alloc] initWithDelegate:self];
    controller.title = @"选择城市";
    controller.isForceChoose = sender ? NO : YES;
    controller.delegate = self;
    controller.hasTabbar = NO;
    controller.isCascadeCity = YES;
    controller.needLocating = YES;
    controller.hasCancelButton = YES;
	
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self showModalViewController:nc animated:(sender != nil)];
    [controller release];
    [nc release];
}

- (void)switchChanged:(id)sender
{
    CancelRequest(request);
    UISwitch *switchView = (UISwitch *)sender;
    isSync = switchView.on;
    
    // http://client.shenbian.com/iphone/setSns
    NSString *url = [NSString stringWithFormat:@"%@/setSns", ROOT_URL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            NUM(2), @"plat",    //1 人人网（本次不使用）2 新浪微博
                            NUM(isSync), @"c",  //0 取消授权 1 授权 （当c=1，服务端才会读取key和token）
                            nil];
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestPOST:url parameters:params useStat:YES];
}


#pragma mark -
#pragma mark table view
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [_dataSource count];
}
   
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section 
{
    if (section == 1 && ![[LoginController sharedInstance] isLogin]) {
        return 5;   // Remove weibo bind row
    } else {
        return [[_dataSource objectAtIndex:section] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *CellIdentifier0 = @"Cell0";
    static NSString *CellIdentifier1 = @"Cell1";
    
    UITableViewCell *cell;
    
    if (indexPath.section == 1 && indexPath.row == 5 && [LoginController sharedInstance].isWeiboBind) {
        cell = [table dequeueReusableCellWithIdentifier:CellIdentifier0];
        if (!cell) {
            cell = [[[VSSwitchCell alloc] initWithDelegate:self reuseIdentifier:CellIdentifier0] autorelease];
            ((VSSwitchCell *)cell).delegate = self;
            ((VSSwitchCell *)cell).label.text = @"新浪微博同步";
            ((VSSwitchCell *)cell).label.font = FontLiteWithSize(16);
        }
        ((VSSwitchCell *)cell).switchView.on = [LoginController sharedInstance].isWeiboSync;
    } else {
        cell = [table dequeueReusableCellWithIdentifier:CellIdentifier1];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier1] autorelease];
            cell.textLabel.font = FontLiteWithSize(16);
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        int section = indexPath.section;
        int row = indexPath.row;
        
        cell.textLabel.text = [(NSArray*)[_dataSource objectAtIndex:section] objectAtIndex:row];
        if (0 == section && 0 == row) {
            //	city label
            if (self.cityLabel.superview) {
                [self.cityLabel removeFromSuperview];
            }
            UILabel* cl = [[UILabel alloc] initWithFrame:vsr(0, 0, 280, cell.size.height)];
            self.cityLabel = cl;
            [cl release];
            self.cityLabel.backgroundColor = [UIColor clearColor];
            self.cityLabel.text = CurrentCityName;
            self.cityLabel.font = FontWithSize(12);
            self.cityLabel.textAlignment = UITextAlignmentRight;
            
            [cell addSubview:self.cityLabel];
            
        } else if (1 == section && 0 == row) {
            //	history browse num
            cell.textLabel.text = [NSString stringWithFormat:@"%@(%d)", cell.textLabel.text, historyCount];
        }
    }
	
	return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[table deselectRowAtIndexPath:indexPath animated:YES];
	if (0 == indexPath.section && 0 == indexPath.row) {
		[self switchCity:self];
	} else if (1 == indexPath.section && 0 == indexPath.row) {
		UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回"
																		   style:UIBarButtonItemStylePlain
																		  target:nil
																		  action:nil];
		self.navigationItem.backBarButtonItem = backButtonItem;
		[backButtonItem release];

		UIViewController* historyVC = [[BrowseHistoryViewController alloc] init];
		historyVC.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:historyVC animated:YES];
		[historyVC release];
	} else if (1 == indexPath.section && 1 == indexPath.row) {
		UIViewController* introVC = [[IntroViewController alloc] init];
		introVC.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:introVC animated:YES];
		[introVC release];
	} else if (1 == indexPath.section && 2 == indexPath.row) {
		UIViewController* suggVC = [[FeedbackViewController alloc] init];
		suggVC.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:suggVC animated:YES];
		[suggVC release];
	} else if (1 == indexPath.section && 3 == indexPath.row) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:kAppStorePLURL]];
    } else if (1 == indexPath.section && 4 == indexPath.row) {
        UIViewController* aboutVC = [[AboutViewController alloc] init];
		aboutVC.hidesBottomBarWhenPushed = YES;
		[self.navigationController pushViewController:aboutVC animated:YES];
		[aboutVC release];
	} else if (1 == indexPath.section && 5 == indexPath.row) {
        if (![LoginController sharedInstance].isWeiboBind) {
            [[WeiboBindController sharedInstance] showBindView];
        }
    }
}

#pragma mark -
#pragma mark picker controller protocal implementation

- (void) pickerController:(id)controller pickData:(id)data
{
	Area *c = (Area*)data;
	[CacheCenter sharedInstance].currentCity = c;
	[controller dismissModalViewControllerAnimated:YES];
	_cityLabel.text = CurrentCityName;
}

- (void) pickerControllerCancelled:(id)controller
{
	[controller dismissModalViewControllerAnimated:YES];	
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	DLog(@"request failed");
	Release(request);
}

- (void)requestSucceeded:(HttpRequest*)req {
	
	NSError *error = nil;
    [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
	Release(request);
    LoginController *lc = [LoginController sharedInstance];
	lc.isWeiboSync = isSync;
}

@end
