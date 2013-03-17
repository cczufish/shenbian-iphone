//
//  ErrorCenter.h
//  shenbian
//
//  Created by Dai Daly on 11-8-30.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
	ErrorTypeSystem = 1,
	ErrorTypeLogin = 2,
	ErrorTypeSignUp = 3
}ErrorType;

@class HttpRequest;

@interface ErrorCenter : NSObject
+ (void)showErrorInfo:(NSInteger)errNo;
+ (void)showErrorInfo:(NSInteger)errorNum errorType:(ErrorType)type;
@end