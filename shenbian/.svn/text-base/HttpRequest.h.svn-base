//
//  HttpRequest.h
//  Personal
//
//  Created by MagicYang on 10-3-30.
//  Copyright 2010 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol HttpRequestDelegate;

@class HttpRequestParameter;

@interface HttpRequest : NSObject {
	id					delegate;
	int					statusCode;
	id					extraData;
	NSURLConnection*	urlConnection;
	NSMutableData *		recievedData;
	NSDictionary *		headerFields;
	NSTimer				*timeoutTimer;
	BOOL				usingTimeout;
	BOOL				noCheckResponse;
	NSURLRequest*		URLRequest;
	BOOL                usingCache; // Flag to decide whether cache received data or not
}
@property (assign) id delegate;
@property (assign) int statusCode;
@property (retain) id extraData;
@property (retain) NSMutableData *recievedData;
@property (retain) NSDictionary *headerFields;
@property (retain) NSTimer* timeoutTimer;
@property (assign) BOOL usingTimeout;
@property (assign) BOOL noCheckResponse;
@property (retain) NSURLRequest* URLRequest;
@property (assign) NSStringEncoding postEncoding;


- (id)initWithDelegate:(id)del andExtraData:(id)data;

+ (NSString *)makeURL:(NSString *)baseUrl withOrderedParams:(NSArray *)params;
+ (NSString *)makeURL:(NSString *)baseUrl withParams:(NSDictionary *)params;
+ (NSString *)makeParamtersString:(NSDictionary *)paramters;
+ (NSString *)makeBody:(NSDictionary *)params;


- (void)request:(NSURLRequest*)aRequest;

- (void)requestGET:(NSString *)url; // Default request no cache used
- (void)requestGET:(NSString *)url useCache:(BOOL)isCache; // You can pass YES to isCache parameter to cache recived data
- (void)requestGET:(NSString *)url parameters:(NSDictionary *)params;
- (void)requestGET:(NSString *)url parameters:(NSDictionary *)params username:(NSString *)username password:(NSString *)password;
- (void)requestGET:(NSString *)url parameters:(NSDictionary *)params headerFields:(NSDictionary *)header;
- (void)requestGET:(NSString *)url username:(NSString *)username password:(NSString *)password;

- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params;
- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params username:(NSString *)username password:(NSString *)password;
- (void)requestPOST:(NSString *)url body:(NSString *)body;
- (void)requestPOST:(NSString *)url body:(NSString *)body username:(NSString *)username password:(NSString *)password;
- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params headerFields:(NSDictionary *)header;

- (void)requestMethod:(NSString *)method url:(NSString *)url parameters:(NSDictionary *)params;

- (void)cancel;

@end


@protocol HttpRequestDelegate

@required
- (void)requestSucceeded:(HttpRequest *)request;
- (void)requestFailed:(HttpRequest *)request error:(NSError *)error;
@optional
- (void)request:(HttpRequest *)request willSendRequest:(NSURLRequest *)newRequest redirectResponse:(NSURLResponse *)redirectResponse;
- (void)request:(HttpRequest *)request recivedDataPercent:(CGFloat)percent;

@end


@interface HttpRequestParameter : NSObject {
	NSString *name;
	id		  value;
}

@property(retain) NSString *name;
@property(retain) id value;

+ (id)parameterWithName:(NSString *)_name value:(id)_value;

@end


@interface HttpRequestCacheCenter : NSObject {
	NSMutableDictionary *dataDictionary; // Store dictionary
}

+ (HttpRequestCacheCenter *)sharedInstance;

- (void)cacheData:(NSData *)data forURL:(NSString *)url;
- (NSData *)dataForURL:(NSString *)url;
- (void)distoryCacheData;

@end
