    //
//  SuggestViewController.m
//  shenbian
//
//  Created by Leeyan on 11-5-13.
//  Copyright 2011 百度. All rights reserved.
//

#import "SuggestViewController.h"
#import "MBProgressHUD.h"

@interface SuggestViewController ()

-(void)_showLoadingView;
-(void)_hidenLoadingView;

@end

@implementation SuggestViewController

@synthesize suggTextView, emailTextView, strHint, strFeedback, strEmail;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/

- (void) selfInit
{
	strHint = @"感谢您的建议和意见";
}

- (id) init {
	if (self = [super init]) {
		[self selfInit];
	}
	return self;
}

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
	[super loadView];
	
	int padding = 2;	//	text view padding
	
	self.view.backgroundColor = [UIColor whiteColor];

	UIImage* image = PNGImage(@"photosubmit_tf_bg");

	//	sugg box
	UIImageView* bgView = [[UIImageView alloc] initWithFrame:vsr(10, 10, 300, 100)];
						   
	UITextView* textView = [[UITextView alloc] initWithFrame:
							vsr(bgView.origin.x + padding, bgView.origin.y + padding,
								bgView.size.width - padding * 2, bgView.size.height - padding * 2)];
	bgView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	textView.backgroundColor = [UIColor clearColor];
	
	textView.text = strHint;
	
	self.suggTextView = textView;
	self.suggTextView.delegate = self;
	[self.view addSubview:bgView];
	[textView release];
	[bgView release];
	
	//	email label
	UILabel* emailLabel = [[UILabel alloc] initWithFrame:vsr(12, 120, 300, 32)];
	emailLabel.text = @"您的email（方便联系您）";
	emailLabel.font = FontWithSize(14);
	[self.view addSubview:emailLabel];
	[emailLabel release];
	
	//	email box
	bgView = [[UIImageView alloc] initWithFrame:vsr(10, 160, 300, 64)];
	textView = [[UITextView alloc] initWithFrame:
				vsr(bgView.origin.x + padding, bgView.origin.y + padding,
					bgView.size.width - padding * 2, bgView.size.height - padding * 2)];
	bgView.image = [image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	textView.backgroundColor = [UIColor clearColor];
	
	self.emailTextView = textView;
	[self.view addSubview:bgView];
	[textView release];
	[bgView release];
	
	//	add subview
	[self.view addSubview:self.suggTextView];
	[self.view addSubview:self.emailTextView];
	
	//	submit button
	UIBarButtonItem* leftButton = [[UIBarButtonItem alloc] initWithTitle:@"取消"
																   style:UIBarButtonItemStylePlain
																  target:self 
																  action:@selector(doCancel)];
	self.navigationItem.leftBarButtonItem = leftButton;
	[leftButton release];
	
	UIBarButtonItem* rightButton = [[UIBarButtonItem alloc] initWithTitle:@"提交"
																	style:UIBarButtonItemStyleBordered
																   target:self 
																   action:@selector(doSubmit)];
	self.navigationItem.rightBarButtonItem = rightButton;
	[rightButton release];
}

- (void) doCancel
{
	[self.navigationController popViewControllerAnimated:YES];
}

- (void) doSubmit
{
	[self _showLoadingView];
	[self _hidenLoadingView];

}

- (void) setFeedbackText:(NSString*)string
{
	if ([string isEqualToString:@""]) {
		suggTextView.text = strHint;
	} else {
		suggTextView.text = string;
	}
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
	if (textView == suggTextView) {
		if ([textView.text isEqualToString:strHint]) {
			textView.text = @"";
			strFeedback = @"";
		}
	}
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	if (textView == suggTextView) {
		self.strFeedback = textView.text;
		[self setFeedbackText:self.strFeedback];
	}
	
}

- (void)_showLoadingView
{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
		//        HUD.mode = 
    }
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"提交中...";
    [HUD show:YES];
}

- (void)_hidenLoadingView
{
    //TODO: add loading view
    [HUD hide:YES];
    VSSafeRelease(HUD);
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
	self.suggTextView = nil;
	self.emailTextView = nil;
	
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;

}


- (void)dealloc {
	[suggTextView release];
	[emailTextView release];
	[strFeedback release];
	[strHint release];
	
    [super dealloc];
}


@end
