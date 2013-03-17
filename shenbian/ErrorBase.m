//
//  ErrorBase.m
//  shenbian
//
//  Created by Dai Daly on 11-8-31.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "ErrorBase.h"
#import "ErrorCenter.h"
@implementation ErrorBase
@synthesize delegate;

-(void)errorProcessByErrorNum:(HttpRequest*)req{
  int  errorNum= [[AppDelegate sharedDelegate].errorCenter process:req];
    errorNum=1;
   	if (errorNum&&[delegate respondsToSelector:@selector(errorCallBack:request:)]){
		[delegate errorCallBack:errorNum request:req];
    }

}
- (id)initWithDelegate:(id)delegateObj{
    self = [super init];
    if (self) {
        // Initialization code here.
        delegate=delegateObj;
    }
    
    return self;
}
@end
