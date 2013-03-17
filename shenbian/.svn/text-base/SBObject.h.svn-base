//
//  SBObject.h
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBObject : NSObject<NSCopying> {
	NSInteger id;
	NSString *name;
    NSMutableArray *_children;
}

@property(nonatomic, assign) NSInteger id;
@property(nonatomic, retain) NSString *name;
@property(nonatomic, readonly) NSArray *children;

- (void)addChild:(SBObject *)child;
- (BOOL)hasChildren;

@end



// -------------- Area --------------
#define kAllArea      @"全部区域"
#define kAllSubArea   @"全部"
#define AreaAllID     0
@interface Area : SBObject {

}

+ (Area *)allArea;
+ (Area *)allSubArea;

@end



// -------------- Category --------------
#define kAllCategory    @"全部分类"
#define kAllSubCategory @"全部"
#define CategoryAllID      0
#define CategoryBianMinID -1
#define LastHotChannelID 20007

@interface SBCategory : SBObject 
+ (SBCategory *)allCategory;
+ (SBCategory *)allSubCategory;
+ (BOOL)belongsToBianMin:(NSInteger)cateId;

@end
