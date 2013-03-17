//
//  BadgeListView.m
//  shenbian
//
//  Created by xhan on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "BadgeListView.h"
#import "SBBadge.h"
#import "UIImageView+WebCache.h"


@implementation BadgeListView
@synthesize badgeDelegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.scrollsToTop = NO;
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        self.backgroundColor = [UIColor whiteColor];
        self.opaque = YES;        
        
        badgeViews = [[NSMutableArray alloc] init];
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}


- (void)dealloc
{
    [badgeViews makeObjectsPerformSelector:@selector(cancelCurrentImageLoad)];
    VSSafeRelease(badges);
    VSSafeRelease(badgeViews);
    VSSafeRelease(buttons);
    [super dealloc];
}

#pragma mark - actions

#define BadgeListColumn 4
#define BadgeListImgW 59
#define BadgeListImgH 62
#define BadgeListCellHeight 107
#define BadgeListCellPadding 13
#define BadgeListCellMargin 19
#define BadgeListCellTop 14
#define BadgeListCellBtnTopOffset -6
#define BadgeListCellBtnLeftOffset -4

#define BadgeListMaxHeight (460-44)

#define BadgeListSepearteLineHeight 14

- (void)reloadData:(NSArray*)badges_
{
    if (badges != badges_) {
        badges = [badges_ copy];
        
        //clean subviews        

        [self removeAllSubviews];
        
        [badgeViews makeObjectsPerformSelector:@selector(cancelCurrentImageLoad)];
        [badgeViews removeAllObjects];
        [buttons removeAllObjects];

        
        //finally setup new contentsize and bounds

        int rows = ([badges count]-1) / 4 + 1;
        int contentHeight = rows * BadgeListCellHeight;
        int viewHeight = MIN(contentHeight, BadgeListMaxHeight);
        self.height = viewHeight;
        self.contentSize = CGSizeMake(self.width, contentHeight);

        
        //add subviews
        for (int i = 0; i < [badges count]; i++) {
            //draw seperate line view
            int column = i % 4; 
            int row = i / 4;
            if (i % 4 == 0 ) {
                UIView* line = [T imageViewNamed:@"badge_list_bg.png"];
                line.top = (row) * BadgeListCellHeight;
                [self addSubview:line];
            }
            
            SBBadge* model = [badges objectAtIndex:i];
            
            //add badgeItems
            
            //add buttons;
            UIButton* btn = [[UIButton alloc] initWithFrame:CGRectMake(BadgeListCellPadding + column * (BadgeListImgW + BadgeListCellMargin) + BadgeListCellBtnLeftOffset, row * BadgeListCellHeight + BadgeListCellTop + BadgeListCellBtnTopOffset, 69, 91)];
            btn.backgroundColor = [UIColor clearColor];
            [btn setBackgroundImage:PNGImage(@"badge_list_highlight") forState:UIControlStateHighlighted];
            [btn addTarget:self action:@selector(onBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
            [buttons addObject:btn];
            
            
            UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(-BadgeListCellBtnLeftOffset, - BadgeListCellBtnTopOffset, BadgeListImgW, BadgeListImgH)];
            imgView.contentMode = UIViewContentModeScaleAspectFit;
            //TODO: need an default Badge image
            [imgView setImageWithURL:[NSURL URLWithString:model.picURL] placeholderImage:nil];
            [btn addSubview:imgView];
            [badgeViews addObject:imgView];
            [imgView release];
            
            //add badge title
            UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, BadgeListImgW , 13)];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = FontWithSize(12);
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.top = imgView.bottom + 10;
            titleLabel.left = imgView.left; 
            titleLabel.text = model.name;
            [btn addSubview:titleLabel];
            
            [titleLabel release];
            [btn release];
        }
        

    }
}


- (void)onBtnClicked:(UIButton*)btn
{
    int index = [buttons indexOfObject:btn];
    SBBadge* badge = [badges objectAtIndex:index];
    if ([badgeDelegate respondsToSelector:@selector(badgeListView:badgeClicked:atIndex:)]) {
        [badgeDelegate badgeListView:self badgeClicked:badge atIndex:index];
    }
}

@end





