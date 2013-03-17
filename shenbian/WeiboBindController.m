//
//  WeiboBindController.m
//  shenbian
//
//  Created by MagicYang on 6/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "WeiboBindController.h"
#import "TouchXML.h"
#import "SBApiEngine.h"
#import "AlertCenter.h"
#import "LoadingView.h"
#import "LoginController.h"
#import "ConfirmCenter.h"
#import "Notifications.h"
#import "CacheCenter.h"
#import "HttpRequest+Statistic.h"
#import "TKAlertCenter.h"


#define PAGE_AFTERAUTH   @"afterauth"
#define PAGE_FINISHBIND  @"finishbind"


static WeiboBindController *instance = nil;

@implementation WeiboBindController


+ (id)allocWithZone:(NSZone *)zone {
	NSAssert(instance == nil, @"Duplicate alloc a singleton class");
	return [super allocWithZone:zone];
}

+ (WeiboBindController *)sharedInstance
{
	@synchronized([WeiboBindController class]) {
		if (!instance) {
			instance = [[WeiboBindController alloc] init];
		}
	}
	return instance;
}

- (id)init
{
    self = [super init];
    if (self) {
        _bindView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
        
        UIImageView *topBar = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_bg")];
        topBar.userInteractionEnabled = YES;
        topBar.frame = CGRectMake(0, 0, 320, 44);
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(10, 7, 51, 30)];
        UIImage *img0 = [PNGImage(@"button_navigation_normal_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        UIImage *img1 = [PNGImage(@"button_navigation_normal_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        [cancelBtn setBackgroundImage:img0 forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FontWithSize(13);
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(hideBindView) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:cancelBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 120, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FontWithSize(18);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.shadowOffset = CGSizeMake(0, -1);
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.text = @"登录新浪微博";
        [topBar addSubview:titleLabel];
        [titleLabel release];
        
        [_bindView addSubview:topBar];
        [topBar release];
        
        [Notifier addObserver:self selector:@selector(hideBindView) name:kLoginCancelled object:nil];
        [Notifier addObserver:self selector:@selector(finishBind) name:kSignupSucceeded object:nil];
    }
    return self;
}

- (void)dealloc
{
    [Notifier removeObserver:self name:kLoginCancelled object:nil];
    [Notifier removeObserver:self name:kSignupSucceeded object:nil];
    Release(bdussFromWeibo);
    Release(nickName);
    Release(mkey);
    Release(_bindView);
    Release(_webView);
    Release(_loadingView);
    [super dealloc];
}

- (void)showBindView
{
	Stat(@"sinalogin_into");
    [[[UIApplication sharedApplication] keyWindow] addSubview:_bindView];
    
    _bindView.top = 480;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showBindViewAnimationStop)];
    _bindView.top = 20;
    [UIView commitAnimations];
}

- (void)hideBindView
{
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(hideBindViewAnimationStop)];
    _bindView.top = 480;
    [UIView commitAnimations];
}

- (void)showLoading {
	if (!_loadingView) {
		_loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:@"正在连接新浪微博..."];
	}
	[_bindView addSubview:_loadingView];
}

- (void)hideLoading {
	[_loadingView removeFromSuperview];
}


- (void)showBindViewAnimationStop
{
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 44, 320, 416)];
    _webView.delegate = self;
    [_bindView addSubview:_webView];
    
    // Parameters:
    // type: 1.renren 2. sina
    // tpl: App identifier, the same as login and sign up
    // memlogin: 1. 30 days cookie for bduss
    NSString *url = [NSString stringWithFormat:@"%@/startlogin?type=%d&tpl=%@&u=no&display=mobile&memlogin=1", SNSBIND_URL, 2, TPL];
//    DLog(@"url = %@", url);
    NSURLRequest *req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
    
    [self showLoading];
}

- (void)hideBindViewAnimationStop
{
    [_webView removeFromSuperview];
    Release(_webView);
    
    [_bindView removeFromSuperview];
}

- (void)finishBind
{
    NSString *url = [NSString stringWithFormat:@"%@/finishbind?mkey=%@", SNSBIND_URL, mkey];    
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSString *bduss = [SBApiEngine getBDUSSCookie];
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:
                                @".baidu.com", NSHTTPCookieDomain,
                                @"/",          NSHTTPCookiePath,
                                @"BDUSS",      NSHTTPCookieName,
                                bduss,         NSHTTPCookieValue, nil];
    NSHTTPCookie* cookie = [NSHTTPCookie cookieWithProperties:properties];
    NSArray *cookies = [NSArray arrayWithObject:cookie];
    NSURL *theURL    = [NSURL URLWithString:url];
    NSURL *mainURL   = [NSURL URLWithString:SNSBIND_URL];
    [cookieStorage setCookies:cookies forURL:theURL mainDocumentURL:mainURL];
    NSURLRequest *req = [NSURLRequest requestWithURL:theURL];
    [_webView loadRequest:req];
}

- (void)checkActivityFinished
{
    LoginController *lc = [LoginController sharedInstance];
    if (!lc.isActived) {
        [[ConfirmCenter sharedInstance] confirmAction:@selector(activeAccount)
                                            forObject:self
                                       withPromptText:@"您的微博已与百度帐号绑定，是否激活该帐号为身边用户?"];
    } else {
        [Notifier postNotificationName:kLoginSucceeded object:nil];
        [self hideBindView];
    }
}

- (void)activeAccount
{
    [[LoginController sharedInstance] activeWithNickname:nickName];
}

- (void)followMe
{
    NSString *url = [NSString stringWithFormat:@"%@/follow", ROOT_URL];
    HttpRequest *request = [[[HttpRequest alloc] initWithDelegate:self andExtraData:nil] autorelease];
    NSDictionary *param = [NSDictionary dictionaryWithObject:NUM(2) forKey:@"plat"];
    [request requestPOST:url parameters:param useStat:YES];
}

- (void)doWeiboLogin
{
    [[CacheCenter sharedInstance] recordBDUSS:bdussFromWeibo];
    [[LoginController sharedInstance] isActiveRequest];
}

- (void)parseAfterAuth:(CXMLDocument *)doc
{
    LoginController *lc = [LoginController sharedInstance];
    lc.delegate = self;
    lc.authSuccessSEL = @selector(finishBind);
    lc.checkActivityFinishedSEL = @selector(checkActivityFinished);
    
    CXMLNode *isBindNode = [doc nodeForXPath:@"//client/data/is_binded" error:NULL];
    CXMLNode *nameNode = [doc nodeForXPath:@"//client/data/os_username" error:NULL];
    
    Release(nickName);
    nickName = [nameNode stringValue] ? [[nameNode stringValue] retain] : @"";
    
    if ([[isBindNode stringValue] intValue] == 1) {
        // 已绑定
        CXMLNode *bdussNode = [doc nodeForXPath:@"//client/data/bduss" error:NULL];
        Release(bdussFromWeibo);
        bdussFromWeibo = [[bdussNode stringValue] retain];
        
        if ([lc isLogin]) { // 如果已登录，需要提示是否切换帐号
            NSString *msg = [NSString stringWithFormat:@"您的微博\"%@\"已经绑定了另一个百度账号，是否切换到该帐号?", nickName];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:msg
                                                           delegate:self
                                                  cancelButtonTitle:@"取消"
                                                  otherButtonTitles:@"切换", nil];
            [alert show];
            [alert release];
        } else {
            [self doWeiboLogin];
        }
    } else {
        // 未绑定
        CXMLNode *mkeyNode = [doc nodeForXPath:@"//client/data/mkey" error:NULL];
        Release(mkey);
        mkey = [[mkeyNode stringValue] retain];
        
        CXMLNode *linkNode = [doc nodeForXPath:@"//client/data/os_headurl" error:NULL];
        NSString *link = [linkNode stringValue] ? [linkNode stringValue] : @"";
        
        if ([SBApiEngine getBDUSSCookie]) { // 已登录
            [self finishBind];
        } else {                            // 未登录 (显示登录界面，如果未激活自动激活)
            lc.isJustAuth = YES;
            [lc showBindViewWithNickname:nickName andImageLink:link];
        }
    }
}

- (void)parseFinishBind:(CXMLDocument *)doc
{
    CXMLNode *errnoNode = [doc nodeForXPath:@"//client/data/err_no" error:NULL];
    NSInteger errNo = [[errnoNode stringValue] intValue];
    NSString *errMsg = [NSString stringWithFormat:@"未知错误, Code=%d", errNo];
    switch (errNo) {
        case 0: {
            [LoginController sharedInstance].isWeiboBind = YES;
            [Notifier postNotificationName:kWeiboBindSucceed object:nil];
            [self followMe];
            [[LoginController sharedInstance] isActiveRequest];
            [self hideBindView];
        } break;
        case 10:Alert(@"绑定失败", @"系统错误");break;
        case 11:Alert(@"绑定失败", @"您的帐号已经绑定");break;
        default:Alert(@"绑定失败", errMsg);break;
    }
    [[LoginController sharedInstance] hideLoginView];
}


#pragma mark -
#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _webView.userInteractionEnabled = NO;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    _webView.userInteractionEnabled = YES;
    
    NSString *html = [webView stringByEvaluatingJavaScriptFromString:@"document.body.innerHTML"];
    
    if ([html length] == 0) { // Passport接口偶尔抽风,给个提示,加个保护
        TKAlert(@"服务器返回数据错误");
        return;
    }
    
//    DLog(@"html = %@\n\n\n=================================================================\n", html);
    NSError *error = nil;
    CXMLDocument *doc = [[CXMLDocument alloc] initWithXMLString:html options:1 error:&error];
    if (error) {
        DLog(@"%@", error);
    } else {
        CXMLNode *pageNode = [doc nodeForXPath:@"//client/page" error:&error];
        NSString *page = [pageNode stringValue];
        if ([page isEqualToString:PAGE_AFTERAUTH]) {
            [self parseAfterAuth:doc];
        } else if ([page isEqualToString:PAGE_FINISHBIND]) {
            [self parseFinishBind:doc];
        } else {
            assert("Bind process error!!!");
        }
    }
    [doc release];
    
    [self hideLoading];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _webView.userInteractionEnabled = YES;
    Alert(@"无法载入网页", [error description]);
    
    [self hideLoading];
}


#pragma mark - 
#pragma UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.cancelButtonIndex == buttonIndex) {
        [self hideBindView];
    } else {
        [self doWeiboLogin];
    }
}

@end
