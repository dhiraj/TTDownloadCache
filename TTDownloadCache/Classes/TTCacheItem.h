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
@property (nonatomic,assign) unsigned long long size;
- (instancetype) initWithKey:(NSString *)key;
@end
