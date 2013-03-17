//
//  AlbumCellView.m
//  shenbian
//
//  Created by MagicYang on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "AlbumCellView.h"
#import "SBAlbum.h"
#import "PhotoCellView.h"

#define WIDTH 90
#define SPACE 12

@implementation AlbumCellView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame andDelegate:(id)del
{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = del;
        for (int i = 0; i < PHOTO_COUNT_PER_ROW; i++) {
			PhotoCellView *photoCell = [[PhotoCellView alloc] 
										initWithFrame:CGRectMake(SPACE + (WIDTH + SPACE) * i, SPACE, WIDTH, WIDTH)
										  andDelegate:self
								   photoPressedAction:@selector(showPhoto:)
											 andExtra:NUM(i)];
			photoCell.tag = i;
			[self addSubview:photoCell];
            /*
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.tag = i;
            btn.frame = CGRectMake(SPACE + (WIDTH + SPACE) * i, SPACE, WIDTH, WIDTH);
            btn.enabled = NO;
            [btn addTarget:self action:@selector(showPhoto:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:btn];
             */
        }
    }
    return self;
}

- (void)displayImages
{
    SBAlbumRow *ar = dataModel;
    int photoCountInThisRow = [[ar albumRow] count];
    int i = 0;
    for (UIView *subView in [self subviews])
    {
        SBPhoto *photo = [ar photoAtColumn:i];
		if ([subView isKindOfClass:[PhotoCellView class]]) {
            PhotoCellView *photoCell = (PhotoCellView *)subView;
            if (i < photoCountInThisRow) {                
                [photoCell setImage:photo.img];
                photoCell.hidden = NO;
            } else {
                // If there no enough photo full with the row, u must hide it,
                // because of the cell reuse
                photoCell.hidden = YES;
            }
		}
        /*
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *btn = (UIButton *)subView;
            btn.enabled = photo.img ?  YES : NO;
            [btn setImage:photo.img forState:UIControlStateNormal];
        }
         */
        i++;
    }
}

- (void)setDataModel:(id)model 
{
    // TODO: Why here crash ? self is not the observer for photo ? WHY ?
//    for (SBPhoto *photo in [((SBAlbumRow *)dataModel) albumRow]) {
//        [photo removeObserver:self forKeyPath:@"img"];
//    }
    
	[super setDataModel:model];
    
    for (SBPhoto *photo in [((SBAlbumRow *)dataModel) albumRow]) {
        [photo addObserver:self forKeyPath:@"img" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:NULL];
    }
    
    [self displayImages];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	[self displayImages];
}

+ (NSInteger)heightOfCell:(id)data
{
    return WIDTH + SPACE;
}

- (void)dealloc
{
    SBAlbumRow *ar = dataModel;
    for (SBPhoto *photo in [ar albumRow]) {
        [photo removeObserver:self forKeyPath:@"img"];
    }
    [super dealloc];
}

- (void)showPhoto:(id)sender
{
    if ([delegate respondsToSelector:@selector(showPhoto:)]) {
        UIButton *btn = sender;
        SBAlbumRow *ar = dataModel;
        SBPhoto *photo = [ar photoAtColumn:btn.tag];
        [delegate performSelector:@selector(showPhoto:) withObject:photo];
    }
}

@end
