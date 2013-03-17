//
//  AlertCenter.h
//  shenbian
//
//  Created by MagicYang on 2/14/11.
//  Copyright 2011 personal. All rights reserved.
//

#import <Foundation/Foundation.h>

#define Alert(T,M) [[AlertCenter sharedInstance] showAlertWithTitle:T andMessage:M]


@interface AlertCenter : NSObject<UIAlertViewDelegate> {
	UIAlertView *sharedAlertView;
	BOOL isShow;
}

@property(nonatomic, retain) UIAlertView *sharedAlertView;

+ (id)sharedInstance;

- (void)showAlertWithTitle:(NSString *)titleText andMessage:(NSString *)msgText;
- (void)showAlertWithError:(NSError *)error;
- (void)showAlertWithError:(NSError *)error requestType:(int)requestType;
- (void)showAlertWithErrorCode:(NSInteger)errorCode;

@end
