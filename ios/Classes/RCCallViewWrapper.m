//
//  RCCallViewWrapper.m
//  rongcloud_call_wrapper_plugin
//
//  Created by Eric Song on 2021/12/13.
//

#import "RCCallViewWrapper.h"

#import <RongRTCLib/RongRTCLib.h>

#import "RCRTCLogUtility.h"
#import "RCCallFlutterUtils.h"

@interface RCCallIWFlutterView ()

- (CVPixelBufferRef)pixelBufferRef;
- (void)setSize:(CGSize)size;
- (void)destroy;

@end

#pragma mark -

@interface RCCallView () <FlutterTexture, FlutterStreamHandler, RCCallIWFlutterViewDelegate> {
    NSObject<FlutterTextureRegistry> *registry;
    int64_t tid;
    FlutterEventChannel *channel;
    RCCallIWFlutterView *view;
    FlutterEventSink sink;
    
    int rotation;
    int width;
    int height;
    
    BOOL pixelCopyed;
    BOOL viewRendered;
}

@end

@implementation RCCallView

- (instancetype)initWithTextureRegistry:(NSObject<FlutterTextureRegistry> *)registry
                              messenger:(NSObject<FlutterBinaryMessenger> *)messenger {
    self = [super init];
    if (self) {
        self->registry = registry;
        tid = [registry registerTexture:self];
        channel = [FlutterEventChannel
                   eventChannelWithName:[NSString stringWithFormat:@"cn.rongcloud.call.flutter/view:%lld", tid]
                   binaryMessenger:messenger];
        [channel setStreamHandler:self];
        view = [RCCallIWFlutterView create];
        view.textureViewDelegate = self;
        
        rotation = -1;
        width = 0;
        height = 0;
        
        pixelCopyed = false;
        viewRendered = false;
    }
    return self;
}

- (int64_t)textureId {
    return tid;
}

- (RCCallIWFlutterView *)view {
    return self->view;
}

- (void)destroy {
    RongRTCLogI(RongRTCLogFromLib,
                @"FlutterViewDestroy",
                RongRTCLogTaskBegin,
                @"self:%@",
                [self description]);
    view.textureViewDelegate = nil;
    [self->view destroy];
    [channel setStreamHandler:nil];
    [registry unregisterTexture:tid];
    registry = nil;
    RongRTCLogI(RongRTCLogFromLib,
                @"FlutterViewDestroy",
                RongRTCLogTaskResponse,
                @"self:%@",
                [self description]);
}

- (CVPixelBufferRef)copyPixelBuffer {
    if (!pixelCopyed) {
        RongRTCLogI(RongRTCLogFromLib,
                    @"FlutterViewCopyPixelBuffer",
                    RongRTCLogTaskBegin,
                    @"self:%@ start copy pixel buffer.",
                    [self description]);
    }
    CVPixelBufferRef pixelBufferRef = [view pixelBufferRef];
    if (pixelBufferRef != nil) {
        CVBufferRetain(pixelBufferRef);
        if (!pixelCopyed) {
            RongRTCLogI(RongRTCLogFromLib,
                        @"FlutterViewCopyPixelBuffer",
                        RongRTCLogTaskResponse,
                        @"self:%@ copy pixel buffer over.",
                        [self description]);
            pixelCopyed = true;
        }
    } else {
        if (!pixelCopyed) {
            RongRTCLogI(RongRTCLogFromLib,
                        @"RongRTCLogTaskError",
                        RongRTCLogTaskResponse,
                        @"self:%@ start copy pixel buffer.",
                        [self description]);
        }
    }
    return pixelBufferRef;
}

- (FlutterError *)onCancelWithArguments:(id)arguments {
    sink = nil;
    return nil;
}

- (FlutterError *)onListenWithArguments:(id)arguments eventSink:(FlutterEventSink)events {
    sink = events;
    return nil;
}

#pragma mark - RCCallIWFlutterViewDelegate

- (void)firstFrameRendered {
    if (sink != nil) {
        __weak typeof(sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onFirstFrame" forKey:@"event"];
        dispatch_to_main_queue(^{
            typeof(weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
                RongRTCLogI(RongRTCLogFromLib,
                            @"FlutterViewVideoFristFrameRendered",
                            RongRTCLogTaskStatus,
                            @"self:%@ video first frame has rendered.",
                            [self description]);
            }
        });
    }
}

- (void)changeRotation:(int)rotation {
    if (self->rotation != rotation && sink != nil) {
        __weak typeof(sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onRotationChanged" forKey:@"event"];
        [arguments setObject:@(rotation) forKey:@"rotation"];
        self->rotation = rotation;
        dispatch_to_main_queue(^{
            typeof(weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
                RongRTCLogI(RongRTCLogFromLib,
                            @"FlutterViewFrameRotationChanged",
                            RongRTCLogTaskStatus,
                            @"self:%@ has changed frame rotation, rotation:%@.",
                            [self description],
                            @(rotation));
            }
        });
    }
}

- (void)changeSize:(int)width height:(int)height {
    if ((self->width != width || self->height != height) && sink != nil) {
        __weak typeof(sink) weak = sink;
        NSMutableDictionary *arguments = [NSMutableDictionary dictionary];
        [arguments setObject:@"onSizeChanged" forKey:@"event"];
        [arguments setObject:@(width) forKey:@"width"];
        [arguments setObject:@(height) forKey:@"height"];
        [arguments setObject:@(self->rotation) forKey:@"rotation"];
        self->width = width;
        self->height = height;
        dispatch_to_main_queue(^{
            typeof(weak) strong = weak;
            if (strong != nil) {
                strong(arguments);
                RongRTCLogI(RongRTCLogFromLib,
                            @"FlutterViewFrameSizeChanged",
                            RongRTCLogTaskStatus,
                            @"self:%@ has changed frame size, width:%@, height:%@, rotation:%@.",
                            [self description],
                            @(width),
                            @(height),
                            @(self->rotation));
            }
        });
    }
    // TODO 解决底层没调用set size bug
    CVPixelBufferRef pixelBufferRef = [view pixelBufferRef];
    if (pixelBufferRef == nil) {
        [view setSize:CGSizeMake(self->width, self->height)];
    }
}

- (void)frameRendered {
    [registry textureFrameAvailable:tid];
    if (!viewRendered) {
        viewRendered = true;
        RongRTCLogI(RongRTCLogFromLib,
                    @"FlutterViewRendered",
                    RongRTCLogTaskStatus,
                    @"self:%@ view has rendered.",
                    [self description]);
    }
}

#pragma mark -

- (NSString *)description {
    return [NSString
            stringWithFormat:@"<%@: %p, id: %@>", NSStringFromClass([self class]), self, @(tid)];
}

@end

#pragma mark -

@interface RCCallViewWrapper () {
    NSObject<FlutterTextureRegistry> *registry;
    NSObject<FlutterBinaryMessenger> *messenger;
    FlutterMethodChannel *channel;
    NSMutableDictionary<NSNumber *, RCCallView *> *views;
}

@end

static RCCallViewWrapper *instance = nil;
@implementation RCCallViewWrapper

- (instancetype)init {
    self = [super init];
    if (self) {
        views = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        instance = [[RCCallViewWrapper alloc] init];
    });
    return instance;
}

- (RCCallView *)getView:(NSInteger)viewId {
    return [views objectForKey:[NSNumber numberWithInteger:viewId]];
}

- (void)initWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    registry = [registrar textures];
    messenger = [registrar messenger];
    channel = [FlutterMethodChannel methodChannelWithName:@"cn.rongcloud.call.flutter/view"
                                          binaryMessenger:messenger];
    [registrar addMethodCallDelegate:instance channel:channel];
    RongRTCLogI(RongRTCLogFromLib, @"FlutterViewManagerInit", RongRTCLogTaskStatus, @"");
}

- (void)unInit {
    registry = nil;
    messenger = nil;
    for (NSNumber *key in views) {
        RCCallView *view = views[key];
        [view destroy];
    }
    [views removeAllObjects];
    RongRTCLogI(RongRTCLogFromLib, @"FlutterViewManagerUnInit", RongRTCLogTaskStatus, @"");
}

#pragma mark - Dart channel method

- (void)create:(FlutterResult)result {
    RongRTCLogI(RongRTCLogFromLib, @"FlutterViewManagerCallMethodCreate", RongRTCLogTaskBegin, @"");
    int64_t code = -1;
    RCCallView *view = [[RCCallView alloc] initWithTextureRegistry:registry messenger:messenger];
    RongRTCLogI(RongRTCLogFromLib,
                @"FlutterViewManagerCallMethodCreate",
                RongRTCLogTaskStatus,
                @"view:%@",
                [view description]);
    code = [view textureId];
    [views setObject:view forKey:[NSNumber numberWithLongLong:code]];
    dispatch_to_main_queue(^{
        result(@(code));
        RongRTCLogI(RongRTCLogFromLib,
                    @"FlutterViewManagerCallMethodCreate",
                    RongRTCLogTaskResponse,
                    @"view id:%@",
                    @(code));
    });
}

- (void)destroy:(FlutterMethodCall *)call result:(FlutterResult)result {
    RongRTCLogI(RongRTCLogFromLib,
                @"FlutterViewManagerCallMethodDestroy",
                RongRTCLogTaskBegin,
                @"arguments:%@",
                call.arguments);
    RCCallView *view = [views objectForKey:call.arguments];
    if (view != nil) {
        RongRTCLogI(RongRTCLogFromLib,
                    @"FlutterViewManagerCallMethodDestroy",
                    RongRTCLogTaskStatus,
                    @"view:%@",
                    [view description]);
        [view destroy];
        [views removeObjectForKey:call.arguments];
    }
    dispatch_to_main_queue(^{
        result(nil);
        RongRTCLogI(
                    RongRTCLogFromLib, @"FlutterViewManagerCallMethodDestroy", RongRTCLogTaskResponse, @"");
    });
}

#pragma mark - FlutterPlugin delegate

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    RongRTCLogI(RongRTCLogFromLib, @"FlutterViewManagerRegister", RongRTCLogTaskStatus, @"");
    [[RCCallViewWrapper sharedInstance] initWithRegistrar:registrar];
}

- (void)detachFromEngineForRegistrar:(NSObject<FlutterPluginRegistrar> *)registrar {
    RongRTCLogI(RongRTCLogFromLib, @"FlutterViewManagerUnregister", RongRTCLogTaskStatus, @"");
    [self unInit];
}

- (void)handleMethodCall:(FlutterMethodCall *)call result:(FlutterResult)result {
    NSString *method = [call method];
    RongRTCLogI(RongRTCLogFromAPP,
                @"FlutterViewManagerCallMethod",
                RongRTCLogTaskStatus,
                @"method:%@",
                method);
    if ([method isEqualToString:@"create"]) {
        [self create:result];
    } else if ([method isEqualToString:@"destroy"]) {
        [self destroy:call result:result];
    } else {
        dispatch_to_main_queue(^{
            result(FlutterMethodNotImplemented);
        });
    }
}

@end
