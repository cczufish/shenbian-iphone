//
//  SBObject.m
//  shenbian
//
//  Created by MagicYang on 10-12-15.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBObject.h"


@implementation SBObject

@synthesize id;
@synthesize name;
@synthesize children = _children;

- (id)copyWithZone:(NSZone *)zone {
	SBObject *sb = [[[SBObject class] allocWithZone: zone] init];
	sb.id = self.id;
	sb.name = [[name copy] autorelease];
    
    // Deep copy
    for (SBObject *sub in self.children) {
        [sb addChild:sub];
    }
	return sb;
}

- (void)dealloc {
	[name release];
	[_children release];
	[super dealloc];
}

- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[SBObject class]]) {
		return ((SBObject *)object).id == self.id;
	}
	return NO;
}

- (NSString *)description {
    return @"中文";
}

- (void)addChild:(SBObject *)child
{
    if (!_children) {
        _children = [NSMutableArray new];
    }
    
    [_children addObject:child];
}

- (BOOL)hasChildren
{
    return [_children count] > 0;
}

@end



@implementation Area

+ (Area *)allArea
{
	Area *all = [Area new];
	all.id   = AreaAllID;
	all.name = kAllArea;
	return [all autorelease];
}

+ (Area *)allSubArea
{
    Area *allSub = [Area new];
    allSub.id = AreaAllID;
    allSub.name  = kAllSubArea;
    return [allSub autorelease];
}

@end


@implementation SBCategory


+ (SBCategory *)allCategory 
{
	SBCategory *all = [SBCategory new];
	all.id   = CategoryAllID;
	all.name = kAllCategory;
	return [all autorelease];
}

+ (SBCategory *)allSubCategory
{
	SBCategory *allSub = [SBCategory new];
	allSub.id   = CategoryAllID;
	allSub.name = kAllSubCategory;
	return [allSub autorelease];
}

+ (BOOL)belongsToBianMin:(NSInteger)cateId
{
    return cateId > LastHotChannelID;
}

@end
