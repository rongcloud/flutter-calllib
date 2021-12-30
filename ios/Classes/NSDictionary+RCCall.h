//
//  NSDictionary+RCCall.h
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (RCCall)

- (nullable id)rccall_getValue:(Class)vClass forKey:(NSString *)key;
- (nullable id)rccall_getValue:(Class)vClass
                        forKey:(NSString *)key
                  defaultValue:(nullable id)defaultValue;

- (BOOL)rccall_getBool:(NSString *)key;
- (BOOL)rccall_getBool:(NSString *)key defaultValue:(BOOL)defaultValue;

- (NSInteger)rccall_getInteger:(NSString *)key;
- (NSInteger)rccall_getInteger:(NSString *)key defaultValue:(NSInteger)defaultValue;

- (CGFloat)rccall_getFloat:(NSString *)key;
- (CGFloat)rccall_getFloat:(NSString *)key defaultValue:(CGFloat)defaultValue;

- (nullable NSNumber *)rccall_getNumber:(NSString *)key;
- (nullable NSNumber *)rccall_getNumber:(NSString *)key
                           defaultValue:(nullable NSNumber *)defaultValue;

- (nullable NSString *)rccall_getString:(NSString *)key;
- (nullable NSString *)rccall_getString:(NSString *)key
                           defaultValue:(nullable NSString *)defaultValue;

- (nullable NSDictionary *)rccall_getDictionary:(NSString *)key;

- (nullable NSArray *)rccall_getArray:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
