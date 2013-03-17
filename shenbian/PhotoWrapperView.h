//
//  PhotoWrapperView.h
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManagerDelegate.h"

/*
 An wrapper view contains a PhotoView and a bottomView contain's the 
 photo's owner's infomations, and a list of voted uers
 */
@class SBCommodityPhoto;
@interface PhotoWrapperView : UIView<SDWebImageManagerDelegate> {
	SBCommodityPhoto* photo;
	UIImageView* photoView;
	UIActivityIndicatorView* loadingIndicator;
    
	UIButton* btnUserIcon;

    NSMutableArray* votedPeopleList;
    UIView* votedGroupView;
    
    id btnTarget;
    SEL selUserinfo, selPeopleLiked, selBigImage;
}


- (id)initWithCommodityPhoto:(SBCommodityPhoto*)photo;

- (void)_loadImageView;
- (void)_loadOwnerCommentView;
//setup voted list view 
- (void)_loadVotedPeopleGroupView;

- (void)loadRemoteImage;
- (void)cancelLoadRequest;

- (void)_showLoadingImageIndicator;
- (void)_hidenLoadingImageIndicator;

/*
 selectors
 userInfoSel:(SBCommodityPhoto*)photo
 likedPeopleSel:(SEL)selPeople is :(SBCommodityPhotoUser*)user
 */
- (void)addAction:(id)target userInfoSel:(SEL)selUserinfo_ likedPeopleSel:(SEL)selPeople bigImageSel:(SEL)selBigImg;

@end


