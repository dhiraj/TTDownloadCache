//
//  TTDownloadCache.h
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import <Foundation/Foundation.h>

typedef void (^DataHandler)(NSData * data ,NSURLRequest * originalRequest, BOOL fromCache);

@interface TTDownloadCache : NSObject
- (void) dataFromURLRequest:(NSURLRequest *)request withHandler:(DataHandler)blockName;
- (void) cancelRequest:(NSURLRequest *)request;
@end
