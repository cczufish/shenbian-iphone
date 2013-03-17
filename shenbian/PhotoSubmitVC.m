//
//  PhotoSubmitVC.m
//  shenbian
//
//  Created by xhan on 5/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PhotoSubmitVC.h"
#import "LoginController.h"
#import "PhotoController.h"
#import "WeiboBindController.h"

#import "Utility.h"
#import	"AppDelegate.h"
#import "TKAlertCenter.h"
#import "CacheCenter.h"
#import "SBShopInfo.h"
#import "PhotoUploadSuccessVC.h"
#import "Notifications.h"


@implementation PhotoSubmitVC
@synthesize labelCommodity;
@synthesize labelShop;
@synthesize imageSubmit;

@synthesize _bgCommentView;
@synthesize _commentTextView;
@synthesize strCommentWords = _strCommentWords;
@synthesize _bgView;

- (id)init {
	if ((self = [super initWithNibName:@"PhotoSubmitVC" bundle:nil])) {
		[Notifier addObserver:self selector:@selector(weiboBindSucceed) name:kWeiboBindSucceed object:nil];
	}
	return self;
}

- (void)dealloc
{
    [Notifier removeObserver:self name:kWeiboBindSucceed object:nil];
    [PhotoController singleton].delegate = nil;
    [labelCommodity release];
    [labelShop release];
    [imageSubmit release];
	
	[_bgCommentView release];
	[_commentTextView release];
	[_commentHintColor release];
	[_btnCheck release];
	[_btnCross release];
	[_bgView release];
	[_strCommentWords release];
	
    [super dealloc];
}

// Add by MagicYang
- (void)setUpWeiboSyncState:(WeiboSyncState)state
{
    buttonWeiboSync.tag = state;
    NSString *buttonName = [NSString stringWithFormat:@"button_weibosync_%d", buttonWeiboSync.tag];
    [buttonWeiboSync setImage:PNGImage(buttonName) forState:UIControlStateNormal];
}
// Add end

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [PhotoController singleton].delegate = self;
    
    self.title = NSLocalizedString(@"提交", @"");
    imageSubmit.clipsToBounds = YES;
    self.imageSubmit.contentMode = UIViewContentModeScaleAspectFill;
    self.imageSubmit.image = [PhotoController singleton].neededUploadImg;
    
    labelCommodity.text = [PhotoController singleton].commodity;
    labelShop.text = [NSString stringWithFormat:@"@%@", [PhotoController singleton].shopName];
    
    [labelCommodity sizeToFit];

    labelShop.left = labelCommodity.right + 3;
	labelShop.width = 310 -  labelShop.left;
	
	// comments view
	[self _setupCommentsView];
	
    // load weibo connections
    // Edit by MagicYang
    buttonWeiboSync = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonWeiboSync.frame = vsr(70, 305, 40, 30);
    [buttonWeiboSync addTarget:self action:@selector(onSinaWeiboPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonWeiboSync];
    if ([[LoginController sharedInstance] isWeiboBind]) {
        if ([[LoginController sharedInstance] isWeiboSync]) {
            [self setUpWeiboSyncState:kWeiboSyncStateEnableUsed];
        } else {
            [self setUpWeiboSyncState:kWeiboSyncStateEnableUnused];
        }
    } else {
        [self setUpWeiboSyncState:kWeiboSyncStateDisabled];
    }
    // Edit end
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    int bind = [[LoginController sharedInstance] isWeiboBind] ? 1 : 0;
    int open = [[LoginController sharedInstance] isWeiboSync] ? 1 : 0;
    NSString *action = [NSString stringWithFormat:@"photocommit_into?bind=%d&default_open=%d",
                        bind, open];
    Stat(action);
}

- (void)_setCommentText:(NSString *)strCommentText
{
	if ([strCommentText isEmpty]) {
		_commentTextView.text = _commentHint;
		_commentTextView.textColor = _commentHintColor;
	} else {
		_commentTextView.text = strCommentText;
		_commentTextView.textColor = [UIColor blackColor];
	}
}

- (void)_setupCommentsView
{
    //TODO: add comments view
	_commentRectSmall = vsr(20, 250, 280, 35);
	_commentRectLarge = vsr(11, 20, 298, 204);
	
	_commentHint = @"还想说点什么";
	_commentHintColor = [[Utility colorWithHex:0x858585] retain];
	_strCommentWords = @"";
	
	UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:_commentRectSmall];
	bgImageView.image = PNGImage(@"photosubmit_tf_bg");
	self._bgCommentView = bgImageView;
	
	UITextView *commentView = [[UITextView alloc] initWithFrame:_commentRectSmall];
	commentView.backgroundColor = [UIColor clearColor];
	commentView.delegate = self;
	commentView.font = FontWithSize(14.0f);
	
	self._commentTextView = commentView;
	
	[self _setCommentText:_strCommentWords];
	
	[[self view] addSubview:_bgCommentView];
	[[self view] addSubview:_commentTextView];

	[bgImageView release];
	[commentView release];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
	Stat(@"photocommit_desc_into");
	UIImage *largeBg = [_bgCommentView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
	_bgCommentView.image = largeBg;
	
	// add button
	_btnCheck = [[T createBtnfromPoint:ccp(258,229)
								image:PNGImage(@"btn_check") 
							   target:self
							 selector:@selector(onCommentSubmitPressed)] retain];
	
	_btnCross = [[T createBtnfromPoint:ccp(11,229)
								image:PNGImage(@"btn_cross")
							   target:self
							 selector:@selector(onCommentCancelPressed)] retain];
	
	_bgCommentView.frame = _commentRectLarge;
	_commentTextView.frame = _commentRectLarge;
	
	UIView* window = [AppDelegate sharedDelegate].window;
	UIView* bgView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	bgView.backgroundColor = [UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.5f];
	self._bgView = bgView;
	
	[bgView release];
	
	[window addSubview:_bgView];
	[window addSubview:_bgCommentView];
	[window addSubview:_commentTextView];
	
	[window addSubview:_btnCheck];
	[window addSubview:_btnCross];
	
	textView.textColor = [UIColor blackColor];
	textView.font = FontWithSize(16.0f);

	if ([_commentHint isEqualToString:textView.text]) {
		textView.text = @"";
	}
	
	return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
	_bgCommentView.frame = _commentRectSmall;
	_commentTextView.frame = _commentRectSmall;
	[self.view addSubview:_bgCommentView];
	[self.view addSubview:_commentTextView];
	[_btnCheck removeFromSuperview];
	[_btnCross removeFromSuperview];
	[_bgView removeFromSuperview];
	
	textView.font = FontWithSize(14);
	[self _setCommentText:_strCommentWords];
}

- (BOOL)textView:(UITextView *)textView 
	shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
	
	int textLength = [textView.text length];
	
	if (textLength < 140 || [text length] == 0) {
		return YES;
	}
	
	TKAlert(@"不要超过140个字");
	
	return NO;
}

- (void)viewDidUnload
{
    [self setLabelCommodity:nil];
    [self setLabelShop:nil];
    [self setImageSubmit:nil];
	
	self._bgCommentView = nil;
	self._commentTextView = nil;
	
    [super viewDidUnload];

}

- (void)_showLoadingView
{
    if (!HUD) {
        HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    }
    [self.navigationController.view addSubview:HUD];
    HUD.labelText = @"上传中...";
    [HUD show:YES];
}

- (void)_hidenLoadingView
{
    [HUD hide:YES];
    VSSafeRelease(HUD);
}

- (BOOL)isWeiboShare
{
    return buttonWeiboSync.tag == kWeiboSyncStateEnableUsed;
}

- (void)onCommentSubmitPressed
{
	Stat(@"photocommit_desc_commit");
	self.strCommentWords = _commentTextView.text;	
	[_commentTextView resignFirstResponder];
}

- (void)onCommentCancelPressed
{
	Stat(@"photocommit_desc_close");
	[_commentTextView resignFirstResponder];
}

- (IBAction)onBtnSubmitPressed:(id)sender
{
    //TODO: add upload actions
    PhotoController* control = [PhotoController singleton];
	if (control.photoLinkID) {
        isWaitingForImgPosted = YES;
        [control postImageInfoWith:self.strCommentWords 
                         shareSina:[self isWeiboShare]];
        [self _showLoadingView];
    } else {
        //waiting for callbacks
        [self _showLoadingView];
    }
}

// Edit by MagicYang
- (void)onSinaWeiboPressed:(id)sender
{
    if (buttonWeiboSync.tag == kWeiboSyncStateDisabled) {
        Stat(@"photocommit_sinashare?on=1&into_bind=1");
        [[WeiboBindController sharedInstance] showBindView];
    } else if (buttonWeiboSync.tag == kWeiboSyncStateEnableUnused) {
        Stat(@"photocommit_sinashare?on=1&into_bind=0");
        [self setUpWeiboSyncState:kWeiboSyncStateEnableUsed];
    } else if (buttonWeiboSync.tag == kWeiboSyncStateEnableUsed) {
        Stat(@"photocommit_sinashare?on=0&into_bind=0");
        [self setUpWeiboSyncState:kWeiboSyncStateEnableUnused];
    } else {
        assert("Illegal tag value for Weibo sync button");
    }
}

- (void)weiboBindSucceed
{
    [self setUpWeiboSyncState:kWeiboSyncStateEnableUnused];
}
// Edit end


#pragma mark -
#pragma mark PhotoControllerDelegates

- (void)photoPosted:(BOOL)isSuccessed
{
    if (isSuccessed) {
        if (isWaitingForImgPosted) {
            // Annotation below by MagicYang
//            isPhotoPosted = YES;
            [[PhotoController singleton] postImageInfoWith:self.strCommentWords 
                                                 shareSina:[self isWeiboShare]];
        }
        isWaitingForImgPosted = NO;
    }else{
        
    }
}

// only post info after successed posted Photo, so the progress is success while received isSuccessed = YES
- (void)photoInfoPosted:(BOOL)isSuccessed
{
    [self _hidenLoadingView];
}


- (void)photoProgressSuccessd:(NSDictionary*)successInfo
{
    SBShopInfo *shop = [SBShopInfo new];
    PhotoController *pc = [PhotoController singleton];
    shop.shopId = [pc shopId];
    shop.strName = [pc shopName];
    shop.isCommodityShop = pc.isCommodityShop;
    [[CacheCenter sharedInstance] recordPhotoShop:shop];
    [shop release];
    
    [Notifier postNotificationName:kPhotoSucceed 
                            object:nil
                          userInfo:[NSDictionary dictionaryWithObject:[pc shopId] forKey:@"shopId"]];
    
    //navigation to last VC
    PhotoUploadSuccessVC * vc = [[PhotoUploadSuccessVC alloc] initWithResults:successInfo];
    [self.navigationController pushViewController:vc animated:YES];
    [vc release];
    
    [self _hidenLoadingView];
}

@end
