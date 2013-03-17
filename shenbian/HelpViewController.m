//
//  HelpViewController.m
//  shenbian
//
//  Created by MagicYang on 3/23/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "HelpViewController.h"


@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
- (void)loadView
{
    [super loadView];
    
    self.title = @"帮助";
    self.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"返回" andAction:@selector(back:) inDelegate:self];
    
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 416)];
    imgView.image = PNGImage(@"help_gps");
    [self.view addSubview:imgView];
    [imgView release];
}

- (void)back:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

@end
