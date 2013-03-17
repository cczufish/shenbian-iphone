//
//  HttpRequest+FilePost.m
//  shenbian
//
//  Created by xhan on 5/9/11.
//  Copyright 2011 百度. All rights reserved.
//

#import "HttpRequest+FilePost.h"
#import "HttpRequest.h"

@implementation HttpRequest (FilePost)

- (void)requestPOST:(NSString *)url parameters:(NSDictionary *)params fileName:(NSString*)fileName data:(NSData*)data
{
    [self cancel];
//    NSMutableURLRequest *request = [self makeRequest:url];
    NSMutableURLRequest *request = [self performSelector:@selector(makeRequest:) withObject:url]   ;
    [request setHTTPMethod:@"POST"];
    
    NSString* boundary = @"someonewillwin";
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
    

    
    NSMutableString* postString = [NSMutableString string];
    
    [postString appendFormat:@"--%@\r\n",boundary];
    
    // post datas
    NSString *endItemBoundary = [NSString stringWithFormat:@"\r\n--%@\r\n",boundary];
//    NSUInteger i=0;
    NSArray* keys = [params allKeys];
    for (id key in keys) {
        [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
//		[postString appendString:[params objectForKey:key]];
        [postString appendFormat:@"%@",[params objectForKey:key]];
//        i ++;
//        if (i!= [keys count]) {
            [postString appendString:endItemBoundary];
  //      }
    }
    
    [postString appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileName,fileName];
    [postString appendFormat:@"Content-Type: image/jpg\r\n\r\n"];
    
//    VSLog(@"%@", postString);
    
    NSMutableData* body = [NSMutableData dataWithData:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:data];
    
    //end
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPBody:body];
//    [request setValue:[NSString stringWithFormat:@"%d", [body length]] forHTTPHeaderField:@"Content-Length"];
    
    self.URLRequest = request;
	
	urlConnection = [[NSURLConnection alloc] initWithRequest:self.URLRequest delegate:self startImmediately:YES];
}

@end
