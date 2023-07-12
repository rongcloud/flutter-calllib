//
//  RCCallFlutterUtils.m
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/3.
//

#import "RCCallFlutterUtils.h"

#import "NSDictionary+RCCall.h"
#import "NSArray+RCCall.h"

#ifndef _RCReturn_
#define _RCReturn_

#define RCReturnValue(f, ...) \
if (f) {                    \
return __VA_ARGS__;       \
}                           \
(void)0

#define RCReturnIfNeed(f, ...) RCReturnValue(f, __VA_ARGS__)

#endif

#ifndef _RCCallAssert_
#define _RCCallAssert_

BOOL isDEBUG(void) {
#if DEBUG
    return YES;
#endif
    return NO;
}

#define RCCallAssert(obj, cls)                                       \
if (!obj) {                                                        \
if (isDEBUG()) {                                                 \
NSLog(@"Failed to convert %@, Arguments cannot be nil!", cls); \
assert(0);                                                     \
}                                                                \
return nil;                                                      \
}                                                                  \
(void)0

#endif

#ifdef __cplusplus
extern "C" {
#endif
    
    void dispatch_to_main_queue(dispatch_block_t block) {
        if ([[NSThread currentThread] isMainThread]) {
            block();
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    }
    
#ifdef __cplusplus
}
#endif

/*
 * 视频默认配置
 */
static RCCallIWVideoProfile kDefaultCallIWVideoProfile = RCCallIW_VIDEO_PROFILE_720_1280;
static RCCallIWCamera kDefaultCallIWCamera = RCCallIWCameraFront;
static RCCallIWCameraOrientation kDefaultCallIWCameraOrientation = RCCallIWCameraOrientationPortrait;

NSInteger _findEnum(int index, NSArray<NSNumber *> *enums) {
    if (index < 0 || index >= enums.count) {
        return enums.firstObject.integerValue;
    }
    return enums[index].integerValue;
}

NSInteger _findEnumIndex(NSNumber *key, NSDictionary<NSNumber *, NSNumber *> *dictionary) {
    if (![dictionary.allKeys containsObject:key]) {
        return NSNotFound;
    }
    return [dictionary[key] integerValue];
}

#pragma mark - RCCallIWUserType
NSArray *_getCallIWUserType(void) {
    static NSArray *userTypeArray;
    if (!userTypeArray) {
        userTypeArray = @[ @(RCCallIWUserTypeNormal), @(RCCallIWUserTypeObserver) ];
    }
    return userTypeArray;
}

NSArray *_getCallIWCallType(void) {
    static NSArray *callTypeArray;
    if (!callTypeArray) {
        callTypeArray = @[ @(RCCallIWCallTypeSingle), @(RCCallIWCallTypeGroup) ];
    }
    return callTypeArray;
}

NSArray *_getCallIWMediaType(void) {
    static NSArray *mediaTypeArray;
    if (!mediaTypeArray) {
        mediaTypeArray = @[ @(RCCallIWMediaTypeAudio), @(RCCallIWMediaTypeAudioVideo) ];
    }
    return mediaTypeArray;
}

NSArray *_getCallIWCamera(void) {
    static NSArray *cameraArray;
    if (!cameraArray) {
        cameraArray = @[ @(RCCallIWCameraNone), @(RCCallIWCameraFront), @(RCCallIWCameraBack) ];
    }
    return cameraArray;
}

NSArray *_getCallIWNetworkQuality(void) {
    static NSArray *networkQualityArray;
    if (!networkQualityArray) {
        networkQualityArray = @[
            @(RCCallIWNetworkQualityUnknown),
            @(RCCallIWNetworkQualityExcellent),
            @(RCCallIWNetworkQualityGood),
            @(RCCallIWNetworkQualityPoor),
            @(RCCallIWNetworkQualityBad),
            @(RCCallIWNetworkQualityTerrible)
        ];
    }
    return networkQualityArray;
}

NSArray *_getCallIWViewFitType(void) {
    static NSArray *viewFitTypeArray;
    if (!viewFitTypeArray) {
        viewFitTypeArray =
        @[ @(RCCallIWViewFitTypeFill), @(RCCallIWViewFitTypeCover), @(RCCallIWViewFitTypeCenter) ];
    }
    return viewFitTypeArray;
}

NSArray *_getCallIWVideoProfile(void) {
    static NSArray *videoProfileArray;
    if (!videoProfileArray) {
        videoProfileArray = @[
            @(RCCallIW_VIDEO_PROFILE_144_256),
            @(RCCallIW_VIDEO_PROFILE_240_240),
            @(RCCallIW_VIDEO_PROFILE_240_320),
            @(RCCallIW_VIDEO_PROFILE_360_480),
            @(RCCallIW_VIDEO_PROFILE_360_640),
            @(RCCallIW_VIDEO_PROFILE_480_640),
            @(RCCallIW_VIDEO_PROFILE_480_720),
            @(RCCallIW_VIDEO_PROFILE_720_1280),
            @(RCCallIW_VIDEO_PROFILE_1080_1920),
            @(RCCallIW_VIDEO_PROFILE_144_256_HIGH),
            @(RCCallIW_VIDEO_PROFILE_240_240_HIGH),
            @(RCCallIW_VIDEO_PROFILE_240_320_HIGH),
            @(RCCallIW_VIDEO_PROFILE_360_480_HIGH),
            @(RCCallIW_VIDEO_PROFILE_360_640_HIGH),
            @(RCCallIW_VIDEO_PROFILE_480_640_HIGH),
            @(RCCallIW_VIDEO_PROFILE_480_720_HIGH),
            @(RCCallIW_VIDEO_PROFILE_720_1280_HIGH),
            @(RCCallIW_VIDEO_PROFILE_1080_1920_HIGH)
        ];
    }
    return videoProfileArray;
}

NSArray *_getCallIWCameraOrientation(void) {
    static NSArray *cameraOrientationArray;
    if (!cameraOrientationArray) {
        cameraOrientationArray = @[
            @(RCCallIWCameraOrientationPortrait),
            @(RCCallIWCameraOrientationPortraitUpsideDown),
            @(RCCallIWCameraOrientationLandscapeRight),
            @(RCCallIWCameraOrientationLandscapeLeft)
        ];
    }
    return cameraOrientationArray;
}

NSInteger fromCallIWCameraOrientation(RCCallIWCameraOrientation orientation) {
    return _findEnumIndex(@(orientation), [_getCallIWCameraOrientation() indexDictionary]);
}

NSInteger fromCallIWVideoProfile(RCCallIWVideoProfile profile) {
    return _findEnumIndex(@(profile), [_getCallIWVideoProfile() indexDictionary]);
}

NSInteger fromCallIWUserType(RCCallIWUserType type) {
    return _findEnumIndex(@(type), [_getCallIWUserType() indexDictionary]);
}
NSInteger fromCallIWCallType(RCCallIWCallType type) {
    return _findEnumIndex(@(type), [_getCallIWCallType() indexDictionary]);
}

@implementation RCCallFlutterUtils

#pragma mark - enum

+ (RCCallIWUserType)toCallIWUserType:(int)type {
    return _findEnum(type, _getCallIWUserType());
}

+ (RCCallIWCallType)toCallIWCallType:(int)type {
    return _findEnum(type, _getCallIWCallType());
}

+ (RCCallIWMediaType)toCallIWMediaType:(int)type {
    return _findEnum(type, _getCallIWMediaType());
}

+ (RCCallIWCamera)toCallIWCamera:(int)type {
    return _findEnum(type, _getCallIWCamera());
}

+ (RCCallIWNetworkQuality)toCallIWNetworkQuality:(int)type {
    return _findEnum(type, _getCallIWNetworkQuality());
}

+ (RCCallIWViewFitType)toCallIWViewFitType:(int)type {
    return _findEnum(type, _getCallIWViewFitType());
}

+ (RCCallIWVideoProfile)toCallIWVideoProfile:(int)type {
    return _findEnum(type, _getCallIWVideoProfile());
}

+ (RCCallIWCameraOrientation)toCallIWCameraOrientation:(int)type {
    return _findEnum(type, _getCallIWCameraOrientation());
    ;
}

// todo(check): 暴露给js层的枚举值按照约定是从 0 开始，所有在这里做加 1、减 1 的转换操作
+ (RCCallIWDisconnectReason)toCallIWDisconnectReason:(int)type {
    return (RCCallIWDisconnectReason)(type + 1);
}

+ (NSInteger)fromCallIWMediaType:(RCCallIWMediaType)type {
    return _findEnumIndex(@(type), [_getCallIWMediaType() indexDictionary]);
}

+ (NSInteger)fromCallIWCamera:(RCCallIWCamera)camera {
    return _findEnumIndex(@(camera), [_getCallIWCamera() indexDictionary]);
}

+ (NSInteger)fromCallIWDisconnectReason:(RCCallIWDisconnectReason)reason {
    return (int)reason - 1;
}

+ (NSInteger)fromCallIWNetworkQuality:(RCCallIWNetworkQuality)quality {
    return _findEnumIndex(@(quality), [_getCallIWNetworkQuality() indexDictionary]);
}

#pragma mark - dic -> oc obj

+ (RCCallIWEngineConfig *)toCallIWEngineConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWEngineConfig");
    
    RCCallIWEngineConfig *config = [[RCCallIWEngineConfig alloc] init];
    config.enableCallSummary = [arguments rccall_getBool:@"enableCallSummary" defaultValue:NO];
    return config;
}

+ (RCCallIWPushConfig *)toCallIWPushConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWPushConfig");
    
    RCCallIWPushConfig *config = [[RCCallIWPushConfig alloc] init];
    config.disableTitle = [arguments rccall_getBool:@"disableTitle"];
    config.title = [arguments rccall_getString:@"title"];
    config.content = [arguments rccall_getString:@"content"];
    config.data = [arguments rccall_getString:@"data"];
    config.forceShowDetailContent = [arguments rccall_getBool:@"forceShowDetailContent"];
    config.templateId = [arguments rccall_getString:@"templateId"];
    config.iOSConfig = [self toCallIWIOSPushConfig:[arguments rccall_getDictionary:@"iOSConfig"]];
    config.androidConfig = [self toCallIWAndroidPushConfig:[arguments rccall_getDictionary:@"androidConfig"]];
    return config;
}

+ (RCCallIWIOSPushConfig *)toCallIWIOSPushConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWIOSPushConfig");
    
    RCCallIWIOSPushConfig *config = [[RCCallIWIOSPushConfig alloc] init];
    config.threadId = [arguments rccall_getString:@"threadId"];
    config.category = [arguments rccall_getString:@"category"];
    config.apnsCollapseId = [arguments rccall_getString:@"apnsCollapseId"];
    config.richMediaUri = [arguments rccall_getString:@"richMediaUri"];
    return config;
}

+ (RCCallIWAndroidPushConfig *)toCallIWAndroidPushConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWAndroidPushConfig");
    
    RCCallIWAndroidPushConfig *config = [[RCCallIWAndroidPushConfig alloc] init];
    config.notificationId = [arguments rccall_getString:@"notificationId"];
    config.channelIdMi = [arguments rccall_getString:@"channelIdMi"];
    config.channelIdHW = [arguments rccall_getString:@"channelIdHW"];
    config.channelIdOPPO = [arguments rccall_getString:@"channelIdOPPO"];
    NSNumber *vivo = [arguments rccall_getNumber:@"typeVivo" defaultValue:nil];
    if (vivo != nil) {
        config.typeVivo = [NSString stringWithFormat:@"%d", [vivo intValue]];
    }
    config.collapseKeyFCM = [arguments rccall_getString:@"collapseKeyFCM"];
    config.imageUrlFCM = [arguments rccall_getString:@"imageUrlFCM"];
    return config;
}

+ (RCCallIWAudioConfig *)toCallIWAudioConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWAudioConfig");
    
    RCCallIWAudioConfig *config = [[RCCallIWAudioConfig alloc] init];
    return config;
}

+ (RCCallIWVideoConfig *)toCallIWVideoConfig:(NSDictionary *)arguments {
    RCCallAssert(arguments, @"RCCallIWVideoConfig");
    
    NSNumber *profile = [arguments rccall_getNumber:@"profile"];
    NSNumber *defaultCamera = [arguments rccall_getNumber:@"defaultCamera"];
    NSNumber *cameraOrientation = [arguments rccall_getNumber:@"cameraOrientation"];
    bool isPreviewMirror = [arguments rccall_getBool:@"isPreviewMirror" defaultValue:YES];
    
    RCCallIWVideoConfig *config = [[RCCallIWVideoConfig alloc] init];
    config.profile = profile ? [self toCallIWVideoProfile:[profile intValue]] : kDefaultCallIWVideoProfile;
    config.defaultCamera = defaultCamera ? [self toCallIWCamera:[defaultCamera intValue]] : kDefaultCallIWCamera;
    config.cameraOrientation = cameraOrientation ?
    [self toCallIWCameraOrientation:[cameraOrientation intValue]] :
    kDefaultCallIWCameraOrientation;
    config.isPreviewMirror = isPreviewMirror;
    return config;
}

+ (RCCallIWUserProfile *)toCallIWUserProfile:(NSDictionary *)arguments {
    return nil;
}

#pragma mark - oc obj -> dic

+ (NSDictionary *)fromCallIWEngineConfig:(RCCallIWEngineConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@(config.enableCallSummary) forKey:@"enableCallSummary"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWPushConfig:(RCCallIWPushConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@(config.disableTitle) forKey:@"disableTitle"];
    [dictionary setValue:config.title forKey:@"title"];
    [dictionary setValue:config.content forKey:@"content"];
    [dictionary setValue:config.data forKey:@"data"];
    [dictionary setValue:@(config.forceShowDetailContent) forKey:@"forceShowDetailContent"];
    [dictionary setValue:config.templateId forKey:@"templateId"];
    [dictionary setValue:[self fromCallIWIOSPushConfig:config.iOSConfig] forKey:@"iOSConfig"];
    [dictionary setValue:[self fromCallIWAndroidPushConfig:config.androidConfig]
                  forKey:@"androidConfig"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWIOSPushConfig:(RCCallIWIOSPushConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:config.threadId forKey:@"threadId"];
    [dictionary setValue:config.category forKey:@"category"];
    [dictionary setValue:config.apnsCollapseId forKey:@"apnsCollapseId"];
    [dictionary setValue:config.richMediaUri forKey:@"richMediaUri"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWAndroidPushConfig:(RCCallIWAndroidPushConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:config.notificationId forKey:@"notificationId"];
    [dictionary setValue:config.channelIdMi forKey:@"channelIdMi"];
    [dictionary setValue:config.channelIdHW forKey:@"channelIdHW"];
    [dictionary setValue:config.channelIdOPPO forKey:@"channelIdOPPO"];
    [dictionary setValue:config.typeVivo forKey:@"typeVivo"];
    [dictionary setValue:config.collapseKeyFCM forKey:@"collapseKeyFCM"];
    [dictionary setValue:config.imageUrlFCM forKey:@"imageUrlFCM"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWAudioConfig:(RCCallIWAudioConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    return dictionary;
}

+ (NSDictionary *)fromCallIWVideoConfig:(RCCallIWVideoConfig *)config {
    RCReturnIfNeed(!config, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@(fromCallIWVideoProfile(config.profile)) forKey:@"profile"];
    [dictionary setValue:@([self fromCallIWCamera:config.defaultCamera]) forKey:@"defaultCamera"];
    [dictionary setValue:@(fromCallIWCameraOrientation(config.cameraOrientation))
                  forKey:@"cameraOrientation"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWUserProfile:(RCCallIWUserProfile *)profile {
    RCReturnIfNeed(!profile, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@(fromCallIWUserType(profile.userType)) forKey:@"userType"];
    [dictionary setValue:@([self fromCallIWMediaType:profile.mediaType]) forKey:@"mediaType"];
    [dictionary setValue:profile.userId forKey:@"userId"];
    [dictionary setValue:profile.mediaId forKey:@"mediaId"];
    [dictionary setValue:@(profile.enableCamera) forKey:@"enableCamera"];
    [dictionary setValue:@(profile.enableMicrophone) forKey:@"enableMicrophone"];
    return dictionary;
}

+ (NSDictionary *)fromCallIWCallSession:(RCCallIWCallSession *)session {
    RCReturnIfNeed(!session, nil);
    
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    [dictionary setValue:@(fromCallIWCallType(session.callType)) forKey:@"callType"];
    [dictionary setValue:@([self fromCallIWMediaType:session.mediaType]) forKey:@"mediaType"];
    [dictionary setValue:session.callId forKey:@"callId"];
    [dictionary setValue:session.targetId forKey:@"targetId"];
    [dictionary setValue:session.sessionId forKey:@"sessionId"];
    [dictionary setValue:session.extra forKey:@"extra"];
    [dictionary setValue:@(session.startTime) forKey:@"startTime"];
    [dictionary setValue:@(session.connectedTime) forKey:@"connectedTime"];
    [dictionary setValue:@(session.endTime) forKey:@"endTime"];
    [dictionary setValue:[self fromCallIWUserProfile:session.caller] forKey:@"caller"];
    [dictionary setValue:[self fromCallIWUserProfile:session.inviter] forKey:@"inviter"];
    [dictionary setValue:[self fromCallIWUserProfile:session.mine] forKey:@"mine"];
    [dictionary setValue:[session.users mapTo:^id _Nonnull(RCCallIWUserProfile *_Nonnull obj) {
        return [RCCallFlutterUtils fromCallIWUserProfile:obj];
    }] forKey:@"users"];
    return dictionary;
}

@end
