    //
//  HotChannelView.m
//  shenbian
//
//  Created by MagicYang on 10-12-31.
//  Copyright 2010 personal. All rights reserved.
//

#import "HotChannelView.h"
#import "SBButton.h"
#import "SBObject.h"


@implementation HotChannelView

@synthesize items;
@synthesize delegate;


- (CGRect)itemRectWithIndex:(NSInteger)index {
	switch (index) {
		case 0: return CGRectMake(-1, 13, 87, 87);
		case 1: return CGRectMake(75, 25, 87, 87);
		case 2: return CGRectMake(150, 13, 87, 87);
		case 3: return CGRectMake(230, 20, 87, 87);
		case 4: return CGRectMake(-1, 120, 87, 87);
		case 5: return CGRectMake(78, 130, 87, 87);
		case 6: return CGRectMake(157, 121, 87, 87);
		case 7: return CGRectMake(235, 130, 87, 87);
	}
	return CGRectZero;
}

- (CGFloat)itemAngleWithIndex:(NSInteger)index {
	switch (index) {
		case 0: return (8 * M_PI) / 180.0;
		case 1: return -(5 * M_PI) / 180.0;
		case 2: return (3 * M_PI) / 180.0;
		case 3: return -(5 * M_PI) / 180.0;
		case 4: return -(5 * M_PI) / 180.0;
		case 5: return (3 * M_PI) / 180.0;
		case 6: return -(5 * M_PI) / 180.0;
		case 7: return (5 * M_PI) / 180.0;
	}
	return 0;
}

- (void)initButtonWithIndex:(NSInteger)index andCategory:(SBCategory *)ch
{
    SBButton *button = [[SBButton alloc] initWithFrame:[self itemRectWithIndex:index]];
    NSInteger iconTag = ch.id > LastHotChannelID ? -1 : ch.id;
    NSString *btnName0 = [NSString stringWithFormat:@"icon_channel_%d", iconTag];
    NSString *btnName1 = [NSString stringWithFormat:@"icon_channel_%d_clicked", iconTag];
    [button setImage:PNGImage(btnName0) forState:UIControlStateNormal];
    [button setImage:PNGImage(btnName1) forState:UIControlStateHighlighted];
    [button setTag:index];
    [button addTarget:self action:@selector(goChannel:) forControlEvents:UIControlEventTouchUpInside];
    
    // rotate button
    CGFloat angle = [self itemAngleWithIndex:index];
    CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
    button.transform = rotation;
    [buttons addObject:button];
    [button release];
}

- (id)initWithDelegate:(id)del andItems:(NSArray *)item {
	if ([item count] == 0) {
		return nil;
	}
	
	if ((self = [super init])) {
		self.delegate = del;
		self.items    = item;
		self.backgroundColor = [UIColor clearColor];
        
        // channel button        
		buttons = [NSMutableArray new];
        BOOL hasBianMin = NO;
        
        int btnCount = 0;
        int i = 0;
		for (i = 0; i < [items count]; i++)
        {
            SBCategory *ch = [items objectAtIndex:i];
            if ([SBCategory belongsToBianMin:ch.id]) {
                if (!hasBianMin) {
                    [self initButtonWithIndex:i andCategory:ch];
                    hasBianMin = YES;
                    btnCount++;
                }
            } else {
                [self initButtonWithIndex:i andCategory:ch];
                btnCount++;
            }
		}
        
        // set frame
		if (btnCount > 4) {
			self.frame = CGRectMake(0, 0, 320, 225);
		} else {
			self.frame = CGRectMake(0, 0, 320, 130);
		}
        
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.frame.size.height - 1, 320, 1)];
        line.image = PNGImage(@"line_dot");
        [self addSubview:line];
        [line release];
	}
	return self;
}

- (void)goChannel:(id)sender {
	UIButton *btn = sender;
	if ([delegate respondsToSelector:@selector(goChannelSearch:)]) {
		[delegate performSelector:@selector(goChannelSearch:) withObject:[items objectAtIndex:btn.tag]];
	}
}

- (void)dealloc {
	[items release];
	[buttons release];
    [super dealloc];
}

- (void)showButton:(NSNumber *)index {
	int i = [index intValue];
	SBButton *btn = [buttons objectAtIndex:i];
	[self addSubview:btn];
	if (i < [buttons count] - 1) {
		[self performSelector:@selector(showButton:) withObject:NUM(++i) afterDelay:0.08];
	}
}

- (void)show {
	[self showButton:0];
}

@end
