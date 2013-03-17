    //
//  FeedbackViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-30.
//  Copyright 2010 personal. All rights reserved.
//

#import "FeedbackViewController.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "Utility.h"
#import "MBProgressHUD.h"
#import "SBApiEngine.h"
#import "TKAlertCenter.h"


@implementation FeedbackViewController

@synthesize shopId;
@synthesize content, email;

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"feedback_into");
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	[Notifier removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[Notifier removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)loadView {
	[super loadView];
	self.title = shopId ? @"报错" : @"意见反馈";
	self.view.backgroundColor = [UIColor clearColor];
}

- (void)viewDidLoad {
	[Notifier addObserver:self selector:@selector(keyboardShow) name:UIKeyboardDidShowNotification object:nil];
	[Notifier addObserver:self selector:@selector(keyboardHide) name:UIKeyboardWillHideNotification object:nil];
}

- (void)dealloc {
	[Notifier removeObserver:self name:UIKeyboardDidShowNotification object:nil];
	[Notifier removeObserver:self name:UIKeyboardWillHideNotification object:nil];
	
	[tv release];
	[tf release];
	[shopId release];
	[content release];
	[email release];
	
    [super dealloc];
}

- (void)keyboardShow {
	CGRect rect = tableView.frame;
	tableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height - KeyboardHeight + 50);
}

- (void)keyboardHide {
	CGRect rect = tableView.frame;
	tableView.frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height + KeyboardHeight - 50);
}


- (void)submit:(id)sender {
    if (![SBApiEngine isEmailAddress:email]) {
		TKAlert(@"邮箱格式错误,请检查后重新提交");
		return;
	} 
    
	[tv resignFirstResponder];
	[tf resignFirstResponder];
	
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.customView = nil;
    progressHUD.mode = MBProgressHUDModeDeterminate;
    progressHUD.labelText = @"提交中...";

	NSString *url;
	
	CancelRequest(request);
	request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	
	if (shopId) {
//		content = [NSString stringWithFormat:@"[商户报错][id:%@]%@", shopId, content];
		// 商户信息报错 http://123.125.115.79/client/submit/0/reportError
		// shop_id:商户id   content:内容   email:邮箱
/*
		url = [NSString stringWithFormat:@"%@/feedback", ROOT_URL];
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
								shopId, @"shop_id",
								content, @"content",
								email, @"email", nil];
//*/
		url = [NSString stringWithFormat:@"%@/reportShop", ROOT_URL];
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
								shopId, @"s_fcrid",
								content, @"content",
								email, @"email", nil];
		[request requestPOST:url parameters:params useStat:YES];
	} else {
		// 用户提交反馈 http://123.125.115.79/client/submit/0/reportInfo
		// content:内容   email :邮箱   mode：机型类别(0:android  1:symbian  2:iphone)
		url = [NSString stringWithFormat:@"%@/feedback", ROOT_URL];
		NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
								content, @"content", 
								email, @"email", nil];
		[request requestPOST:url parameters:params];
	}
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)table {
	return 2;
}

- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)table titleForHeaderInSection:(NSInteger)section {
	if (section == 0) {
		return shopId ? @"错误内容" : @"您的意见";
	} else {
		return @"您的邮箱";
	}
}

- (CGFloat)tableView:(UITableView *)table heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		return 150;
	} else {
		return 40;
	}
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *TextViewCell  = @"TextViewCell";
	static NSString *TextFieldCell = @"TextFieldCell";
    
    UITableViewCell *cell;
	if (indexPath.section == 0) {
		cell = [table dequeueReusableCellWithIdentifier:TextViewCell];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextViewCell] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if (!tv) {
				tv = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, 280, 140)];
				tv.font = FontWithSize(16);
				tv.delegate = self;
			}
			[cell.contentView addSubview:tv];
		}
		
	} else {
		cell = [table dequeueReusableCellWithIdentifier:TextFieldCell];
		if (cell == nil) {
			cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:TextFieldCell] autorelease];
			cell.selectionStyle = UITableViewCellSelectionStyleNone;
			
			if (!tf) {
				tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 250, 40)];
				tf.font = FontWithSize(16);
				tf.delegate = self;
				tf.keyboardType = UIKeyboardTypeEmailAddress;
				tf.returnKeyType = UIReturnKeyDone;
			}
			[cell.contentView addSubview:tf];
		}
	}
	
    return cell;
}

#pragma mark -
#pragma mark UITextFieldDelegate, UITextViewDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	NSString *txt= [textField.text stringByReplacingCharactersInRange:range withString:string];
	self.email = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	[self showSubmitButton];
	
	return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	NSString *txt= [textView.text stringByReplacingCharactersInRange:range withString:text];
	self.content = [txt stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];

	if ([textView.text length] > 1000 && ![text isEqualToString:@""]) {
//		Alert(nil, @"您输入的文字字数已达到最大");
		return NO;
	}
	
	[self showSubmitButton];
	
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	
	return NO;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
	[tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:1]
						  atScrollPosition:UITableViewScrollPositionBottom
								  animated:YES];
	return YES;
}

- (void)showSubmitButton {
	if ([email length] > 0 && [content length] > 0 /* && [SBApiEngine isEmailAddress:email] */) {
		self.navigationItem.rightBarButtonItem = [SBNavigationController buttonItemWithTitle:@"提交" andAction:@selector(submit:) inDelegate:self];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
	TKAlert(@"提交失败");
    Release(request);
}

- (void)requestSucceeded:(HttpRequest*)req {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
	NSError *error = nil;
    [SBApiEngine parseHttpData:request.recievedData error:&error];
    if (error) {
        [self requestFailed:request error:error];
        return;
    }
    
	Release(request);
//	TKAlert(@"提交成功");
    [self.navigationController popViewControllerAnimated:YES];
}


@end
