//
//  PhotoWrapperView.m
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "PhotoWrapperView.h"
#import "SBCommodityPhoto.h"

#import "SDImageCache.h"
#import "SDWebImageManager.h"

#import "UIImageView+WebCache.h"
#import "Utility.h"

#import "UIButton+RemoteImage.h"

#import <QuartzCore/QuartzCore.h>


#define PhotoViewWidth 300
#define PhotoOwnerInfoMinHeight 65

@implementation PhotoWrapperView
//@synthesize btnUserIcon;

- (id)initWithCommodityPhoto:(SBCommodityPhoto*)aphoto
{

	self = [super initWithFrame:CGRectMake(0, 0, 320, 0)];
	if (self) {
		photo = [aphoto retain];
		self.backgroundColor = [UIColor whiteColor];

        [self _loadImageView];
        [self _loadOwnerCommentView];
        [self _loadVotedPeopleGroupView];
        
        // actions
		[self loadRemoteImage];
		
	}
	return self;
}

- (void)_loadImageView
{
    // 如果图片高度／宽度 大于1：1, 截断显示中间部分，否者展现全局
    int imageMaxHeight = MIN(photo.cimgsize.height, photo.cimgsize.width);
    
	int imageViewHeight = imageMaxHeight * PhotoViewWidth / photo.cimgsize.width;
	int imageLeftPos = (320 - PhotoViewWidth)/2;
    
    //add photoview
    photoView = [[UIImageView alloc] initWithFrame:vsr(imageLeftPos, 0, PhotoViewWidth, imageViewHeight)];
    photoView.userInteractionEnabled = YES;
    photoView.contentMode = UIViewContentModeScaleAspectFill;
    photoView.clipsToBounds = YES;
    [self addSubview:photoView];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, 0, PhotoViewWidth, imageViewHeight)];
    [btn addTarget:self action:@selector(onBtnBigImageClicked:) forControlEvents:UIControlEventTouchUpInside];
    [photoView addSubview:btn];
}

- (void)_loadOwnerCommentView
{
    int yOffset = photoView.bottom;
	
    //user icon
    btnUserIcon = [[T createBtnfromPoint:ccp(5,yOffset + 6) imageStr:@"user_default.png" target:self selector:@selector(onBtnOwnerIconClicked:)] retain];
    btnUserIcon.layer.cornerRadius = 4;
    btnUserIcon.clipsToBounds = YES;
    btnUserIcon.bounds = CGRectMake(0, 0, 36, 36);
    
    [btnUserIcon setImageWithURL:[NSURL URLWithString:photo.user.uiconPath] placeholderImage:DefaultUserImage];
    [self addSubview:btnUserIcon];
    
    //user name
	UILabel* userName = [[UILabel alloc] initWithFrame:CGRectMake(54, yOffset + 8, 120, 20)];
	userName.backgroundColor = [UIColor clearColor];
	userName.textColor = [Utility colorWithHex:0x4f3100];
	userName.font = FontWithSize(14);
	userName.text = photo.user.uname;
	[self addSubview:userName];
	[userName release];
	
	// createdAt
	UILabel* createdAt = [[UILabel alloc] initWithFrame:CGRectMake(216, yOffset + 8, 94, 20)];
    createdAt.textAlignment = UITextAlignmentRight;
	createdAt.backgroundColor = [UIColor clearColor];
	createdAt.textColor = [Utility colorWithHex:0x858585];
	createdAt.font = FontLiteWithSize(12);
	createdAt.text = photo.createdAtFormated;
	[self addSubview:createdAt];
	[createdAt release];
    
	//user comments
    NSString* comment = photo.comments;
    UIFont* commentFont = FontLiteWithSize(14);
    int textWidth = 233;
    int commentHeight = [comment sizeWithFont:commentFont 
        constrainedToSize:CGSizeMake(textWidth, 9999)].height;
    commentHeight = MAX(10, commentHeight);

	UILabel* comments = [[UILabel alloc] initWithFrame:CGRectMake(54, yOffset + 35 , 233 , commentHeight )]; //CGRectMake(54, self.height - 38 + fixedYoffset, 233, 23)];
	comments.backgroundColor = [UIColor clearColor];
	comments.textColor = [Utility colorWithHex:0x858585];
	comments.font = commentFont;
	comments.text = comment;
	comments.numberOfLines = 0;
//	comments.frame = commentsRect;
	[self addSubview:comments];
	[comments release];
	
    
    //update self's height
    self.height =  comments.bottom + 15;
    
    // add shadow
    UIView* shadowView =  [[UIImageView alloc] initWithImage:PNGImage(@"navigationbar_shadow")];
    shadowView.bottom = self.height;
    [self addSubview:shadowView];
    [shadowView release];
    
}

- (void)_loadVotedPeopleGroupView
{

    if (votedGroupView) {
        [votedGroupView removeFromSuperview];
        self.height -= votedGroupView.height;
        VSSafeRelease(votedGroupView);
        VSSafeRelease(votedPeopleList);
    }    

    int maxVotedCount = MIN(6,photo.votedUserList.count);
    int yBaseLine = self.height;
    
    if (maxVotedCount == 0) {
        // do nothing
    }else{
        votedGroupView = [[UIView alloc] initWithFrame:CGRectMake(0, yBaseLine, 320, 82)];
        votedGroupView.backgroundColor = [T colorR:242 g:239 b:230];
        [self addSubview:votedGroupView];

        // add user icons
        votedPeopleList = [[NSMutableArray alloc] initWithCapacity:maxVotedCount];
        for (int i = 0; i < maxVotedCount; i ++) {
            UIButton* btn = [T createBtnfromPoint:ccp(i* 52+ 5, yBaseLine + 5) imageStr:@"user_default.png" target:nil selector:NULL];
            btn.layer.cornerRadius = 3;
            btn.clipsToBounds = YES;
            btn.bounds = CGRectMake(0, 0, 35, 35);
            [btn addTarget:self
                    action:@selector(onBtnLikedPeopleIconClicked:)
          forControlEvents:UIControlEventTouchUpInside];
            SBCommodityPhotoUser* user = [photo.votedUserList objectAtIndex:i];
            [btn setImageWithURL:[NSURL URLWithString:user.uiconPath] placeholderImage:DefaultUserImage];
            [self addSubview:btn];
            [votedPeopleList addObject:btn];
            
        }
        
        //add bottom star & text
        UIView* redHeartV = [T imageViewNamed:@"redheart.png"];
        redHeartV.origin = ccp(12, 56);
        [votedGroupView addSubview:redHeartV];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(35, 54, 270, 20)];
        label.backgroundColor = votedGroupView.backgroundColor;
        label.font = FontLiteWithSize(15);
        label.textColor = [UIColor blackColor];
        label.text = [NSString stringWithFormat:@"%d个人喜欢",photo.voteCount];
        [votedGroupView addSubview:label];
        [label release];
        
        //add bottom line
        UIView* line = [T imageViewNamed:@"dot_line_320.png"];
        line.bottom = votedGroupView.height;
        [votedGroupView addSubview:line];
        
        //setup self's height
        self.height = votedGroupView.bottom;
        
    }
    
}

- (void)dealloc {
	
	[btnUserIcon cancelCurrentImageLoad];
	VSSafeRelease(btnUserIcon);
    VSSafeRelease(votedGroupView);
    VSSafeRelease(votedPeopleList);
    VSSafeRelease(loadingIndicator);
    
	VSSafeRelease(photoView);
	VSSafeRelease(photo);
    [super dealloc];
}

#pragma mark -
#pragma mark public

- (void)onBtnLikedPeopleIconClicked:(id)sender
{
    int index = [votedPeopleList indexOfObject:sender];
    SBCommodityPhotoUser* user = [photo.votedUserList objectAtIndex:index];
    [btnTarget performSelector:selPeopleLiked withObject:user];
}

- (void)onBtnOwnerIconClicked:(id)sender
{
    [btnTarget performSelector:selUserinfo withObject:photo];
}

- (void)onBtnBigImageClicked:(id)sender
{
    [btnTarget performSelector:selBigImage withObject:photo];
}

- (void)addAction:(id)target userInfoSel:(SEL)selUserinfo_ likedPeopleSel:(SEL)selPeople bigImageSel:(SEL)selBigImg
{
    btnTarget = target;
    selUserinfo = selUserinfo_;
    selPeopleLiked = selPeople;
    selBigImage = selBigImg;
}


- (void)loadRemoteImage
{
        
	SDWebImageManager *manager = [SDWebImageManager sharedManager];
	[manager cancelForDelegate:self];
    if (photo.cid && ![photo.cid isEqual:[NSNull null]]) {
        [self _showLoadingImageIndicator];
		[manager downloadWithURL:[NSURL URLWithString:photo.photoBigURLstr] delegate:self];
	}else{
        VSLog(@"photoID not exist %@", photo.cid);
    }
}

- (void)cancelLoadRequest
{
    [self _hidenLoadingImageIndicator];
	[[SDWebImageManager sharedManager] cancelForDelegate:self];
}

#pragma mark -
#pragma mark SDWebImageManager delegate
- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    [self _hidenLoadingImageIndicator];
//	photoView.alpha = 0.0f;
//	
//	[UIView beginAnimations:@"" context:nil];
//	[UIView setAnimationDuration:0.7f];
//	[UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
	
	photoView.image = image;
//	photoView.alpha = 1.0f;
//	
//	[UIView commitAnimations];
	
    CATransition *transition = [CATransition animation];
    transition.duration = 0.7f;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = kCATransitionFade;
    
    [photoView.layer addAnimation:transition forKey:nil];
}



- (void)_showLoadingImageIndicator
{
    if(!loadingIndicator){
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.hidesWhenStopped = YES;
    }
    //CGPoint center = photoView.center;
    //center = ccp((int)(center.x), (int)(center.y));
    loadingIndicator.center = photoView.center;
    loadingIndicator.origin = ccp((int)(loadingIndicator.origin.x), (int)(loadingIndicator.origin.y));
    [loadingIndicator startAnimating];
    [self addSubview:loadingIndicator];
}
- (void)_hidenLoadingImageIndicator
{
    [loadingIndicator stopAnimating];
    [loadingIndicator removeFromSuperview];
    VSSafeRelease(loadingIndicator);
}
@end
