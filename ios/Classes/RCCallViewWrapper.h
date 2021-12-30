//
//  RCCallViewWrapper.h
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/13.
//

#import <Foundation/Foundation.h>
#import <Flutter/Flutter.h>

NS_ASSUME_NONNULL_BEGIN

@class RCCallIWFlutterView;

@interface RCCallView : NSObject

- (RCCallIWFlutterView *)view;

@end

@interface RCCallViewWrapper : NSObject <FlutterPlugin>

+ (instancetype)sharedInstance;

- (RCCallView *)getView:(NSInteger)viewId;

@end

NS_ASSUME_NONNULL_END
