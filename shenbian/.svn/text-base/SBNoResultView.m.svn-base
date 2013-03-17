//
//  SBNoResultView.m
//  shenbian
//
//  Created by MagicYang on 7/15/11.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "SBNoResultView.h"


@implementation SBNoResultView

- (id)initWithFrame:(CGRect)frame andText:(NSString *)msg
{
    self = [super initWithFrame:frame];
    if (self) {
		UIImageView *imageView = [[UIImageView alloc] initWithImage:PNGImage(@"notfound")];
		imageView.frame = vsrc(160, 55, 118, 109);
		
		UILabel *notFoundLabel = [[UILabel alloc] initWithFrame:vsr(40, 110, 240, 80)];
		notFoundLabel.text = msg;
        notFoundLabel.adjustsFontSizeToFitWidth = YES;
		notFoundLabel.textAlignment = UITextAlignmentCenter;
		notFoundLabel.numberOfLines = 0;
		notFoundLabel.backgroundColor = [UIColor clearColor];
		notFoundLabel.font = FontWithSize(14.0f);
        
		[self addSubview:imageView];
		[self addSubview:notFoundLabel];
		
		[imageView release];
		[notFoundLabel release];
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

@end
