//
//  MyClass.m
//  shenbian
//
//  Created by xhan on 5/10/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "LoginInfo.h"
#import "SFHFKeychainUtils.h"

@implementation LoginInfo
@dynamic login;

#define LoginInfoPassword @"SvrLoginInfoPassword"


- (void)setupDefaults
{
	//implement by subclass, this method will only be invoked once
}

+ (void)setupRoutes
{
    [self setupProperty:@"login" withType:PLSettingTypeObject];
}


- (void)setPassword:(NSString *)password
{
    if (self.login && ![self.login isEmpty]) {
        [SFHFKeychainUtils storeUsername:self.login andPassword:password forServiceName:LoginInfoPassword updateExisting:YES error:nil];
    }

}

- (NSString*)password
{
    if (self.login && ![self.login isEmpty]) {
        return [SFHFKeychainUtils getPasswordForUsername:self.login andServiceName:LoginInfoPassword error:nil];
    }
    
    return nil; 
}

@end
