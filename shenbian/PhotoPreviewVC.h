//
//  PhotoPreviewVC.h
//  shenbian
//
//  Created by xhan on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBNavigationController.h"

@interface PhotoPreviewVC : SBNavigationController<UIActionSheetDelegate> {
	UIImage* selectedImg;
	UIImageView* selectedImgView;
}
@property(nonatomic,assign)UIImagePickerControllerSourceType sourceType;

- (id)initWithImage:(UIImage*)image;
- (UIViewController *)nextController;
- (void)onBtnNextStep;
- (void)onBtnUploadFromCamera;
- (void)onBtnUploadFromAlbum;

@end
