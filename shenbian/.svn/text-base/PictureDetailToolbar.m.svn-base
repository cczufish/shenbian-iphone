//
//  PhotoDetailToolbar.m
//  shenbian
//
//  Created by MagicYang on 6/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PictureDetailToolbar.h"


@implementation PictureDetailToolbar
@synthesize delegate;

- (id)initWithDelegate:(id)del
{
    self = [super initWithFrame:CGRectMake(0, 480 - 64 - 47, 320, 47)];
    if (self) {
        self.delegate = del;
        self.image = PNGImage(@"pd_bg_buttombar");
        self.userInteractionEnabled = YES;
        
        commentButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [commentButton setFrame:CGRectMake(10, 10, 200, 30)];
        [commentButton addTarget:self action:@selector(comment) forControlEvents:UIControlEventTouchUpInside];
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setShowsTouchWhenHighlighted:YES];
        [shareButton setImage:PNGImage(@"button_pd_share") forState:UIControlStateNormal];
        [shareButton setFrame:CGRectMake(220, 0, 50, 45)];
        [shareButton addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
        likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [likeButton setShowsTouchWhenHighlighted:YES];
        [likeButton setImage:PNGImage(@"button_pd_like") forState:UIControlStateNormal];
        [likeButton setFrame:CGRectMake(270, 0, 50, 45)];
        [likeButton addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:commentButton];
        [self addSubview:shareButton];
        [self addSubview:likeButton];
    }
    return self;
}

- (void)updateLikeButtonWithState:(BOOL)isLike
{
    UIImage* img = isLike ? PNGImage(@"button_pd_like_red") : PNGImage(@"button_pd_like") ;
    [likeButton setImage:img forState:UIControlStateNormal];    
}

- (void)enableShareButton:(BOOL)enabled
{
    shareButton.enabled = enabled;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)comment
{
    if ([delegate respondsToSelector:@selector(onAddComment)]) {
        [delegate performSelector:@selector(onAddComment)];
    }
}

- (void)share
{
    if ([delegate respondsToSelector:@selector(onBtnSharePhoto)]) {
        [delegate performSelector:@selector(onBtnSharePhoto)];
    }
}

- (void)like
{
    if ([delegate respondsToSelector:@selector(onTrigglelikeBtnClicked)]) {
        [delegate performSelector:@selector(onTrigglelikeBtnClicked)];
    }
}

@end
