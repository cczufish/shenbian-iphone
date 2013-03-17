//
//  SignupViewController.h
//  shenbian
//
//  Created by Leeyan on 11-5-18.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HttpRequest+Statistic.h"
#import "Utility.h"
#import "VSTextFieldCell.h"
#import "SBJsonParser.h"
#import "SBPopupTextField.h"
#import "Notifications.h"
#import "UIAdditions.h"
#import "TKAlertCenter.h"
@class HttpRequest;
@class LoginController;
@class SBTriggleButton;

enum {
	kSignupFieldTagUsername = 1,
	kSignupFieldTagPassword = 2,
	kSignupFieldTagConfirmPassword = 3,
	kSignupFieldTagNickname = 4,
	kSignupFieldTagGender = 5
	
};

enum {
	kSuccess = 0,
	kUsernameNeed = 10,
	kUsernameTooLong = 11,
	kUsernameIllegal = 12,
	kUsernameFormatIllegal = 13,
	kUsernameAlreadyUsed = 14,
	kUsernameCantBeUsed = 15,
	kUnknownError = 16,
	
	kPasswordNeeded = 20,
	kPasswordLengthError = 21,
	kPasswordIllegal = 23,
	kPasswordTooSimple = 24,
	
	kVerifyCodeNeeded = 40,
	kVerifyCodeFormatIllegal = 41,
	kVerifyCodeWrong = 42,
	
	kAutoLoginError = 46
};

@interface SignupController : NSObject
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>
{
    UIView *signupView;
    UITableView *tableView;
    
	id delegate;
	HttpRequest *request, *activeRequest;
	
	NSString *username, *password, *confirmPassword, *nickname, *verifyCode;
	NSString *bdVerify, *bdStoken, *bdTime;
	
	UISegmentedControl *scGender;
	
	short unsigned int gender;
	
	NSString *bduss;
	
	BOOL isLogin;
    
    NSDate *_loginTime;     // 登录时间 (用于SSID超时重新登录)
	UIButton *signupButton;
	SBTriggleButton *toggleTermButton;
	
	LoginController* loginCtrl;
	
	UIView *m_termView;
}

@property(nonatomic, assign) id delegate;
@property(nonatomic, retain) NSString *username;
@property(nonatomic, retain) NSString *password;
@property(nonatomic, retain) NSString *confirmPassword;
@property(nonatomic, retain) NSString *nickname;
@property(nonatomic, retain) NSString *bdVerify;
@property(nonatomic, retain) NSString *bdStoken;
@property(nonatomic, retain) NSString *verifyCode;
@property(nonatomic, retain) NSString *bduss;
@property(nonatomic, retain) LoginController* loginCtrl;
@property(nonatomic, retain) SBTriggleButton *toggleTermButton;
@property(nonatomic, retain) UIButton *signupButton;
@property(nonatomic, retain) UISegmentedControl *scGender;
@property(nonatomic, retain) UIView *termView;

+ (SignupController *)sharedInstance;
- (void)showSignupViewWithNickname:(NSString *)name;
- (void)showSignupView;
- (void)hideSignupView;
- (void)showTerm;

@end
