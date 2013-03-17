//
//  SBAlbum.h
//  shenbian
//
//  Created by MagicYang on 4/27/11.
//  Copyright 2011 百度. All rights reserved.
//

#import <Foundation/Foundation.h>


#define PHOTO_COUNT_PER_ROW 3

@class HttpRequest;
@interface SBPhoto : NSObject {
    NSString *photoId;
    NSString *title;
    NSString *url;
    UIImage *img;
    NSTimeInterval date;
    
    HttpRequest *request;
}

@property(nonatomic, retain) NSString *photoId;
@property(nonatomic, retain) NSString *title;
@property(nonatomic, retain) NSString *url;
@property(nonatomic, retain) UIImage *img;
@property(nonatomic, assign) NSTimeInterval date;

- (SBPhoto *)initWithDictionary:(NSDictionary *)dict;

@end


@interface SBAlbumRow : NSObject {
    NSMutableArray *albumRow;
}

- (BOOL)addPhoto:(SBPhoto *)photo;
- (SBPhoto *)photoAtColumn:(NSInteger)index;
- (NSArray *)albumRow;

@end