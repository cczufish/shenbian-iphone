    //
//  SignupViewController.m
//  shenbian
//
//  Created by Leeyan on 11-5-18.
//  Copyright 2011 百度. All rights reserved.
//

#import "SignupController.h"
#import "SBTextFieldSubtitleCell.h"
#import "LoginController.h"
#import "SBTriggleButton.h"
#import "SBApiEngine.h"
#import "CacheCenter.h"
#import "SBNavigationController.h"
#import "AlertCenter.h"
#import "Notifications.h"
#import "ErrorCenter.h"
@interface SignupController(Private)

- (void)dismissKeyboard;
- (void)presentKeyboard;
- (void)validateSignupButton;
- (void)termButtonDidChecked;
- (void)signupButtonDidPressed;
- (void)signupFailed:(NSError *)error;

- (BOOL)shouldSubmit;
@end


@implementation SignupController

static SignupController *instance = nil;

@synthesize delegate;
@synthesize username, password, confirmPassword, nickname, bdVerify, bdStoken, bduss, verifyCode;
@synthesize loginCtrl, signupButton, toggleTermButton;
@synthesize scGender;
@synthesize termView = m_termView;

+ (SignupController *)sharedInstance {
	@synchronized([SignupController class]) {
		if (!instance) {
			instance = [[SignupController alloc] init];
		}
	}
	return instance;
}

- (void) dealloc {
	VSSafeRelease(loginCtrl);
	
	VSSafeRelease(scGender);
	
	VSSafeRelease(username);
	VSSafeRelease(password);
	VSSafeRelease(nickname);
	VSSafeRelease(bdVerify);
	VSSafeRelease(bdStoken);
	VSSafeRelease(bduss);
	VSSafeRelease(tableView);
	VSSafeRelease(toggleTermButton);
	VSSafeRelease(signupButton);
	
	[super dealloc];
}

- (id) init {
    self = [super init];
    if (self) {
        signupView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 460)];
        
        UIImageView *bg = [[UIImageView alloc] initWithImage:PNGImage(@"bg")];
        bg.frame = CGRectMake(0, -64, 320, 524);
        UIImageView *topBar = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_bg")];
        topBar.userInteractionEnabled = YES;
        topBar.frame = CGRectMake(0, 0, 320, 44);
//        UIImageView *juchi = [[UIImageView alloc] initWithImage:PNGImage(@"searchbar_sawtooth")];
//        juchi.frame = CGRectMake(0, 44, 320, 6);
        
        UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancelBtn setFrame:CGRectMake(10, 7, 51, 30)];
        UIImage *img0 = [PNGImage(@"button_navigation_normal_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        UIImage *img1 = [PNGImage(@"button_navigation_normal_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
        [cancelBtn setBackgroundImage:img0 forState:UIControlStateNormal];
        [cancelBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancelBtn.titleLabel.font = FontWithSize(13);
        [cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [cancelBtn addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
        [topBar addSubview:cancelBtn];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 120, 30)];
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.font = FontWithSize(20);
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.shadowOffset = CGSizeMake(0, -1);
        titleLabel.shadowColor = [UIColor blackColor];
        titleLabel.text = @"注册";
        [topBar addSubview:titleLabel];
        [titleLabel release];
        
        tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 46, 320, 416) style:UITableViewStyleGrouped];
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
//        tableView.scrollEnabled = NO;
        
        UIButton *hiddenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        hiddenBtn.frame = CGRectMake(0, 110, 320, 300);
//		hiddenBtn.backgroundColor = [UIColor redColor];
        [hiddenBtn addTarget:self action:@selector(dismissKeyboard) forControlEvents:UIControlEventTouchUpInside];
        tableView.tableFooterView = hiddenBtn;

		//	term toggle button
		SBTriggleButton *termToggleButton = [[SBTriggleButton alloc] initWithFrame:vsr(20, 2, 17, 17)];
		[termToggleButton setImage:PNGImage(@"term_unread") forStateTriggled:NO];
		[termToggleButton setImage:PNGImage(@"term_read") forStateTriggled:YES];
		[termToggleButton addTarget:self action:@selector(termButtonDidChecked)];
		self.toggleTermButton = termToggleButton;
		self.toggleTermButton.isTriggled = YES;
		
		[hiddenBtn addSubview:termToggleButton];
		[termToggleButton release];
		
		//	term
		UILabel *termLabel = [[UILabel alloc] initWithFrame:vsr(40, 0, 92, 20)];
		termLabel.backgroundColor = [UIColor clearColor];
		termLabel.font = FontWithSize(13);
		termLabel.text = @"我已阅读并同意";
		[hiddenBtn addSubview:termLabel];
		
		[termLabel release];
		
		//	term
		UIButton *termButton = [UIButton buttonWithType:UIButtonTypeCustom];
		termButton.frame = vsr(termLabel.origin.x + termLabel.size.width, 0, 60, 20);
		termButton.titleLabel.font = termLabel.font;
		termButton.titleLabel.textAlignment = UITextAlignmentLeft;
		[termButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
		[termButton setTitle:@"用户协议" forState:UIControlStateNormal];
		[termButton addTarget:self
					   action:@selector(showTerm)
			 forControlEvents:UIControlEventTouchUpInside];
		[hiddenBtn addSubview:termButton];
		
		//	signup button
		UIButton *_signupButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
		self.signupButton = _signupButton;
		signupButton.frame = vsr(60, 40, 200, 33);
		[signupButton setTitleShadowColor:[UIColor darkGrayColor] 
								 forState:UIControlStateDisabled];
		[signupButton setTitleShadowColor:[UIColor blueColor] 
								 forState:UIControlStateNormal];
		[signupButton setBackgroundImage:PNGImage(@"signup_normal") 
								forState:UIControlStateNormal];
		[signupButton setBackgroundImage:PNGImage(@"signup_pressed") 
								forState:UIControlStateHighlighted];
		[signupButton setBackgroundImage:PNGImage(@"signup_disabled") 
								forState:UIControlStateDisabled];
		[signupButton setBackgroundColor:[UIColor clearColor]];
		signupButton.titleLabel.textAlignment = UITextAlignmentCenter;
		[signupButton addTarget:self action:@selector(signupButtonDidPressed) 
			   forControlEvents:UIControlEventTouchUpInside];
		[hiddenBtn addSubview:signupButton];

		UIImageView * navShadow = [[UIImageView alloc] initWithFrame:vsr(0, 44, 320, 5)];
		navShadow.image = PNGImage(@"navigationbar_shadow");
		
        [signupView addSubview:bg];
        [signupView addSubview:topBar];
        [signupView addSubview:tableView]; 
        [signupView addSubview:navShadow];
		
		[navShadow release];
        [topBar release];
        [bg release];
		
		self.username = @"";
		self.password = @"";
		self.nickname = @"";
		
		[self validateSignupButton];
    }
    return self;
}

- (void)showTerm {
	UIView *termView = [[UIView alloc] initWithFrame:vsr(0, 0, 320, 460)];
	
	UIImageView *topBar = [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_bg")];
	topBar.userInteractionEnabled = YES;
	topBar.frame = CGRectMake(0, 0, 320, 44);
	[termView addSubview:topBar];
	
	UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cancelBtn setFrame:CGRectMake(10, 7, 51, 30)];
	UIImage *img0 = [PNGImage(@"button_navigation_normal_0") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	UIImage *img1 = [PNGImage(@"button_navigation_normal_1") stretchableImageWithLeftCapWidth:20 topCapHeight:0];
	[cancelBtn setBackgroundImage:img0 forState:UIControlStateNormal];
	[cancelBtn setBackgroundImage:img1 forState:UIControlStateHighlighted];
	[cancelBtn setTitle:@"返回" forState:UIControlStateNormal];
	cancelBtn.titleLabel.font = FontWithSize(13);
	[cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	[cancelBtn addTarget:self action:@selector(termDoBack) forControlEvents:UIControlEventTouchUpInside];
	[topBar addSubview:cancelBtn];

	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 7, 120, 30)];
	titleLabel.backgroundColor = [UIColor clearColor];
	titleLabel.font = FontWithSize(20);
	titleLabel.textColor = [UIColor whiteColor];
	titleLabel.textAlignment = UITextAlignmentCenter;
	titleLabel.shadowOffset = CGSizeMake(0, -1);
	titleLabel.shadowColor = [UIColor blackColor];
	titleLabel.text = @"用户协议";
	[topBar addSubview:titleLabel];
	[topBar release];
	[titleLabel release];

	UIWebView *webView = [[UIWebView alloc] initWithFrame:vsr(0, 44, 320, 416)];
	NSURL *url = [[NSURL alloc] initFileURLWithPath:[[NSBundle mainBundle] pathForResource:@"term" ofType:@"html"]];
	[webView loadRequest:[NSURLRequest requestWithURL:url]];
	[termView addSubview:webView];
    [url release];
	[webView release];
	
    [[[UIApplication sharedApplication] keyWindow] addSubview:termView];
    termView.top = 480;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    termView.top = 20;
    [UIView commitAnimations];

	self.termView = termView;
	[termView release];
}

- (void)termDoBack {
	[UIView beginAnimations:@"" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
//	[UIView setAnimationDidStopSelector:@selector(hideSignupViewAnimationStop)];
	self.termView.top = 480;
	[UIView commitAnimations];
}

- (BOOL)shouldSubmit {
	if ([password isEqualToString:confirmPassword]) {
		return YES;
	}
	Alert(@"密码不一致", @"两次输入的密码不一致，请重新输入");
	return NO;
}

- (void) signupButtonDidPressed {
	if (![self shouldSubmit]) {
		return;
	}
    //客户端 输入内容长度简单验证 
    if (username.length>14) {
        TKAlert(@"用户名长度过长");
        return;
    }
    if (password.length>14||password.length<6) {
        TKAlert(@"密码长度为6－14位");
        return;
    }
    if (nickname.length<2&&nickname.length>8) {
        TKAlert(@"长度2-8位（汉字，字母或数字）");
        return;
    }
	// http://123.125.69.198:8040/passport/?login
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:NUM(LoginRequest)];
	
    NSString *pwd = [Utility stringEncodedWithBase64:password]; // password encoded with Base64
	NSMutableDictionary *param = [NSMutableDictionary dictionary];
	[param setObject:username forKey:@"username"];
	[param setObject:pwd forKey:@"password"];
	[param setObject:NUM(gender) forKey:@"sex"];
	[param setObject:NUM(1) forKey:@"crypttype"];
	[param setObject:NUM(0) forKey:@"isphone"];
    [param setObject:NUM(2) forKey:@"login_type"];
    [param setObject:TPL forKey:@"tpl"];
    [param setObject:NUM(1) forKey:@"appid"];
	
    // Begin:计算sig
    NSArray *keys = [param allKeys];
    NSArray *sortedKeys = [keys sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
    NSMutableString *strQuery = [NSMutableString string];
    for (NSString *key in sortedKeys) {
        NSString *value = [param objectForKey:key];
        [strQuery appendFormat:@"%@=%@&", key, value];
    }
    [strQuery appendFormat:@"sign_key=%@", SIGN_KEY];
	NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *sig = [Utility stringEncodedWithMD5:strQuery withEncoding:enc];
    // End:计算sig
    
    [param setObject:sig forKey:@"sig"];
    
//	NSString *url = [verifyCode length] > 0 ? LOGIN_URL_CHECKCODE : LOGIN_URL;
	NSString *url = SIGNUP_URL;
    request.postEncoding = enc;
	[request requestPOST:url parameters:param];
}

#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestSucceeded:(HttpRequest*)req {	
	NSError* error = nil;
	NSDictionary* dict = [SBApiEngine parseHttpData:req.recievedData error:&error ifSystemRequest:NO];
	if (error) {
		[self signupFailed:error];
		return;
	}
	
	//	step 1 : save bduss
	[[CacheCenter sharedInstance] recordBDUSS:[dict objectForKey:@"bduss"]];
	//	step 2 : save username
	[[CacheCenter sharedInstance] recordUsername:username];
    //  step 3 : active new user
	[[LoginController sharedInstance] activeWithNickname:nickname];
	
	NSString *session = [NSString stringWithFormat:@"register_click?errcode=%d&suc=1", [error code]];
	Stat(session);

    [Notifier postNotificationName:kSignupSucceeded object:nil];
    
	Release(request);
    
    [self hideSignupView];
}

- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
	NSString *session = [NSString stringWithFormat:@"register_click?errcode=%d&suc=0", [error code]];
	Stat(session);

    Release(request);
}

- (void)signupFailed:(NSError*)error {
	NSString *session = [NSString stringWithFormat:@"register_click?errcode=%d&suc=0", [error code]];
	Stat(session);

//	NSString* errorMessage = nil;
//	
//	switch (error.code) {
//		case kUsernameNeed:
//			errorMessage = @"请填写用户名";
//			break;
//		case kUsernameTooLong:
//			errorMessage = @"用户名最长不得超过7个汉字，或14个字节(数字，字母和下划线)";
//			break;
//		case kUsernameIllegal:
//			errorMessage = @"用户名仅可使用汉字、数字、字母和下划线";
//			break;
//		case kUsernameFormatIllegal:
//			errorMessage = @"注册数据格式错误";
//			break;
//		case kUsernameAlreadyUsed:
//			errorMessage = @"此用户名已被注册，请另换一个";
//			break;
//		case kUsernameCantBeUsed:
//			errorMessage = @"此用户名不可使用";
//			break;
//		case kUnknownError:
//			errorMessage = @"注册时发生未知错误";
//			break;
//		case kPasswordNeeded:
//			errorMessage = @"请填写密码";
//			break;
//		case kPasswordLengthError:
//			errorMessage = @"密码最少6个字符，最长不得超过14个字符";
//			break;
//		case kPasswordIllegal:
//			errorMessage = @"密码仅可由数字，字母和下划线组成";
//			break;
//		case kPasswordTooSimple:
//			errorMessage = @"密码太简单了，建议使用数字、字母、下划线的组合";
//			break;
//		case kVerifyCodeNeeded:
////			errorMessage = @"请输入验证码";
//            // TODO:增加验证码
//            errorMessage = @"注册次数过多,请休息下再试";
//			break;
//		case kVerifyCodeFormatIllegal:
//			errorMessage = @"验证码格式错误";
//			break;
//		case kVerifyCodeWrong:
//			errorMessage = @"验证码错误";
//			break;
//		case kAutoLoginError:
//			errorMessage = @"自动登录错误";
//			break;
//		default:
//			errorMessage = [NSString stringWithFormat:@"未知错误，Code:%d", error.code];
//			break;
//	}
//	
//	Alert(@"注册失败", errorMessage);
    [ErrorCenter showErrorInfo:error.code errorType:ErrorTypeSignUp];
}

- (void) termButtonDidChecked {
	[self validateSignupButton];
}

// Add by MagicYang
- (void)showSignupViewWithNickname:(NSString *)name
{
    for (UITableViewCell *cell in [tableView visibleCells]) {
        if ([cell isKindOfClass:[SBTextFieldSubtitleCell class]]) {
            SBTextFieldSubtitleCell *sbCell = (SBTextFieldSubtitleCell *)cell;
            if (sbCell.textField.tag == kSignupFieldTagUsername) {
//                sbCell.textField.text = name;
				self.username = name;
            } else if (sbCell.textField.tag == kSignupFieldTagNickname) {
                // 昵称限制8个字
                NSString *nn = [name length] > 8 ? [name substringToIndex:8] : name;
//                sbCell.textField.text = nn;
				self.nickname = nn;
            }
        }
    }
    [self showSignupView];
}
// Add End

- (void) showSignupView {
	Stat(@"register_into");
	[[[UIApplication sharedApplication] keyWindow] addSubview:signupView];
    signupView.top = 480;
    [UIView beginAnimations:@"" context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.3];
    signupView.top = 20;
    [UIView commitAnimations];
	
	self.loginCtrl = [LoginController sharedInstance];
	
//	self.username = @"";
//	self.password = @"";
//	self.nickname = @"";

	[tableView reloadData];
}

- (void) hideSignupView {
	[UIView beginAnimations:@"" context:NULL];
	[UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
	[UIView setAnimationDuration:0.3];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideSignupViewAnimationStop)];
	signupView.top = 480;
	[UIView commitAnimations];
	
	self.username = nil;
	self.password = nil;
    self.confirmPassword = nil;
	self.nickname = nil;
}

- (void)hideSignupViewAnimationStop {
    [signupView removeFromSuperview];
}

- (void)cancel:(id)sender {
	[self hideSignupView];
	if (loginCtrl)
	{
		[loginCtrl showLoginView];
	}
}

- (void)dismissKeyboard {
	SBTextFieldSubtitleCell *cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell.textField resignFirstResponder];
	cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	[cell.textField resignFirstResponder];
	cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	[cell.textField resignFirstResponder];
	cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]];
	[cell.textField resignFirstResponder];
}

- (void)presentKeyboard {
    SBTextFieldSubtitleCell *cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	[cell.textField becomeFirstResponder];
}


#pragma mark -
#pragma mark text field delegate implementation
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	SBTextFieldSubtitleCell *cell = nil;
	
	switch (textField.tag) {
		case kSignupFieldTagUsername:
			cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
			[cell.textField becomeFirstResponder];
			break;
		case kSignupFieldTagPassword:
			cell = (SBTextFieldSubtitleCell *)[tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
			[cell.textField becomeFirstResponder];
			break;
		case kSignupFieldTagConfirmPassword:
			break;
		case kSignupFieldTagNickname:
			break;
		default:
			break;
	}
	
	return NO;
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	switch (section) {
		case 0:
			return 4;
			break;
		case 1:
			return 1;
			break;
		default:
			break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"Cell%d%d", indexPath.section, indexPath.row];
    SBTextFieldSubtitleCell *cell = (SBTextFieldSubtitleCell *)[table dequeueReusableCellWithIdentifier:identifier];
	if (nil == cell) {
		cell = [[[SBTextFieldSubtitleCell alloc] initWithDelegate:self reuseIdentifier:identifier] autorelease];
		cell.label.font = FontWithSize(16);
		cell.textField.font = FontWithSize(16);
		cell.textField.textColor = [UIColor colorWithRed:0.282 green:0.38 blue:0.565 alpha:1];
		cell.textField.delegate = self;
		cell.textField.enablesReturnKeyAutomatically = YES;
		cell.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
	}
	if (0 == indexPath.section) {
		switch (indexPath.row) {
			case 0: {
				cell.label.text = @"用户名";
				cell.textField.returnKeyType = UIReturnKeyNext;
				cell.textField.tag = kSignupFieldTagUsername;
				cell.subtitle = @"不超过7个汉字或14个字节（数字、字母和下划线）";
				cell.textField.text = self.username;
			} break;
			case 1: {
				cell.label.text = @"密 码";
				cell.subtitle = @"长度6-14位，字母区分大小写";
				cell.textField.returnKeyType = UIReturnKeyNext;
				cell.textField.secureTextEntry = YES;
				cell.textField.tag = kSignupFieldTagPassword;
				cell.textField.text = self.password;
			} break;
			case 2: {
				cell.label.text = @"确认密码";
				cell.textField.returnKeyType = UIReturnKeyDone;
				cell.textField.secureTextEntry = YES;
				cell.textField.delegate = self;
				cell.textField.tag = kSignupFieldTagConfirmPassword;
				cell.textField.text = self.confirmPassword;
			} break;
			case 3: {
				cell.label.text = @"性别";
				[cell.textField removeFromSuperview];
				
				// gender
				UISegmentedControl* genderSeg = nil;
				genderSeg = [[UISegmentedControl alloc] 
							 initWithItems:[NSArray arrayWithObjects:@"男", @"女", nil]];
				genderSeg.frame = vsr(100, 8, 120, 30);
				genderSeg.selectedSegmentIndex = 1;
				genderSeg.tag = kSignupFieldTagGender;
				[genderSeg addTarget:self action:@selector(genderSegDidChanged:)
					forControlEvents:UIControlEventValueChanged];
				[cell.contentView addSubview:genderSeg];
				
				gender = genderSeg.selectedSegmentIndex + 1;
				
				[genderSeg release];
				
			} break;
		}
	} else if (1 == indexPath.section) {
		switch (indexPath.row) {
			case 0:
				cell.label.text = @"身边昵称";
				cell.textField.returnKeyType = UIReturnKeyDone;
				cell.textField.delegate = self;
				//			cell.textField.clearButtonMode = UITextFieldViewModeNever;
				cell.textField.tag = kSignupFieldTagNickname;
				cell.subtitle = @"长度2-8位（汉字，字母或数字）";
				cell.textField.text = self.nickname;
				break;
			default:
				break;
		}
	}
	
    return cell;
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	[self dismissKeyboard];
}

- (CGFloat)tableView:(UITableView*)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath {
	return 60.0f;
}

- (void)searchTextChanged:(UITextField *)textField {
	switch (textField.tag) {
		case kSignupFieldTagUsername:
			self.username = textField.text;
			break;
		case kSignupFieldTagPassword:
			self.password = textField.text;
			break;
		case kSignupFieldTagConfirmPassword:
			self.confirmPassword = textField.text;
			break;
		case kSignupFieldTagNickname:
			self.nickname = textField.text;
			break;
		default:
			break;
	}
	
	[self validateSignupButton];
}

- (void)validateSignupButton {
	BOOL isButtonEnabled = YES;
	if ([username isEmpty] || [password isEmpty] || [nickname isEmpty]) {
		isButtonEnabled = NO;
	}

	if (!toggleTermButton.isTriggled) {
		isButtonEnabled = NO;
	}
	
	self.signupButton.enabled = isButtonEnabled;
}

- (void)genderSegDidChanged:(id)sender {
	gender = ((UISegmentedControl*)sender).selectedSegmentIndex + 1;
}

@end
