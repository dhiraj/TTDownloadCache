//
//  TTDownloadCache.h
//  Pods
//
//  Created by Dhiraj Gupta on 8/6/16.
//
//

#import <Foundation/Foundation.h>

typedef void (^DictionaryResponseHandler)(NSDictionary * dictionary, BOOL fromCache);

@interface TTDownloadCache : NSObject
- (void) dictionaryResponseFromURLRequest:(NSURLRequest *)request withHandler:(DictionaryResponseHandler)blockName;
@end
