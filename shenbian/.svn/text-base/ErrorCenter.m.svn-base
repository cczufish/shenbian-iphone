//
//  ErrorCenter.m
//  shenbian
//
//  Created by Dai Daly on 11-8-30.
//  Copyright 2011年 ÁôæÂ∫¶. All rights reserved.
//

#import "ErrorCenter.h"
#import "TKAlertCenter.h"
#import "LoginController.h"


@implementation ErrorCenter

static NSDictionary *errorDic;
static NSDate *lastTime;
+ (NSDictionary*)getErrorDic 
{
    
    if (!errorDic) {
        NSString *path=[[NSBundle mainBundle] pathForResource:@"ErrorDic" ofType:@"plist"];
        errorDic = [[NSDictionary alloc] initWithContentsOfFile:path];
    }
    return errorDic;
    
}
+ (void)setLastTime
{
    if (lastTime) {
        [lastTime release];
    }
    lastTime=[[NSDate date] retain];

}
+ (void)AlertError:(NSString *)errStr
{
    if ( !lastTime ||[lastTime timeIntervalSinceNow]<-3) {
        [self setLastTime];
        TKAlert(errStr);
    }
    
    
}
+ (void)showErrorInfo:(NSInteger)errorNum errorType:(ErrorType)type
{
    // 根据dict显示错误信息
    if (errorNum==0) return;
    NSDictionary *dic=[self getErrorDic];
    NSString *key;
    
    switch (type) {
        case ErrorTypeSystem:
            key=[NSString stringWithFormat:@"%d",errorNum];
            break;
        case ErrorTypeLogin:
            key=[NSString stringWithFormat:@"login%d",errorNum];
            break;
        case ErrorTypeSignUp:
            key=[NSString stringWithFormat:@"signup%d",errorNum];
            break;
          
    }
    NSString *errorStr=[dic objectForKey:key];
    if (errorStr) {
        if ((errorNum == 21003 || errorNum == 21008)&&type==ErrorTypeSystem) {
                LoginController *lc = [LoginController sharedInstance];
                [lc destroySession];
                [lc showLoginView];
        } else{
            [self AlertError:errorStr];
        }
        
    } else {
        [self AlertError:[NSString stringWithFormat:@"未知错误,错误代码：%d",errorNum]];
    }
    
}
+ (void)showErrorInfo:(NSInteger)errorNum
{
    [self showErrorInfo:errorNum errorType:ErrorTypeSystem];
}
@end