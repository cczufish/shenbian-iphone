//
//  HttpRequest+Statistic.h
//  shenbian
//
//  Created by MagicYang on 7/5/11.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest.h"


@interface HttpRequest (Statistic)

- (void)requestGET:(NSString *)url useStat:(BOOL)flag;
- (void)requestGET:(NSString *)url useCache:(BOOL)isCache useStat:(BOOL)flag;
- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params useStat:(BOOL)flag;

@end
