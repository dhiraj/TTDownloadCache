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
- (NSString *) dataFromURL:(NSString *)request withHandler:(DataHandler)blockName;
- (void) cancelAllRequestsWithURL:(NSString *)url;
- (void) cancelRequestWithCancelToken:(NSString *)token;
@end
