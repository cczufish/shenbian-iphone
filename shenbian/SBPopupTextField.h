//
//  SBPopupTextField.h
//  shenbian
//
//  Created by MagicYang on 10-12-22.
//  Copyright 2010 personal. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SBPopupTextField : UIAlertView {
	UITextField *_textField;
}

- (UITextField *)textField;

@end
