//
//  NSArray+RCCall.m
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import "NSArray+RCCall.h"

@implementation NSArray (RCCall)

- (NSDictionary *)indexDictionary {
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [dictionary setObject:@(idx) forKey:obj];
    }];
    return dictionary;
}

- (NSArray *)mapTo:(id (^)(id obj))block {
    NSMutableArray *newArray = [NSMutableArray arrayWithCapacity:self.count];
    [self enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL *_Nonnull stop) {
        [newArray addObject:block(obj)];
    }];
    return newArray;
}

@end
