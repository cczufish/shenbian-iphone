//
//  SBVersionUpdateController.m
//  shenbian
//
//  Created by Leeyan on 11-8-15.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import "SBVersionUpdateController.h"
#import "Utility.h"

@implementation SBVersionUpdateController

+ (id)sharedInstance {
	static id m_instance = nil;
	if (nil == m_instance) {
		@synchronized([self class]) {
			m_instance = [[[self class] alloc] init];
		}
	}
	
	return m_instance;
}

- (void)requestVersionUpdate {
	NSString *url = [NSString stringWithFormat:@"%@/getversionupdate?xda_ver=%@&xda_c=%@", 
					 ROOT_URL, m_xda_ver, m_xda_c];
	CancelRequest(m_request);
	m_request = [[HttpRequest alloc] initWithDelegate:self andExtraData:nil];
	[m_request requestGET:url useStat:YES];
}

- (void)checkUpdateForVersion:(NSString *)xda_ver andChannel:(NSString *)xda_c andDelegate:(id)delegate {
	m_xda_ver = xda_ver;
	m_xda_c = xda_c;
	
	m_delegate = delegate;
	
	[self requestVersionUpdate];
}

- (void)versionUpdateDidFinished {
	if ([m_delegate respondsToSelector:@selector(versionUpdateDidFinished)]) {
		[m_delegate performSelector:@selector(versionUpdateDidFinished)];
	}
}

- (void)requestSucceeded:(HttpRequest *)req {
	NSDictionary *dict = [Utility parseData:req.recievedData];
	NSInteger error = [[dict objectForKey:@"errno"] intValue];
	
	if (req == m_request) {
		if (error != 0) {
			CancelRequest(m_request);
			return;
		}
		
		m_updateStatus	= [[dict objectForKey:@"update"] intValue];
		m_updateUrl		= [[dict objectForKey:@"url"] copy];
		m_detail		= [[dict objectForKey:@"detail"] copy];
		m_lastVersion	= [[dict objectForKey:@"version"] copy];
		
/*	test code 
		m_updateStatus	= kVersionPromptUpdate;
		m_updateUrl		= @"http://itunes.apple.com/cn/app/id418077001?mt=8";
		m_detail		= @"new version";
		m_lastVersion	= @"2.1";
//*/		
		UIAlertView *alert = nil;
		
		switch (m_updateStatus) {
			case kVersionPromptUpdate:
				alert = [[UIAlertView alloc] initWithTitle:@"发现有新版本啦！"
												   message:m_detail
												  delegate:self
										 cancelButtonTitle:@"稍后再说"
										 otherButtonTitles:@"立即更新", nil];
				[alert show];
				break;
			case kVersionForceUpdate:
				alert = [[UIAlertView alloc] initWithTitle:@"发现有新版本啦！"
												   message:m_detail
												  delegate:self
										 cancelButtonTitle:nil
										 otherButtonTitles:@"立即更新", nil];
				[alert show];
				break;
			
			case kVersionDontUpdate:
				[self versionUpdateDidFinished];
				
				break;

			default:
				[self versionUpdateDidFinished];
				
				break;
		}
		[alert release];
		Release(m_request);
		
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	if ((buttonIndex == 1 && alertView.numberOfButtons == 2)
		|| (buttonIndex == 0 && alertView.numberOfButtons == 1)) {
		if ([m_delegate respondsToSelector:@selector(versionWillUpdate:)]) {
			[m_delegate performSelector:@selector(versionWillUpdate:) withObject:m_updateUrl];
		}
		return;
	}
	
	[self versionUpdateDidFinished];
}

- (void)alertViewCancel:(UIAlertView *)alertView {
	
	if ([m_delegate respondsToSelector:@selector(versionUpdateDidFinished)]) {
		[m_delegate performSelector:@selector(versionUpdateDidFinished)];
	}
}

- (void)requestFailed:(HttpRequest *)req {
	if (req == m_request) {
		CancelRequest(m_request);
	}

	if ([m_delegate respondsToSelector:@selector(versionUpdateDidFinished)]) {
		[m_delegate performSelector:@selector(versionUpdateDidFinished)];
	}	
}

- (void)dealloc {
	CancelRequest(m_request);
//	[m_updateUrl release];
//	[m_detail release];
//	[m_lastVersion release];
	
	[super dealloc];
}
@end
