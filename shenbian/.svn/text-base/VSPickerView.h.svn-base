//
//  VSPickerView.h
//  VSPicker
//
//  Created by MagicYang on 3/11/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>

#define PickerH 216

@class VSPickerIndex;

@interface VSPickerView : UIPickerView {
    id _target;
    UIToolbar *_toolbar;
    SEL cancelAction, finishAction;
    NSIndexPath *_selectedIndexPath;
    NSInteger tag;
}

@property(nonatomic, assign) id target;
@property(nonatomic, assign) SEL cancelAction;
@property(nonatomic, assign) SEL finishAction;
@property(nonatomic, retain) NSIndexPath *selectedIndexPath;
@property(nonatomic, assign) NSInteger tag;

- (void)showInView:(UIView *)view Animation:(BOOL)animated;
- (void)hideWithAnimation:(BOOL)animated;

@end