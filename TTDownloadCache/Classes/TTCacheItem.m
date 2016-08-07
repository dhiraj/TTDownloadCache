//
//  TTCacheItem.m
//  Pods
//
//  Created by Dhiraj Gupta on 8/7/16.
//
//

#import "TTCacheItem.h"

@implementation TTCacheItem
- (instancetype) initWithKey:(NSString *)key{
    self = [super init];
    if (self) {
        self.key = key;
        self.useCount = 0;
    }
    return self;
}
- (NSUInteger) hash{
    return self.key.hash;
}
- (BOOL) isEqual:(id)object{
    return [object isKindOfClass:[TTCacheItem class]] && [[(TTCacheItem *)object key] isEqualToString:self.key];
}
@end
