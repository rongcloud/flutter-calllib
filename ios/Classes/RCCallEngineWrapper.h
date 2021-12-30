//
//  RCCallEngineWrapper.h
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import <Flutter/Flutter.h>

#import <RongCallWrapper/RongCallWrapper.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallEngineWrapper : NSObject <FlutterPlugin>

+ (instancetype)sharedInstance;

- (NSInteger)setLocalVideoProcessedDelegate:(id<RCCallIWSampleBufferVideoFrameDelegate> _Nullable)delegate;

@end

NS_ASSUME_NONNULL_END
