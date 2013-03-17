//
//  PhotoSubmitVC.h
//  shenbian
//
//  Created by xhan on 5/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SBNavigationController.h"


// Add by MagicYang
typedef enum {
    kWeiboSyncStateDisabled     = 0,
    kWeiboSyncStateEnableUnused = 1,
    kWeiboSyncStateEnableUsed   = 2
} WeiboSyncState;
// Add end

@interface PhotoSubmitVC : SBNavigationController <UITextViewDelegate> {
    @private
    
    MBProgressHUD *HUD;
    
    UILabel *labelCommodity;
    UILabel *labelShop;
    UIImageView *imageSubmit;
    
	//	comment box
	UIView		*_bgView;
	UIImageView	*_bgCommentView;
	UITextView	*_commentTextView;
	
	//	comment buttons
	UIButton	*_btnCross;
	UIButton	*_btnCheck;
    UIButton    *buttonWeiboSync;
	
	//	comment box position
	CGRect _commentRectLarge, _commentRectSmall;
	
	//	comment default hint
	NSString	*_commentHint;
	UIColor		*_commentHintColor;
	
	//	comment words
	NSString	*_strCommentWords;

    BOOL isWaitingForImgPosted;
}
@property (nonatomic, retain) IBOutlet UILabel *labelCommodity;

@property (nonatomic, retain) IBOutlet UILabel *labelShop;
@property (nonatomic, retain) IBOutlet UIImageView *imageSubmit;

@property (nonatomic, retain) UIView		*_bgView;
@property (nonatomic, retain) UIImageView	*_bgCommentView;
@property (nonatomic, retain) UITextView	*_commentTextView;
@property (nonatomic, retain) NSString		*strCommentWords;

- (IBAction)onBtnSubmitPressed:(id)sender;
- (void)_setupCommentsView;
- (void)_showLoadingView;
- (void)_hidenLoadingView;
@end
