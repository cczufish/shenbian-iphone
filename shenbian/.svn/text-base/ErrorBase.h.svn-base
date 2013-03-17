//
//  ErrorBase.h
//  shenbian
//
//  Created by Dai Daly on 11-8-31.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ErrorBaseDelegate

@required

@optional
- (void)errorCallBack:(int)errorNum request:(HttpRequest*)req;
@end
@interface ErrorBase : NSObject
{
    id delegate;
}

@property (assign) id delegate;
- (id)initWithDelegate:(id)delegateObj;
-(void)errorProcessByErrorNum:(HttpRequest*)req;
@end
