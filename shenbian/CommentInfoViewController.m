    //
//  CommentInfoViewController.m
//  shenbian
//
//  Created by MagicYang on 10-11-23.
//  Copyright 2010 personal. All rights reserved.
//

#import "CommentInfoViewController.h"
#import "CustomCell.h"
#import "CommentInfoView.h"
#import "CommentCellView.h"
#import "SBComment.h"
#import "HttpRequest+Statistic.h"
#import "SBJsonParser.h"
#import "Utility.h"
#import "SBApiEngine.h"
#import "HomeViewController.h"

@implementation CommentInfoViewController

@synthesize delegate;
@synthesize commentList;
@synthesize index;
@synthesize shopId;

- (CommentInfoViewController *)initWithDelegate:(id)del commentList:(NSMutableArray *)list andIndex:(PercentCount)anIndex {
    if ((self = [super init])) {
        self.delegate = del;
		self.commentList = list;
		self.index = anIndex;
    }
    return self;
}

- (void)beginLoading {
    if ([delegate respondsToSelector:@selector(loadMore)]) {
        [delegate performSelector:@selector(loadMore)];
    }
}

- (void)buttonAdjust {
	if (index.current == 0) {
		[preButton setImage:PNGImage(@"button_arrow_up_disable") forState:UIControlStateNormal];
		preButton.enabled = NO;
	} else {
		[preButton setImage:PNGImage(@"button_arrow_up_enable") forState:UIControlStateNormal];
		preButton.enabled = YES;
	}
	
	if (index.current == index.total - 1) {
		[nxtButton setImage:PNGImage(@"button_arrow_down_disable") forState:UIControlStateNormal];
		nxtButton.enabled = NO;
	} else {
		[nxtButton setImage:PNGImage(@"button_arrow_down_enable") forState:UIControlStateNormal];
		nxtButton.enabled = YES;
	}
}

- (void)endLoading {
	[self buttonAdjust];
}

- (SBComment *)currentComment {
	return [commentList objectAtIndex:index.current];
}

- (NSString *)currentTitle {
	return [NSString stringWithFormat:@"%d/%d", index.current + 1, index.total];
}

- (void)viewDidUnload {
	[super viewDidUnload];
	
	Release(tableView);
	Release(navigationButton);
	Release(preButton);
	Release(nxtButton);
}

- (void)loadView {
	[super loadView];
	self.title = [self currentTitle];
	self.view.backgroundColor = [UIColor clearColor];
    
	tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 320, 416) style:UITableViewStyleGrouped];	
	tableView.backgroundColor = [UIColor clearColor];
	tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.separatorColor = [UIColor colorWithRed:0.880 green:0.880 blue:0.880 alpha:1];
	tableView.delegate = self;
	tableView.dataSource = self;
	[self addSubview:tableView];
	
	navigationButton = [[UIImageView alloc] initWithImage:PNGImage(@"button_segmentedcontrol")];
	navigationButton.frame = CGRectMake(240, 7, 73, 30);
	navigationButton.userInteractionEnabled = YES;
	
	preButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	preButton.frame = CGRectMake(0, 0, 35, 29);
	[preButton addTarget:self action:@selector(previousPage:) forControlEvents:UIControlEventTouchUpInside];
	nxtButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	nxtButton.frame = CGRectMake(37, 0, 35, 29);
	[nxtButton addTarget:self action:@selector(nextPage:) forControlEvents:UIControlEventTouchUpInside];
	[self buttonAdjust];
	
	[navigationButton addSubview:preButton];
	[navigationButton addSubview:nxtButton];
	[self.navigationController.navigationBar addSubview:navigationButton];
}


- (void)viewWillAppear:(BOOL)animated {
	if (![navigationButton superview]) {
		[self.navigationController.navigationBar addSubview:navigationButton];
	}
}

- (void)viewDidAppear:(BOOL)animated {
	Stat(@"cmtdetail_into");
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[navigationButton removeFromSuperview];
}

- (void)dealloc {
	CancelRequest(voteRequest);
	[commentList release];
	[preButton release];
	[nxtButton release];
	[navigationButton release];
	[shopId release];
    [super dealloc];
}

- (void)useful {	
	CancelRequest(voteRequest);
	SBComment *cmt = [self currentComment];
	
	// http://10.23.245.185:8090/client/user/0/voteuse
	NSString *url = [NSString stringWithFormat:@"%@/user/0/voteuse", ROOT_URL];
	voteRequest = [[HttpRequest alloc] initWithDelegate:self andExtraData:NUM(0)];
	NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
							cmt.cmtId, @"cmt_id", nil];
	[voteRequest requestPOST:url parameters:params useStat:YES];
}

- (void)pageChanged {
	[tableView reloadData];
	self.title = [self currentTitle];
	[self buttonAdjust];
}

- (void)previousPage:(id)sender {
	index.current--;
	[self pageChanged];
}

- (void)nextPage:(id)sender {
	if (index.current == [commentList count] - 1) {
		[self beginLoading];
		[self buttonAdjust];
		return;
	}
	
	index.current++;
	[self pageChanged];
}


#pragma mark -
#pragma mark Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [CommentInfoView heightOfCell:[self currentComment]];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
	return 60;
}

- (UITableViewCell *)tableView:(UITableView *)table cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [table dequeueReusableCellWithIdentifier:CellIdentifier];
    
	if (cell == nil) {
		cell = [[[CustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
		CommentInfoView *cellView = [[CommentInfoView alloc] initWithFrame:cell.frame];
		[cellView addIconBtnTarget:self sel:@selector(onBtnUserIconPressed:)];
		((CustomCell *)cell).cellView = cellView;
		[cellView release];
	}
	
	[((CustomCell *)cell) setDataModel:[self currentComment]];
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	cell.backgroundColor = [UIColor whiteColor];
    
    return cell;
}

#pragma mark -
- (void)onBtnUserIconPressed:(NSString*)userID
{
	if (userID) {
		HomeViewController* homeVC = [[HomeViewController alloc] initWithUserID:userID];
		[self.navigationController pushViewController:homeVC animated:YES];
		[homeVC release];
	}
	VSLog(@"%@",userID);
}


#pragma mark -
#pragma mark Table view delegate
- (void)tableView:(UITableView *)table didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	
}


#pragma mark -
#pragma mark HttpRequestDelegate
- (void)requestFailed:(HttpRequest*)req error:(NSError*)error {
    Release(voteRequest);
}

- (void)requestSucceeded:(HttpRequest*)req {
	NSError *error = nil;
    NSDictionary* dict = [SBApiEngine parseHttpData:req.recievedData error:&error];
    if (error) {
        [self requestFailed:req error:error];
        return;
    }
    
    if ([[dict objectForKey:@"errNo"] intValue] == 0) {
        [self currentComment].usefulCount += 1;
    }
		
    Release(voteRequest);
}


@end
