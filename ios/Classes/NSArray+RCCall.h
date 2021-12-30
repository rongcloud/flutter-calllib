//
//  NSArray+RCCall.h
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray <ObjectType>(RCCall)

- (NSDictionary *)indexDictionary;

- (NSArray *)mapTo:(id (^)(ObjectType obj))block;

@end

NS_ASSUME_NONNULL_END
