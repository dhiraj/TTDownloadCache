//
//  TTCacheItem.h
//  Pods
//
//  Created by Dhiraj Gupta on 8/7/16.
//
//

#import <Foundation/Foundation.h>

@interface TTCacheItem : NSObject
@property (nonatomic,strong) NSString * key;
@property (nonatomic,assign) unsigned long long useCount;
- (instancetype) initWithKey:(NSString *)key;
@end
