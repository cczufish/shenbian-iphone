//
//  AttentionCell.h
//  shenbian
//
//  Created by Dai Daly on 11-8-22.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttentionView.h"
@interface AttentionCell : UITableViewCell
{
    AttentionView *att1;
    AttentionView *att2;
    AttentionView *att3;


}
@property(nonatomic,retain)AttentionView *att1;
@property(nonatomic,retain)AttentionView *att2;
@property(nonatomic,retain)AttentionView *att3;
- (void)initAttention;
-(void)clearData;

@end
