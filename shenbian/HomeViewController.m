//
//  HomeViewController.m
//  shenbian
//
//  Created by MagicYang on 4/7/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "ShopVisitedViewController.h"
#import "HttpRequest+Statistic.h"
#import "LoginController.h"
#import "Utility.h"
#import "WeiboBindController.h"
#import "VSTabBarController.h"
#import "Notifications.h"
#import "SBApiEngine.h"
#import "UserPhotoListVC.h"
#import "BadgeListVC.h"
#import "CacheCenter.h"
#import "ConfirmCenter.h"
#import "LocationService.h"
#import "SBUser.h"
#import "AppDelegate.h"
#import "AttentionListVC.h"
#import "TKAlertCenter.h"
#import "UIAdditions.h"


@interface HomeViewController ()

- (void)reportNeedsDisplay:(NSDictionary *)report;

@end





@implementation HomeViewController

@synthesize isMainAccount;

- (id)initWithUserID:(NSString *)uid
{
    self = [super init];
    if (self) {
        
        user = [SBUser new];
        user.uid = uid;
        [user addObserver:self forKeyPath:@"img" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
        [Notifier addObserver:self selector:@selector(getProfile) name:kLoginSucceeded object:nil];
        [Notifier addObserver:self selector:@selector(cleanProfile) name:kLogoutSucceeded object:nil];
    }
    return self;
}



- (void)dealloc
{
    CancelRequest(request);
    CancelRequest(removeBindRequest);
	CancelRequest(reportRequest);
    [Notifier removeObserver:self name:kLoginSucceeded object:nil];
    [Notifier removeObserver:self name:kLogoutSucceeded object:nil];
    [user removeObserver:self forKeyPath:@"img"];
    [user release];
    [loginView release];
    [titleTabView release];
    [nameView release];
    [mammonView release];
    [photoView release];
    [levelView release];
    [mammonIcon release];
    
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    Release(nameView);
    Release(mammonView);
    Release(photoView);
    Release(levelView);
    Release(mammonIcon);
	Release(header);
}

- (void)viewDidLoad
{
    self.title = isMainAccount ? @"我" : @"个人中心";
    [super viewDidLoad];
    mainScollview=  [[UIScrollView alloc] initWithFrame:CGRectMake(0, 77, 320, 416-77)];
    mainScollview.contentSize = CGSizeMake(320, 220);
    tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 220) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = [UIColor clearColor];
    tableView.scrollEnabled = NO;
    
//    UIImageView *header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)];
    header = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 77)];
    header.image = PNGImage(@"home_bg_header");
    
    photoView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 52, 52)];
    CALayer * layer = [photoView layer];  
    [layer setMasksToBounds:YES];  
    [layer setCornerRadius:6.0];
//    [layer setBorderWidth:1.0];  
//    [layer setBorderColor:[[UIColor blackColor] CGColor]]; 
    
	vipIcon = [[UIImageView alloc] initWithFrame:vsr(34, 34, 18, 18)];
	vipIcon.backgroundColor = [UIColor clearColor];
	vipIcon.image = PNGImage(@"v");
	vipIcon.hidden = YES;
	
	[photoView addSubview:vipIcon];
	
    nameView = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 200, 20)];
    nameView.backgroundColor = [UIColor clearColor];
    nameView.font = FontWithSize(16);
    
    levelView = [[UIImageView alloc] initWithFrame:CGRectMake(75, 40, 52, 20)];
    
    mammonIcon = [[UIImageView alloc] initWithFrame:CGRectMake(135, 45, 18, 12)];
    mammonIcon.image =PNGImage(@"home_icon_mamon");
    mammonIcon.hidden = YES;
    
    mammonView = [[UILabel alloc] initWithFrame:CGRectMake(155, 45, 100, 15)];
    mammonView.backgroundColor = [UIColor clearColor];
    mammonView.font = FontWithSize(13);
    mammonIcon.hidden = YES;
    if ([LoginController sharedInstance].isLogin&& ![CurrentAccount.uid isEqual:user.uid]) {

        btn_following= [UIButton buttonWithType:UIButtonTypeCustom];
        btn_following.backgroundColor = [UIColor clearColor];
        [btn_following setFrame:CGRectMake(240, 10, 70, 29)];
        [btn_following setBackgroundImage:PNGImage(@"botton_follow_do") forState:UIControlStateNormal];
        [btn_following addTarget:self action:@selector(followUser) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:btn_following];
        btn_following.visible=NO;
    }
    
    header.userInteractionEnabled = YES;
    [header addSubview:photoView];
    [header addSubview:nameView];
    [header addSubview:levelView];
    [header addSubview:mammonIcon];
    [header addSubview:mammonView];
    [mainScollview addSubview:tableView];
    [self addSubview:header];
    [self addSubview:mainScollview];

    if (isMainAccount) {
        
        if (!titleTabView) {
            titleTabView = [[SBSegmentView alloc] init];
        }
        NSArray *tabArr=[[NSArray alloc] initWithObjects:@"我的主页",@"好友动态", nil];
        [titleTabView setDatasource:tabArr];
        titleTabView.delegate = self;
        UIView *tempview=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        titleTabView.frame=CGRectMake(76, titleTabView.frame.origin.y, titleTabView.frame.size.width, titleTabView.frame.size.height);
        
        [titleTabView setCellWidth:80];
        [tempview addSubview:titleTabView];
        self.navigationItem.titleView=tempview;
        titleTabView.selectedIndex = 0;
        [tempview release];
        [tabArr release];
        
    }
}
- (void)getProfile
{
    if (isMainAccount && ![CurrentAccount.uid isEqual:user.uid]) { // 帐号切换时需清理uid
        user.uid = nil;
       
    }
    
    [loginView removeFromSuperview];
    CancelRequest(request);
    
    NSString *url = nil;
    SBLocation *location = [[LocationService sharedInstance] currentLocation];
    // http://client.shenbian.com/iphone/home?u_fcrid=xxxx
    if (location) {
        url = [NSString stringWithFormat:@"%@/home?myself=%d&city_id=%d", 
               ROOT_URL, isMainAccount ? 1 : 0, location.cityId];
    } else {
        url = [NSString stringWithFormat:@"%@/home?myself=%d", ROOT_URL, isMainAccount ? 1 : 0];
    }
    
    if (user.uid) {
        url = [url stringByAppendingFormat:@"&u_fcrid=%@", user.uid];
    }
    request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [request requestGET:url useStat:YES];
}

- (void)reportNeedsDisplay:(NSDictionary *)report {
	UIView *reportView = [[UIView alloc] initWithFrame:vsr(0, 0, 320, 150)];
	reportView.backgroundColor = [UIColor clearColor];
	
	NSString *photo = [report objectForKey:@"rpt_photo"];
	NSString *comment = [report objectForKey:@"rpt_comment"];
	NSString *total = [report objectForKey:@"rpt_total"];
	NSString *ranking = [report objectForKey:@"rpt_ranking"];
	
	NSString *line1 = [NSString stringWithFormat:@"人气值：%@分（传图：%@分；评论：%@分）", total, photo, comment];
	NSString *line2 = [NSString stringWithFormat:@"当前排行：%@", [ranking intValue] > 0 ? ranking : @"未入榜"];
	
	UILabel *label1 = [[UILabel alloc] initWithFrame:vsrc(160, 75, 250, 30)];
	UILabel *label2 = [[UILabel alloc] initWithFrame:vsrc(160, 115, 250, 30)];
	
	label1.font = label2.font = FontLiteWithSize(13);
	
	label1.textColor = label2.textColor = [UIColor blackColor];
	
	label1.backgroundColor = label2.backgroundColor = [UIColor clearColor];
	
	label1.numberOfLines = 0;
	
	UIImage *bgImage = PNGImage(@"match-report");

	UIImageView *bg = [[UIImageView alloc] initWithFrame:vsrc(160, reportView.size.height / 2, 279, 130)];
	
	CGSize size = [line1 sizeWithFont:FontLiteWithSize(13) constrainedToSize:label1.frame.size
						lineBreakMode:UILineBreakModeTailTruncation];
	if (size.height > 16.0f) {
		//	2行的情况
		bgImage = [bgImage stretchableImageWithLeftCapWidth:0 topCapHeight:60.0f];
		bg.size = CGSizeMake(bg.size.width, 150);
		label1.frame = vsrc(160, 88, 250, 60);
		label2.frame = vsrc(160, 135, 250, 30);
		line1 = [NSString stringWithFormat:@"人气值：%@分\n               （传图：%@分；评论：%@分）", 
                 total, photo, comment];
		label1.text = line1;
	}
	
	label1.text = line1;
	label2.text = line2;
	
	bg.image = bgImage;
	
	[reportView addSubview:bg];
	[bg release];
	
	[reportView addSubview:label1];
	[reportView addSubview:label2];
	
	[label1 release];
	[label2 release];
	
	tableView.size = CGSizeMake(320, 400);
	tableView.tableFooterView = reportView;
    mainScollview.contentSize = CGSizeMake(320, 220+reportView.frame.size.height+50);
	
	[reportView release];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    LoginController *lc =[LoginController sharedInstance];
    if (isMainAccount && ![lc isLogin])
    {
		[[LoginController sharedInstance] showLoginView];
        return;
    }
    
    [self getProfile];
    
    [self.navigationController.navigationBar bringSubviewToFront:titleTabView];
    titleTabView.selectedIndex = 0;
}


- (void)refreshView
{
    NSString *levelImgName = [NSString stringWithFormat:@"userlevel_%d", user.level];
    levelView.image = user.uid ? PNGImage(levelImgName) : nil;
    photoView.image = user.img ? user.img : PNGImage(@"user_default");
    mammonView.hidden = user.uid ? NO : YES;
    mammonIcon.hidden = user.uid ? NO : YES;
	vipIcon.hidden = user.isVIP ? NO : YES;
    nameView.text = user.name;
    mammonView.text = [NSString stringWithFormat:@"%d", user.mammon];
    
    
    [tableView reloadData];
}

- (void)cleanProfile
{
    [user cleanProfile];
    [self refreshView];
}

- (void)weiboBind:(id)sender
{
    
}

- (void)removeBind:(id)sender
{
    [[ConfirmCenter sharedInstance] confirmAction:@selector(doRemoveBind) forObject:self withPromptText:@"您的精彩发现将无法同步到微博，确定要解除绑定吗?"];
}

- (void)doRemoveBind
{
    // http://client.shenbian.com/iphone/setSns
    NSString *url = [NSString stringWithFormat:@"%@/setSns", ROOT_URL];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            NUM(2), @"plat",    //1 人人网（本次不使用）2 新浪微博
                            NUM(0), @"type",    //0 同步设置 1 账号绑定
                            NUM(0), @"c",       //0 取消授权 1 授权 （当c=1，服务端才会读取key和token）
                            nil];
    removeBindRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
    [removeBindRequest requestPOST:url parameters:params useStat:YES];
    
    // Remove when server return value FIXED
    user.isWeiboBind = NO;
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
    return 1;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 40;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"CellIdentifier";
    
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.textLabel.font = FontLiteWithSize(16);
    }
    
    switch (indexPath.row) {
        case 0: {
            if (user.photoCount == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"照片(%d)", user.photoCount];
            cell.textLabel.textColor = user.photoCount > 0 ? [UIColor blackColor] : [UIColor grayColor];
        } break;
        case 1: {
            if (user.beenCount == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"去过的商户(%d)", user.beenCount];
            cell.textLabel.textColor = user.beenCount > 0 ? [UIColor blackColor] : [UIColor grayColor];
        } break;
        case 2: {
            if (user.badgeCount == 0) {
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                cell.accessoryType = UITableViewCellAccessoryNone;
            } else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"徽章(%d)", user.badgeCount];
            cell.textLabel.textColor = user.badgeCount > 0 ? [UIColor blackColor] : [UIColor grayColor];
        } break;
            case 3:
        {
            if (user.attentionCount==0) {
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"关注(%d)", user.attentionCount];
            cell.textLabel.textColor = user.attentionCount > 0 ? [UIColor blackColor] : [UIColor grayColor];
        
        
        }break;
        case 4:
        {
            if (user.funsCount==0) {
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                cell.accessoryType=UITableViewCellAccessoryNone;
            }
            else {
                cell.selectionStyle = UITableViewCellSelectionStyleGray;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            }
            cell.textLabel.text = [NSString stringWithFormat:@"粉丝(%d)", user.funsCount];
            cell.textLabel.textColor = user.funsCount > 0 ? [UIColor blackColor] : [UIColor grayColor];
            
            
        }break;
            default:
        {
        cell.textLabel.text=@"test";
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            if (user.photoCount == 0) {
                return;
            }
            UserPhotoListVC* vc = [[UserPhotoListVC alloc] initWithUserID:user.uid
                                                                uiconPath:user.imgUrl
                                                                    uname:user.name
                                                                    uicon:user.img];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } break;
        case 1: {
            if (user.beenCount == 0) {
                return;
            }
            ShopVisitedViewController *controller = [ShopVisitedViewController new];
            controller.hidesBottomBarWhenPushed = YES;
            controller.userId = user.uid;
            [self.navigationController pushViewController:controller animated:YES];
            [controller release];
        } break;
        case 2: {
            if (user.badgeCount == 0) {
                return;
            }
            BadgeListVC* vc = [[BadgeListVC alloc] initWithUserID:user.uid];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } break;
        case 3: {
            if (user.attentionCount == 0) {
                return;
            }
            AttentionListVC* vc = [[AttentionListVC alloc] initWithUserID:user.uid RType:1];
            
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } break;
        case 4: {
            if (user.funsCount == 0) {
                return;
            }
            AttentionListVC* vc = [[AttentionListVC alloc] initWithUserID:user.uid RType:2];
            [self.navigationController pushViewController:vc animated:YES];
            [vc release];
        } break;
    }
    [table deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"img"]) {
        photoView.image = user.img;
    }
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    if (req == request) {
        Release(request);
	} else {
        Release(removeBindRequest);
    }
}

- (void)requestSucceeded:(HttpRequest*)req {
    NSError *error = nil;

    NSDictionary* dict = [SBApiEngine parseHttpData:req.recievedData error:&error];
    if (error) {
        [self requestFailed:req error:error];
        return;
    }
    if(req==followRequest&& [[dict objectForKey:@"errno"] intValue]==0)
    {
        //now do nothting,but will dosomething
        
        if (attention==1) {
            [btn_following setBackgroundImage:PNGImage(@"botton_follow_do") forState:UIControlStateNormal];
            attention=0;
            TKAlert(@"已取消!");

        }
        else
        {
            [btn_following setBackgroundImage:PNGImage(@"botton_follow_undo") forState:UIControlStateNormal];
            attention=1;
            TKAlert(@"关注成功!");

            
        }
        
        return;
        
        
    }
 
    if (req == request) {
        user.uid        = [dict objectForKey:@"u_fcrid"];
        user.name       = [dict objectForKey:@"u_name"];
        if ([[dict objectForKey:@"u_avatar"] length] > 0) {
            user.imgUrl     = [dict objectForKey:@"u_avatar"];
        }
        user.photoCount = [[dict objectForKey:@"pic_total"] intValue];
        user.beenCount  = [[dict objectForKey:@"shop_total"] intValue];
        user.badgeCount = [[dict objectForKey:@"badge_total"] intValue];
        user.level      = [[dict objectForKey:@"grade_id"] intValue];
        user.mammon     = [[dict objectForKey:@"mammon"] intValue];
        user.isWeiboBind= [[dict objectForKey:@"sinasns"] boolValue];
		user.isVIP		= [[dict objectForKey:@"u_vip"] boolValue];
        user.attentionCount=[[dict objectForKey:@"attention_total"] intValue];
        user.funsCount=[[dict objectForKey:@"fans_total"] intValue];
        attention=[[dict objectForKey:@"attention"] intValue];
        if (![CurrentAccount.uid isEqualToString:user.uid]) {
            btn_following.visible=YES;
        
            if ([[dict objectForKey:@"attention"] intValue]) {
                
                [btn_following setBackgroundImage:PNGImage(@"botton_follow_undo") forState:UIControlStateNormal];
            }
            else
            {
                [btn_following setBackgroundImage:PNGImage(@"botton_follow_do") forState:UIControlStateNormal];
            
            }
        }
        [self refreshView];
        if (isMainAccount) {
            [CacheCenter sharedInstance].account = user;
        }
        Release(request);
		NSString *sessionString = [NSString stringWithFormat:@"home_into?u_type=%d&add_v=%d&u_fcry=%@", 
								   isMainAccount, user.isVIP, user.uid];
		Stat(sessionString);
		
		NSDictionary *matchReport = [NSDictionary dictionaryWithObjectsAndKeys:
											[dict objectForKey:@"rpt_photo"],	@"rpt_photo",
											[dict objectForKey:@"rpt_comment"],	@"rpt_comment",
											[dict objectForKey:@"rpt_total"],	@"rpt_total",
											[dict objectForKey:@"rpt_ranking"],	@"rpt_ranking",
					   nil];
		
		if (nil != [matchReport objectForKey:@"rpt_photo"]
			&& nil != [matchReport objectForKey:@"rpt_comment"]
			&& nil != [matchReport objectForKey:@"rpt_total"]
			&& nil != [matchReport objectForKey:@"rpt_ranking"]
			) {
			[self reportNeedsDisplay:matchReport];
		}
	} 
    else {
        user.isWeiboBind = NO;
        Release(removeBindRequest);
    }
}
-(void)followUser
{
    if ([LoginController sharedInstance].isLogin) {
        NSString *rTypeStr=@"addAttention";
        if (attention) {
            rTypeStr=@"delAttention";
        }
        NSString *url = [NSString stringWithFormat:@"%@/%@",
                         ROOT_URL ,rTypeStr];
        followRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
        NSDictionary* params = [NSDictionary dictionaryWithObjectsAndKeys:user.uid,
                                @"u_fcrid", nil];
        
        [followRequest requestPOST:url parameters:params useStat:YES];
    }
  
    
    



}
//add title bar delegate
- (void)segment:(VSSegmentView*)segment clickedAtIndex:(int)index onCurrentCell:(BOOL)isCurrent{

    if (!isCurrent) {
        if (index==0) {
            //在push页面中又重新添加了titleview 调用自己的title bar delegate 固这里不作任何操作
        }
        else if(index==1)
        {
            UserPhotoListVC* vc = [[UserPhotoListVC alloc] initWithUserID:user.uid
                                                                uiconPath:user.imgUrl
                                                                    uname:user.name
                                                                    uicon:user.img];
            vc.hidesBottomBarWhenPushed = NO;
            [vc readyHasTabbar];
            [self.navigationController pushViewController:vc animated:NO]; 
            [vc release];
        }
         titleTabView.selectedIndex=index;
	}

}
@end
