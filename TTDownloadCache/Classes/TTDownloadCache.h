//
//  TTDownloadCache.h
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import <Foundation/Foundation.h>

typedef void (^DataHandler)(NSData * data ,NSString * originalURL, BOOL fromCache);

@interface TTDownloadCache : NSObject
- (instancetype) initWithMaxSize:(unsigned long long)byteSize;
- (NSString *) dataFromURL:(NSString *)request withHandler:(DataHandler)blockName useMemCache:(BOOL)useCache;
- (void) cancelAllRequestsWithURL:(NSString *)url;
- (void) cancelRequestWithCancelToken:(NSString *)token;
@end
