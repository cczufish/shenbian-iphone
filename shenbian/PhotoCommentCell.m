//
//  PhotoCommentCell.m
//  shenbian
//
//  Created by xu xhan on 6/28/11.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "PhotoCommentCell.h"
#import "SBCommodityPhoto.h"
#import "SBUser.h"
#import "Utility.h"
@implementation PhotoCommentCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [T colorR:242 g:239 b:230];
        
        
        //added user button
        CGRect imgFrame = CGRectMake(10, 10, 36, 36);
        UIButton* btn = [[UIButton alloc] initWithFrame:imgFrame];
        btn.backgroundColor = [UIColor clearColor];
        [btn addTarget:self 
                action:@selector(onUserIconClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
        [btn release];
        
        // add reply button
        //TODO: add it
        UIButton* replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        replyBtn.backgroundColor = [UIColor clearColor];
        replyBtn.frame = vsr(276, 9, 48, 48);
        [replyBtn setImage:PNGImage(@"btn_reply") forState:UIControlStateNormal];
        [replyBtn addTarget:self 
                action:@selector(onReplyButtonClicked:)
      forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:replyBtn];

    }
    
    return self;
}


- (void)onUserIconClicked:(id)sender
{
    UIViewController* vc =  self.viewController;
    if ([vc respondsToSelector:@selector(onCellViewUserIconClicked:)]) {
        [vc performSelector:@selector(onCellViewUserIconClicked:) withObject:dataModel];
    }
}

- (void)onReplyButtonClicked:(id)sender
{
    UIViewController* vc =  self.viewController;
    if ([vc respondsToSelector:@selector(onCellViewReplyClicked:)]) {
        [vc performSelector:@selector(onCellViewReplyClicked:) withObject:dataModel];
    }    
}

- (void)setDataModel:(id)model {
	[dataModel removeObserver:self forKeyPath:@"imgUserIcon"];

	[super setDataModel:model];
	[dataModel addObserver:self forKeyPath:@"imgUserIcon" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
	SBCommodityPhotoComment* amodel = dataModel;
	[amodel loadImageResource];
	[self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    SBCommodityPhotoComment* comment = dataModel;
    UIImage* img = SETNIL(comment.imgUserIcon, DefaultUserImage);
    
    //icon
    [SBUser drawUserAvatarWithImage:img atRect:vsr(10, 10, 36, 36) andIsVIP:NO];
    //name
    [[Utility colorWithHex:0x9F754B] set];
    [comment.userName drawInRect:CGRectMake(58, 10, 100, 20) withFont:FontWithSize(15)];
    
    [[UIColor blackColor] set];
    
	//comment
    int cheight = [comment.contents sizeWithFont:FontLiteWithSize(15) constrainedToSize:CGSizeMake(210, 9999)].height;
    [comment.contents drawInRect:CGRectMake(58, 30, 210, cheight) withFont:FontLiteWithSize(15)];
    
    int bottomY = 30 + cheight + 5;
    
    //time
    [GrayColor set];
    NSString *time = [Utility userFriendlyTimeFromUTC:[comment.timestamp doubleValue]];
    [time drawAtPoint:ccp(58, bottomY) withFont:FontLiteWithSize(13)];
    
    [PNGImage(@"dot_line_320") drawAtPoint:ccp(0, rect.size.height - 2)];
}

+ (NSInteger)heightOfCell:(id)model
{
    SBCommodityPhotoComment* comment = model;
    int cheight = [comment.contents sizeWithFont:FontWithSize(15) constrainedToSize:CGSizeMake(210, 9999)].height;
    int bottomY = 30 + cheight + 14 + 15;
    return bottomY;
}
@end
