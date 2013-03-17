//
//  SBTriggleButton.m
//  shenbian
//
//  Created by xhan on 5/8/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "SBTriggleButton.h"


@interface SBTriggleButton (Private)

- (void)_changeStyleToTriggled:(BOOL)isTriggled;

@end

@implementation SBTriggleButton
@synthesize isTriggled;

- (void)_changeStyleToTriggled:(BOOL)triggled
{
    UIImage* seletedImg = triggled ? triggledImg : normalImg;
 //   [self setImage:seletedImg forState:UIControlStateNormal];
    [self setBackgroundImage:seletedImg
                    forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image forStateTriggled:(BOOL)triggled;
{
    if (triggled) {
        if (image != triggledImg) {
            [triggledImg release];
            triggledImg = [image retain];
        }
    }else{
        if (image != normalImg) {
            [normalImg release];
            normalImg = [image retain];
        }
    }
    [self _changeStyleToTriggled:isTriggled];

}


- (void)setIsTriggled:(BOOL)isTriggled_
{
    if (isTriggled != isTriggled_) {
        isTriggled = isTriggled_;
        [self _changeStyleToTriggled:isTriggled];
    }
}

- (void)addTarget:(id)atarget action:(SEL)anaction
{
    target = atarget;
    action = anaction;
}

- (void)onTouched:(id)sender
{
    self.isTriggled = !self.isTriggled;
    [target performSelector:action withObject:self];
}



- (id)init
{
    self = [super init];
    if (self) {
        [super addTarget:self 
                 action:@selector(onTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [super addTarget:self 
                  action:@selector(onTouched:)
        forControlEvents:UIControlEventTouchUpInside];
    }
    return self;    
}

- (void)dealloc
{
    VSSafeRelease(normalImg);
    VSSafeRelease(triggledImg);
    [super dealloc];
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    //do nothing to prevent someone using it to get specify action invoked
    [NSException raise:@"WTF" format:@"干!"];
}
@end
