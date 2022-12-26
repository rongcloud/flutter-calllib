//
//  RCCallEngineWrapper.m
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/2.
//

#import "RCCallEngineWrapper.h"

#import "RCCallDefine.h"
#import "RCCallFlutterUtils.h"
#import "NSDictionary+RCCall.h"
#import "RCCallViewWrapper.h"
#import <RongIMLibCore/RongIMLibCore.h>

NSString* RCCall_SetEngineConfig = @"setEngineConfig";
NSString* RCCall_SetPushConfig = @"setPushConfig";
NSString* RCCall_SetAudioConfig = @"setAudioConfig";
NSString* RCCall_SetVideoConfig = @"setVideoConfig";
NSString* RCCall_StartCall = @"startCall";
NSString* RCCall_GetCurrentCallSession = @"getCurrentCallSession";
NSString* RCCall_Accept = @"accept";
NSString* RCCall_Hangup = @"hangup";
NSString* RCCall_EnableMicrophone = @"enableMicrophone";
NSString* RCCall_IsEnableMicrophone = @"isEnableMicrophone";
NSString* RCCall_EnableSpeaker = @"enableSpeaker";
NSString* RCCall_IsEnableSpeaker = @"isEnableSpeaker";
NSString* RCCall_EnableCamera = @"enableCamera";
NSString* RCCall_IsEnableCamera = @"isEnableCamera";
NSString* RCCall_CurrentCamera = @"currentCamera";
NSString* RCCall_SwitchCamera = @"switchCamera";
NSString* RCCall_SetVideoView = @"setVideoView";
NSString* RCCall_ChangeMediaType = @"changeMediaType";

@protocol RCCallIWViewDelegate;

@interface RCCallIWEngine ()
+ (void)setEnableMulitPlatform:(BOOL)enable;
- (void)setVideoViewWithViewDelegate:(NSObject<RCCallIWViewDelegate>*)view userId:(NSString*)userId;
@end

@interface RCCallEngineWrapper () <RCCallIWEngineDelegate>

@property(nonatomic, strong) FlutterMethodChannel* channel;
@property(nonatomic, strong) RCCallIWEngine* iwEngine;

- (void)addChannelWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar;

@end

@implementation RCCallEngineWrapper

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static RCCallEngineWrapper* _instance = nil;
    dispatch_once(&onceToken, ^{
        _instance = [[RCCallEngineWrapper alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        [RCCallIWEngine setEnableMulitPlatform:YES];
        _iwEngine = [RCCallIWEngine sharedInstance];
        [_iwEngine setEngineDelegate:self];
    }
    return self;
}

- (void)dealloc {
    self.iwEngine = nil;
}

- (NSInteger)setLocalVideoProcessedDelegate:(id<RCCallIWSampleBufferVideoFrameDelegate>)delegate {
    NSInteger code = -1;
    if (_iwEngine) {
        [_iwEngine setLocalVideoProcessedDelegate:delegate];
        code = 0;
    }
    return code;
}

#pragma mark - FlutterPlugin

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [[RCCallEngineWrapper sharedInstance] addChannelWithRegistrar:registrar];
}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSString* method = [call method];
    if ([@"getPlatformVersion" isEqualToString:call.method]) {
        [self getPlatformVersion:call result:result];
    } else if ([method isEqualToString:@"create"]) {
        [self create:call result:result];
    } else if ([method isEqualToString:RCCall_SetEngineConfig]) {
        [self setEngineConfig:call result:result];
    } else if ([method isEqualToString:RCCall_SetPushConfig]) {
        [self setPushConfig:call result:result];
    } else if ([method isEqualToString:RCCall_StartCall]) {
        [self startCall:call result:result];
    } else if ([method isEqualToString:RCCall_SetAudioConfig]) {
        [self setAudioConfig:call result:result];
    } else if ([method isEqualToString:RCCall_SetVideoConfig]) {
        [self setVideoConfig:call result:result];
    } else if ([method isEqualToString:RCCall_GetCurrentCallSession]) {
        [self getCurrentCallSession:call result:result];
    } else if ([method isEqualToString:RCCall_Accept]) {
        [self accept:call result:result];
    } else if ([method isEqualToString:RCCall_Hangup]) {
        [self hangup:call result:result];
    } else if ([method isEqualToString:RCCall_EnableMicrophone]) {
        [self enableMicrophone:call result:result];
    } else if ([method isEqualToString:RCCall_IsEnableMicrophone]) {
        [self isEnableMicrophone:call result:result];
    } else if ([method isEqualToString:RCCall_EnableSpeaker]) {
        [self enableSpeaker:call result:result];
    } else if ([method isEqualToString:RCCall_IsEnableSpeaker]) {
        [self isEnableSpeaker:call result:result];
    } else if ([method isEqualToString:RCCall_EnableCamera]) {
        [self enableCamera:call result:result];
    } else if ([method isEqualToString:RCCall_IsEnableCamera]) {
        [self isEnableCamera:call result:result];
    } else if ([method isEqualToString:RCCall_CurrentCamera]) {
        [self currentCamera:call result:result];
    } else if ([method isEqualToString:RCCall_SwitchCamera]) {
        [self switchCamera:call result:result];
    } else if ([method isEqualToString:RCCall_SetVideoView]) {
        [self setVideoView:call result:result];
    } else if ([method isEqualToString:RCCall_ChangeMediaType]) {
        [self changeMediaType:call result:result];
    } else {
        NSLog(@"call.flutter plugin not support method: %@", method);
    }
}

#pragma mark - RCCallIWEngineDelegate

- (void)didReceiveCall:(RCCallIWCallSession*)session {
    NSDictionary* dic = [RCCallFlutterUtils fromCallIWCallSession:session];
    NSMutableDictionary* arguments = [NSMutableDictionary dictionaryWithDictionary:dic];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:didReceiveCall" arguments:arguments];
    });
}

- (void)callDidConnect {
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:callDidConnect" arguments:nil];
    });
}

- (void)callDidDisconnect:(RCCallIWDisconnectReason)reason {
    NSInteger intReason = [RCCallFlutterUtils fromCallIWDisconnectReason:reason];
    NSMutableDictionary* dic =
    [NSMutableDictionary dictionaryWithDictionary:@{@"reason" : @(intReason)}];
    
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:callDidDisconnect" arguments:dic];
    });
}

- (void)remoteUserDidJoin:(RCCallIWUserProfile*)user {
    NSDictionary* dic = [RCCallFlutterUtils fromCallIWUserProfile:user];
    NSMutableDictionary* arguments = [NSMutableDictionary dictionaryWithDictionary:dic];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidJoin" arguments:arguments];
    });
}

- (void)remoteUserDidLeave:(NSString*)userId reason:(RCCallIWDisconnectReason)reason {
    int intReason = (int)reason;
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"reason" : @(intReason), @"id" : userId}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidLeave" arguments:dic];
    });
}

#pragma mark - RCCallIWEngineDelegate optional


- (void)didEnableCamera:(RCCallIWCamera)camera enable:(BOOL)enable {
    NSInteger cameraIndex = [RCCallFlutterUtils fromCallIWCamera:camera];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"camera" : @(cameraIndex), @"enabled" : @(enable)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:didEnableCamera" arguments:dic];
    });
}

- (void)didSwitchCamera:(RCCallIWCamera)camera {
    NSInteger cameraIndex = [RCCallFlutterUtils fromCallIWCamera:camera];
    
    NSMutableDictionary* dic =
    [NSMutableDictionary dictionaryWithDictionary:@{@"camera" : @(cameraIndex)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:didSwitchCamera" arguments:dic];
    });
}

- (void)callDidError:(RCCallIWErrorCode)code {
    NSMutableDictionary* dic =
    [NSMutableDictionary dictionaryWithDictionary:@{@"errorCode" : @((int)code)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:callDidError" arguments:dic];
    });
}

- (void)callDidMake {
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:callDidMake" arguments:nil];
    });
}

- (void)remoteUserDidRing:(NSString*)userId {
    NSMutableDictionary* dic = [NSMutableDictionary dictionaryWithDictionary:@{@"userId" : userId}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidRing" arguments:dic];
    });
}

- (void)remoteUserDidInvite:(NSString*)userId mediaType:(RCCallIWMediaType)mediaType {
    NSInteger mediaTypeIndex = [RCCallFlutterUtils fromCallIWMediaType:(int)mediaType];
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"userId" : userId, @"mediaType" : @(mediaTypeIndex)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidInvite" arguments:dic];
    });
}

- (void)remoteUserDidChangeMediaType:(RCCallIWUserProfile*)user
                           mediaType:(RCCallIWMediaType)mediaType {
    NSDictionary* userProfile = [RCCallFlutterUtils fromCallIWUserProfile:user];
    NSInteger mediaTypeIndex = [RCCallFlutterUtils fromCallIWMediaType:mediaType];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"user" : userProfile, @"mediaType" : @(mediaTypeIndex)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidChangeMediaType" arguments:dic];
    });
}

- (void)remoteUserDidChangeMicrophoneState:(RCCallIWUserProfile*)user enable:(BOOL)enable {
    NSDictionary* userProfile = [RCCallFlutterUtils fromCallIWUserProfile:user];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"user" : userProfile, @"enabled" : @(enable)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidChangeMicrophoneState" arguments:dic];
    });
}

- (void)remoteUserDidChangeCameraState:(RCCallIWUserProfile*)user enable:(BOOL)enable {
    NSDictionary* userProfile = [RCCallFlutterUtils fromCallIWUserProfile:user];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"user" : userProfile, @"enabled" : @(enable)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:remoteUserDidChangeCameraState" arguments:dic];
    });
}

- (void)user:(RCCallIWUserProfile*)user networkQuality:(RCCallIWNetworkQuality)quality {
    NSDictionary* userProfile = [RCCallFlutterUtils fromCallIWUserProfile:user];
    NSInteger qualityIndex = [RCCallFlutterUtils fromCallIWNetworkQuality:quality];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"user" : userProfile, @"quality" : @(qualityIndex)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:networkQuality" arguments:dic];
    });
}

- (void)user:(RCCallIWUserProfile*)user audioVolume:(int)volume {
    NSDictionary* userProfile = [RCCallFlutterUtils fromCallIWUserProfile:user];
    
    NSMutableDictionary* dic = [NSMutableDictionary
                                dictionaryWithDictionary:@{@"user" : userProfile, @"volume" : @(volume)}];
    __weak typeof(_channel) weak = _channel;
    dispatch_to_main_queue(^{
        typeof(weak) strong = weak;
        [strong invokeMethod:@"engine:audioVolume" arguments:dic];
    });
}

#pragma mark - RCCallIWEngine API

- (void)getPlatformVersion:(FlutterMethodCall*)call result:(FlutterResult)result {
    dispatch_to_main_queue(^{
        result([@"iOS " stringByAppendingString:[[UIDevice currentDevice] systemVersion]]);
    });
}

- (void)create:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSLog(@"ios: call create.");
    dispatch_to_main_queue(^{
        result(nil);
    });
}

- (void)setEngineConfig:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        RCCallIWEngineConfig* engineConfig = [RCCallFlutterUtils toCallIWEngineConfig:arguments];
        [_iwEngine setEngineConfig:engineConfig];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setPushConfig:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        NSDictionary* pushDic = (NSDictionary*)arguments[@"push"];
        NSDictionary* hangupPushDic = (NSDictionary*)arguments[@"hangupPush"];
        RCCallIWPushConfig* pushConfig = [RCCallFlutterUtils toCallIWPushConfig:pushDic];
        RCCallIWPushConfig* hangupPushConfig = [RCCallFlutterUtils toCallIWPushConfig:hangupPushDic];
        BOOL useApple = [arguments[@"useApple"] boolValue];
        
        [_iwEngine setPushConfig:pushConfig
                hangupPushConfig:hangupPushConfig
              enableApplePushKit:useApple];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)startCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        NSString* targetId = arguments[@"targetId"];
        if ([targetId isEqualToString:[RCCoreClient sharedCoreClient].currentUserInfo.userId]) {
            dispatch_to_main_queue(^{
                result(nil);
                return;
            });
        }
        RCCallIWMediaType type = [RCCallFlutterUtils toCallIWMediaType:[arguments[@"mediaType"] intValue]];
        id extra = arguments[@"extra"];
        RCCallIWCallSession* session = nil;
        if ([extra isKindOfClass:[NSNull class]]) {
            session = [_iwEngine startCall:targetId type:type];
        } else {
            session = [_iwEngine startCall:targetId type:type extra:extra];
        }
        if (session) {
            NSDictionary* dic = [RCCallFlutterUtils fromCallIWCallSession:session];
            dispatch_to_main_queue(^{
                result(dic);
            });
            return;
        }
    }
    
    dispatch_to_main_queue(^{
        result(nil);
    });
}

- (void)setAudioConfig:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        RCCallIWAudioConfig* audioConfig = [RCCallFlutterUtils toCallIWAudioConfig:arguments];
        [_iwEngine setAudioConfig:audioConfig];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setVideoConfig:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        RCCallIWVideoConfig* videoConfig = [RCCallFlutterUtils toCallIWVideoConfig:arguments];
        [_iwEngine setVideoConfig:videoConfig];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)getCurrentCallSession:(FlutterMethodCall*)call result:(FlutterResult)result {
    RCCallIWCallSession* session = [_iwEngine getCurrentCallSession];
    if (session) {
        NSDictionary* dic = [RCCallFlutterUtils fromCallIWCallSession:session];
        dispatch_to_main_queue(^{
            result(dic);
        });
        return;
    }
    
    dispatch_to_main_queue(^{
        result(nil);
    });
}

- (void)accept:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_iwEngine accept];
    dispatch_to_main_queue(^{
        result(@(0));
    });
}

- (void)hangup:(FlutterMethodCall*)call result:(FlutterResult)result {
    [_iwEngine hangup];
    dispatch_to_main_queue(^{
        result(@(0));
    });
}

- (void)enableMicrophone:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        BOOL enabled = [arguments[@"enabled"] boolValue];
        [_iwEngine enableMicrophone:enabled];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)isEnableMicrophone:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL enabled = [_iwEngine isEnableMicrophone];
    dispatch_to_main_queue(^{
        result(@(enabled));
    });
}

- (void)enableSpeaker:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        BOOL enabled = [arguments[@"enabled"] boolValue];
        [_iwEngine enableSpeaker:enabled];
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)isEnableSpeaker:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL enabled = [_iwEngine isEnableSpeaker];
    dispatch_to_main_queue(^{
        result(@(enabled));
    });
}

- (void)enableCamera:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        BOOL enabled = [arguments[@"enabled"] boolValue];
        NSNumber* camera = arguments[@"camera"];
        if (camera && ![camera isEqual:[NSNull null]]) {
            RCCallIWCamera enumCamera = [RCCallFlutterUtils toCallIWCamera:[camera intValue]];
            [_iwEngine enableCamera:enabled camera:enumCamera];
        } else {
            [_iwEngine enableCamera:enabled];
        }
        
        code = 0;
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)isEnableCamera:(FlutterMethodCall*)call result:(FlutterResult)result {
    BOOL enabled = [_iwEngine isEnableCamera];
    dispatch_to_main_queue(^{
        result(@(enabled));
    });
}

- (void)currentCamera:(FlutterMethodCall*)call result:(FlutterResult)result {
    RCCallIWCamera camera = [_iwEngine currentCamera];
    NSInteger code = [RCCallFlutterUtils fromCallIWCamera:camera];
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)switchCamera:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = 0;
    [_iwEngine switchCamera];
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)setVideoView:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        NSString* userId = [arguments rccall_getString:@"userId"];
        NSNumber* view = [arguments rccall_getNumber:@"view" defaultValue:nil];
        RCCallView* origin = [[RCCallViewWrapper sharedInstance] getView:[view integerValue]];
        if (origin) {
            [_iwEngine setVideoViewWithViewDelegate:(NSObject<RCCallIWViewDelegate>*)[origin view]
                                             userId:userId];
            code = 0;
        } else {
            [_iwEngine setVideoViewWithViewDelegate:nil
                                             userId:userId];
            code = 0;
        }
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}

- (void)changeMediaType:(FlutterMethodCall*)call result:(FlutterResult)result {
    NSInteger code = -1;
    NSDictionary* arguments = (NSDictionary*)call.arguments;
    if (arguments) {
        NSNumber* value = [arguments rccall_getNumber:@"mediaType" defaultValue:nil];
        if (value) {
            RCCallIWMediaType type = [RCCallFlutterUtils toCallIWMediaType:[value intValue]];
            [_iwEngine changeMediaType:type];
            code = 0;
        }
    }
    
    dispatch_to_main_queue(^{
        result(@(code));
    });
}
#pragma mark -

- (void)addChannelWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    if (!self.channel) {
        self.channel = [FlutterMethodChannel methodChannelWithName:@"cn.rongcloud.call.flutter/engine"
                                                   binaryMessenger:[registrar messenger]];
    }
    
    [registrar addMethodCallDelegate:self channel:self.channel];
}
@end
