//
//  RCCallFlutterUtils.h
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/3.
//

#import <Foundation/Foundation.h>
#import <RongCallWrapper/RongCallWrapper.h>

NS_ASSUME_NONNULL_BEGIN

#ifdef __cplusplus
extern "C" {
#endif

void dispatch_to_main_queue(dispatch_block_t block);

#ifdef __cplusplus
}
#endif

@interface RCCallFlutterUtils : NSObject

#pragma mark - enum

+ (RCCallIWUserType)toCallIWUserType:(int)type;

+ (RCCallIWCallType)toCallIWCallType:(int)type;

+ (RCCallIWMediaType)toCallIWMediaType:(int)type;

+ (RCCallIWCamera)toCallIWCamera:(int)type;

+ (RCCallIWNetworkQuality)toCallIWNetworkQuality:(int)type;

+ (RCCallIWViewFitType)toCallIWViewFitType:(int)type;

+ (RCCallIWVideoProfile)toCallIWVideoProfile:(int)type;

+ (RCCallIWCameraOrientation)toCallIWCameraOrientation:(int)type;

+ (RCCallIWDisconnectReason)toCallIWDisconnectReason:(int)type;

+ (RCCallIWBeautyFilter)toCallIWBeautyFilter:(int)filter;

+ (NSInteger)fromCallIWMediaType:(RCCallIWMediaType)type;

+ (NSInteger)fromCallIWCamera:(RCCallIWCamera)camera;

+ (NSInteger)fromCallIWDisconnectReason:(RCCallIWDisconnectReason)reason;

+ (NSInteger)fromCallIWNetworkQuality:(RCCallIWNetworkQuality)quality;

+ (NSInteger)fromCallIWBeautyFilter:(RCCallIWBeautyFilter)filter;

#pragma mark - dic -> oc obj

+ (RCCallIWEngineConfig *)toCallIWEngineConfig:(NSDictionary *)arguments;

+ (RCCallIWPushConfig *)toCallIWPushConfig:(NSDictionary *)arguments;

+ (RCCallIWIOSPushConfig *)toCallIWIOSPushConfig:(NSDictionary *)arguments;

+ (RCCallIWAndroidPushConfig *)toCallIWAndroidPushConfig:(NSDictionary *)arguments;

+ (RCCallIWAudioConfig *)toCallIWAudioConfig:(NSDictionary *)arguments;

+ (RCCallIWVideoConfig *)toCallIWVideoConfig:(NSDictionary *)arguments;

+ (RCCallIWUserProfile *)toCallIWUserProfile:(NSDictionary *)arguments;

+ (RCCallIWBeautyOption *)toCallIWBeautyOption:(NSDictionary *)arguments;

#pragma mark - oc obj -> dic

+ (NSDictionary *)fromCallIWEngineConfig:(RCCallIWEngineConfig *)config;

+ (NSDictionary *)fromCallIWPushConfig:(RCCallIWPushConfig *)config;

+ (NSDictionary *)fromCallIWIOSPushConfig:(RCCallIWIOSPushConfig *)config;

+ (NSDictionary *)fromCallIWAndroidPushConfig:(RCCallIWAndroidPushConfig *)config;

+ (NSDictionary *)fromCallIWAudioConfig:(RCCallIWAudioConfig *)config;

+ (NSDictionary *)fromCallIWVideoConfig:(RCCallIWVideoConfig *)config;

+ (NSDictionary *)fromCallIWUserProfile:(RCCallIWUserProfile *)profile;

+ (NSDictionary *)fromCallIWCallSession:(RCCallIWCallSession *)session;

+ (NSDictionary *)fromCallIWBeautyOption:(RCCallIWBeautyOption *)option;
@end

NS_ASSUME_NONNULL_END
