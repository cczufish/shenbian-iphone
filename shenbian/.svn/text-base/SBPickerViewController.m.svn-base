    //
//  SBPickerViewController.m
//  shenbian
//
//  Created by MagicYang on 10-12-17.
//  Copyright 2010 personal. All rights reserved.
//

#import "SBPickerViewController.h"


@implementation SBPickerViewController

@synthesize delegate;
@synthesize hasCancelButton;
@synthesize hasTabbar;

- (id)initWithDelegate:(id)del {
	if ((self = [super init])) {
		self.delegate = del;
	}
	return self;
}

- (void)dealloc {
	[tableView release];
	[loadingView release];
	CancelRequest(request);
    [super dealloc];
}

- (void)loadView {
	[super loadView];
	
	self.navigationItem.leftBarButtonItem = nil;
	
	UIImageView *bg = [[UIImageView alloc] initWithImage:PNGImage(@"home_bg")];
	bg.frame = CGRectMake(0, 0, 320, 416);
	[self addSubview:bg];
	[bg release];
	
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, hasTabbar ? 367 : 418) style:UITableViewStyleGrouped];
	tableView.delegate = self;
	tableView.dataSource = self;
	tableView.backgroundColor = [UIColor clearColor];
	[self addSubview:tableView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// New model navigationController must implement navigationItem after loadView()
	if (hasCancelButton) {
		self.navigationItem.leftBarButtonItem = [SBNavigationController buttonItemWithTitle:@"取消" andAction:@selector(cancel:) inDelegate:self];
	} else {
		[super setBackTitle:@"返回"];
	}
	
	// Show loading view
	if (!loadingView) {
		loadingView = [[LoadingView alloc] initWithFrame:CGRectZero andMessage:nil];
	}
	[self.view addSubview:loadingView];
	
	// Load data source by subclass
	[self _loadDataSource];
}

- (void)cancel:(id)sender {
	[delegate pickerControllerCancelled:self];
}


#pragma mark -
#pragma mark Subclass implemented
- (NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section {
	// Override by subclass if needed
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	// Override by subclass if needed
	return nil;
}

- (void)_loadDataSource {
	// Override by subclass if needed
}

- (void)_dataSourceReady {
	[loadingView removeFromSuperview];
	[tableView reloadData];
}


@end
