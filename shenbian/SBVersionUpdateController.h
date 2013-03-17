//
//  SBVersionUpdateController.h
//  shenbian
//
//	版本更新
//
//  Created by Leeyan on 11-8-15.
//  Copyright 2011 ÁôæÂ∫¶. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequest+Statistic.h"

typedef enum {
	kVersionDontUpdate		= 1,
	kVersionPromptUpdate	= 2,
	kVersionForceUpdate		= 3
} VersionUpdateStatus;

@interface SBVersionUpdateController : NSObject <UIAlertViewDelegate>{
	NSString *m_xda_ver;		//	版本号
	NSString *m_xda_c;			//	渠道号
	
	NSString *m_updateUrl;		//	升级地址
	NSString *m_detail;			//	详细信息
	NSString *m_lastVersion;	//	最新版本号
	VersionUpdateStatus m_updateStatus;	//	更新值
	
	HttpRequest *m_request;
	
	id m_delegate;
}

+ (id)sharedInstance;
- (void)checkUpdateForVersion:(NSString *)xda_ver andChannel:(NSString *)xda_c andDelegate:(id)delegate;

@end
