//
//  NSDictionary+RCCall.m
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import "NSDictionary+RCCall.h"

@implementation NSDictionary (RCCall)

- (nullable id)rccall_getValue:(Class)vClass forKey:(NSString *)key {
    return [self rccall_getValue:vClass forKey:key defaultValue:nil];
}

- (nullable id)rccall_getValue:(Class)vClass forKey:(NSString *)key defaultValue:(nullable id)defaultValue {
    
    if (![self.allKeys containsObject:key]) {
        return defaultValue;
    }
    
    id value = [self valueForKey:key];
    
    if (!value || ![value isKindOfClass:vClass]) {
        return defaultValue;
    }
    
    return value;
}

- (BOOL)rccall_getBool:(NSString *)key {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(NO)] boolValue];
}

- (BOOL)rccall_getBool:(NSString *)key defaultValue:(BOOL)defaultValue {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(defaultValue)] boolValue];
}

- (NSInteger)rccall_getInteger:(NSString *)key {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(0)] integerValue];
}

- (NSInteger)rccall_getInteger:(NSString *)key defaultValue:(NSInteger)defaultValue {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(defaultValue)] integerValue];
}

- (CGFloat)rccall_getFloat:(NSString *)key {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(0)] floatValue];
}

- (CGFloat)rccall_getFloat:(NSString *)key defaultValue:(CGFloat)defaultValue {
    return [[self rccall_getValue:[NSNumber class] forKey:key defaultValue:@(defaultValue)] floatValue];
}

- (nullable NSNumber *)rccall_getNumber:(NSString *)key {
    return [self rccall_getValue:[NSNumber class] forKey:key defaultValue:nil];
}

- (nullable NSNumber *)rccall_getNumber:(NSString *)key defaultValue:(nullable NSNumber *)defaultValue {
    return [self rccall_getValue:[NSNumber class] forKey:key defaultValue:defaultValue];
}

- (nullable NSString *)rccall_getString:(NSString *)key {
    return [self rccall_getValue:[NSString class] forKey:key defaultValue:nil];
}

- (nullable NSString *)rccall_getString:(NSString *)key defaultValue:(nullable NSString *)defaultValue {
    return [self rccall_getValue:[NSString class] forKey:key defaultValue:defaultValue];
}

- (nullable NSDictionary *)rccall_getDictionary:(NSString *)key {
    return [self rccall_getValue:[NSDictionary class] forKey:key defaultValue:[NSDictionary new]];
}

- (nullable NSArray *)rccall_getArray:(NSString *)key {
    return [self rccall_getValue:[NSArray class] forKey:key defaultValue:nil];
}


@end
