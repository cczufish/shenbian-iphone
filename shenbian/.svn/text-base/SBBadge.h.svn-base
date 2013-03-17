//
//  SBBadge.h
//  shenbian
//
//  Created by xhan on 5/18/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HttpRequest;
@interface SBBadge : NSObject {
    UIImage *picImage;
    HttpRequest *request;
	NSString *promoInfo;
}

- (id)initWithRemoteDict:(NSDictionary*)dict;

- (void)fetchPicByURL:(NSString*)url;

@property(nonatomic,copy) NSString* bid;
@property(nonatomic,copy) NSString* name;
@property(nonatomic,copy) NSString* picURL;
@property(nonatomic,retain) UIImage *picImage;
@property(nonatomic,copy) NSString* description;
@property(nonatomic,assign) BOOL      isPromo;
@property(nonatomic,copy) NSString* promoInfo;
@property(nonatomic,copy) NSString* picBigURL;
@property(nonatomic,copy) NSString* userId;
@property(nonatomic,assign) NSInteger useableCount;

@end
