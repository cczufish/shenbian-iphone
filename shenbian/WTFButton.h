//
//  WTFButton.h
//  shenbian
//
//  Created by xhan on 4/20/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 button contains an label(float layout) at top-left
 */
@class VSEffectLabel;
@interface WTFButton : UIButton {
    @public
	VSEffectLabel* wtflabel;
    UIImage *normalImg, *votedImg;
    int voteNum;
    BOOL isVoted;
}
@property(nonatomic,readonly)BOOL isVoted;

- (id)init;
- (void)setVoteNum:(int)num;
- (void)setVoted:(BOOL)isVoted;

@end
