//
//  ComfirmCenter.h
//  shenbian
//
//  Created by MagicYang on 5/30/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ConfirmCenter : NSObject {
    id  delegate;
    SEL selector;
  	UIAlertView *confirmView;    
    BOOL isShow;
}

@property(nonatomic, assign) id  delegate;
@property(nonatomic, assign) SEL selector;

+ (id)sharedInstance;
- (void)confirmAction:(SEL)sel forObject:(id)obj withPromptText:(NSString *)text;

@end
