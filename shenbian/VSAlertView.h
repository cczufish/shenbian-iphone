//
//  VSAlertView.h
//  shenbian
//
//  Created by Leeyan on 11-7-19.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


@interface VSAlertView : UIView {
    UIImageView *dialogView;
	id delegate;
    BOOL _growing, _shrinking;
	
	CALayer *alertLayer;
}

- (id)initWithMessage:(NSString *)_message icon:(UIImage *)_icon delegate:(id)_delegate;
- (void)show;

@end
