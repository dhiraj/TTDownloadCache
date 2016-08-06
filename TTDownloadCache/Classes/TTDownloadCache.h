//
//  TTDownloadCache.h
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import <Foundation/Foundation.h>

typedef void (^JSONDataHandler)(NSData * data, BOOL fromCache);

@interface TTDownloadCache : NSObject
- (void) JSONDataFromURLRequest:(NSURLRequest *)request withHandler:(JSONDataHandler)blockName;
@end
