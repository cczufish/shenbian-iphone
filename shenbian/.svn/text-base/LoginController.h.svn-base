//
//  LoginController.h
//  shenbian
//
//  Created by MagicYang on 11-05-09.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


enum {
	LoginRequest       = 0,
	VerifyCodeRequest  = 1,
	CheckActiveRequest = 2,
    ActiveRequest      = 3
};

enum {
	UsernameField = 1,
	PasswordField = 2,
	VerifyField   = 3
};


@class HttpRequest;
@class SignupController;

@interface LoginController : NSObject
<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate> {
    UIView *loginView;
    UITableView *tableView;
	UITableView *loginViewTableView;	// view for loginview
	
	id delegate;
	HttpRequest *request, *checkActiveRequest, *activeRequest;
	
	NSString *username, *password, *verifyCode;
	NSString *bdVerify, *bdStoken, *bdTime;
	UIImage *verifyImage;
	UIImageView *verifyImageView;
	
	UIButton *verifyButton, *weiboLoginButton;
	UITextField *mUsernameTextField, *mPasswordTextField, *mVerifyCodeTextField;
	
    NSString *nickName;
	
    BOOL isJustAuth;    // 只作passport登录，不检查激活
	BOOL _isActived;
    BOOL _isWeiboBind;
	BOOL _isWeiboSync;
    NSDate *_loginTime;     // 登录时间 (用于SSID超时重新登录)
	
	SignupController* signupWindow;
}
@property(nonatomic, assign) id delegate;
@property(nonatomic, assign) SEL authSuccessSEL;
@property(nonatomic, assign) SEL loginSuccessSEL;
@property(nonatomic, assign) SEL checkActivityFinishedSEL;
@property(nonatomic, copy) NSString *username;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, copy) NSString *verifyCode;
@property(nonatomic, copy) NSString *bdVerify;
@property(nonatomic, copy) NSString *bdStoken;
@property(nonatomic, copy) NSString *bdTime;
@property(nonatomic, copy) NSString *nickName;
@property(nonatomic, retain) UIImage *verifyImage;
@property(nonatomic, assign) BOOL isJustAuth;
@property(nonatomic, assign, readonly) BOOL isActived;
@property(nonatomic, assign) BOOL isWeiboBind;
@property(nonatomic, assign) BOOL isWeiboSync;
@property(nonatomic, retain) SignupController* signupWindow;
@property(nonatomic, retain) UIButton* verifyButton;

+ (LoginController *)sharedInstance;
- (void)autoLogin;
- (BOOL)isLogin;
- (void)destroySession;
- (void)logout;
- (void)showBindViewWithNickname:(NSString *)nickname andImageLink:(NSString *)link;
- (void)showLoginView;
- (void)hideLoginView;
- (void)hideLoginViewWithNotification;
- (void)showSignupView;
- (void)login:(id)sender;
- (void)isActiveRequest;
- (void)activeWithNickname:(NSString *)nickName;

@end