//
//  PhotoDetailToolbar.h
//  shenbian
//
//  Created by MagicYang on 6/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PictureDetailToolbar : UIImageView {
    id delegate;
    UIButton *commentButton, *shareButton, *likeButton;
}
@property(nonatomic, assign) id delegate;

- (id)initWithDelegate:(id)del;
- (void)updateLikeButtonWithState:(BOOL)isLike;
- (void)enableShareButton:(BOOL)enabled;

@end
