//
//  WeiboBindController.h
//  shenbian
//
//  Created by MagicYang on 6/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef enum {
    BindStepStartLogin = 0,
    BindStepAfterAuth  = 1,
    BindStepFinishBind = 2
} BindStep;


@class LoadingView;
@interface WeiboBindController : NSObject<UIWebViewDelegate> {
    UIView *_bindView;
    UIWebView *_webView;
    LoadingView *_loadingView;
    NSString *mkey;
    NSString *nickName;
    NSString *bdussFromWeibo; // 微博认证成功后，其对应百度帐号的bduss
    BindStep step;
}

+ (WeiboBindController *)sharedInstance;
- (void)showBindView;
- (void)hideBindView;

@end