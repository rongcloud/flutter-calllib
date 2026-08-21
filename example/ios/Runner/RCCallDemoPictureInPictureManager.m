#import "RCCallDemoPictureInPictureManager.h"

#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import <CoreMedia/CoreMedia.h>
#import <CoreVideo/CoreVideo.h>
#import <CoreVideo/CVPixelBufferIOSurface.h>
#import <IOSurface/IOSurfaceRef.h>
#import <RongCallLib/RongCallLib.h>

NSString *const RCCallDemoPictureInPictureChannelName =
    @"cn.rongcloud.call.demo/picture_in_picture";

static const NSUInteger RCCallDemoPictureInPictureStartRetryLimit = 30;
static const NSTimeInterval RCCallDemoPictureInPictureStartRetryDelay = 0.1;

@interface RCCallDemoPictureInPictureVideoView : UIView

@property(nonatomic, readonly) AVSampleBufferDisplayLayer *displayLayer;

@end


@implementation RCCallDemoPictureInPictureVideoView

+ (Class)layerClass {
    return AVSampleBufferDisplayLayer.class;
}

- (AVSampleBufferDisplayLayer *)displayLayer {
    return (AVSampleBufferDisplayLayer *)self.layer;
}

@end


@interface RCCallDemoPictureInPictureManager ()
    <RCCallSessionDelegate, AVPictureInPictureControllerDelegate> {
    CVPixelBufferPoolRef _pixelBufferPool;
    size_t _pixelBufferPoolWidth;
    size_t _pixelBufferPoolHeight;
    OSType _pixelBufferPoolFormat;
    OSType _lastUnsupportedPixelFormat;
    NSTimeInterval _lastUnsupportedPixelFormatLogTime;
}

@property(nonatomic, weak) UIView *sourceView;
@property(nonatomic, strong) FlutterMethodChannel *channel;
@property(nonatomic, weak) RCCallSession *registeredSession;

@property(nonatomic, strong) NSLock *captureStateLock;
@property(nonatomic, assign) BOOL desiredEnabled;
@property(nonatomic, assign) NSUInteger generation;
@property(nonatomic, copy, nullable) NSString *selectedUserId;
@property(nonatomic, assign) BOOL frameTaskPending;

@property(nonatomic, strong) dispatch_queue_t frameQueue;

@property(nonatomic, strong, nullable) AVPictureInPictureController *pictureInPictureController;
@property(nonatomic, strong, nullable) UIViewController *contentViewController;
@property(nonatomic, strong, nullable) RCCallDemoPictureInPictureVideoView *videoView;
@property(nonatomic, assign) BOOL receivedFirstFrame;
@property(nonatomic, assign) BOOL startPending;
@property(nonatomic, assign) BOOL startRetryActive;
@property(nonatomic, assign) BOOL cleanupPending;

@end


@implementation RCCallDemoPictureInPictureManager

- (instancetype)initWithSourceView:(UIView *)sourceView
                           channel:(FlutterMethodChannel *)channel {
    self = [super init];
    if (self) {
        _sourceView = sourceView;
        _channel = channel;
        _captureStateLock = [[NSLock alloc] init];
        _frameQueue = dispatch_queue_create(
            "cn.rongcloud.call.demo.picture-in-picture.frames",
            DISPATCH_QUEUE_SERIAL);
    }
    return self;
}

- (void)dealloc {
    [self.registeredSession removeDelegate:self];
    if (_pixelBufferPool != nil) {
        CVPixelBufferPoolRelease(_pixelBufferPool);
        _pixelBufferPool = nil;
    }
}

#pragma mark - Public

- (void)setEnabled:(BOOL)enabled result:(FlutterResult)result {
    if (![NSThread isMainThread]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setEnabled:enabled result:result];
        });
        return;
    }

    if (!enabled) {
        [self disableWithReason:@"disabled" notify:YES];
        result(@NO);
        return;
    }

    if (@available(iOS 15.0, *)) {
        if (![AVPictureInPictureController isPictureInPictureSupported]) {
            result([FlutterError errorWithCode:@"pip_not_supported"
                                       message:@"Picture in Picture is not supported on this device."
                                       details:nil]);
            return;
        }

        RCCallSession *session = [RCCallClient sharedRCCallClient].currentCallSession;
        if (session == nil) {
            result([FlutterError errorWithCode:@"no_active_call"
                                       message:@"An active CallLib session is required."
                                       details:nil]);
            return;
        }

        if ([self isCaptureEnabled] && self.registeredSession == session &&
            self.pictureInPictureController != nil) {
            result(@YES);
            return;
        }

        [self disableWithReason:@"reconfigured" notify:NO];
        if (![self preparePictureInPictureController]) {
            result([FlutterError errorWithCode:@"pip_initialization_failed"
                                       message:@"Unable to initialize Picture in Picture."
                                       details:nil]);
            return;
        }

        [self.captureStateLock lock];
        self.desiredEnabled = YES;
        self.generation += 1;
        self.selectedUserId = nil;
        self.frameTaskPending = NO;
        [self.captureStateLock unlock];

        self.receivedFirstFrame = NO;
        self.startPending = NO;
        self.startRetryActive = NO;
        self.cleanupPending = NO;
        self.registeredSession = session;
        [session addDelegate:self];

        [self notifyStateChangedWithReason:@"enabled" error:nil];
        result(@YES);
    } else {
        result([FlutterError errorWithCode:@"pip_not_supported"
                                   message:@"Picture in Picture requires iOS 15 or later."
                                   details:nil]);
    }
}

- (NSDictionary<NSString *, id> *)state {
    if (![NSThread isMainThread]) {
        __block NSDictionary<NSString *, id> *state = nil;
        dispatch_sync(dispatch_get_main_queue(), ^{
            state = [self state];
        });
        return state;
    }

    BOOL supported = NO;
    if (@available(iOS 15.0, *)) {
        supported = [AVPictureInPictureController isPictureInPictureSupported];
    }

    [self.captureStateLock lock];
    BOOL enabled = self.desiredEnabled;
    NSString *userId = self.selectedUserId;
    [self.captureStateLock unlock];

    BOOL active = self.pictureInPictureController.isPictureInPictureActive;
    NSMutableDictionary<NSString *, id> *state = [@{
        @"supported" : @(supported),
        @"enabled" : @(enabled),
        @"active" : @(active),
        @"starting" : @(self.startPending || self.startRetryActive),
        @"waitingForFrame" : @(enabled && !self.receivedFirstFrame)
    } mutableCopy];
    if (userId.length > 0) {
        state[@"userId"] = userId;
    }
    return state;
}

- (void)disable {
    if (![NSThread isMainThread]) {
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf disable];
        });
        return;
    }
    [self disableWithReason:@"disabled" notify:YES];
}

#pragma mark - RCCallSessionDelegate

- (void)processRemoteVideoFrame:(CVPixelBufferRef)pixelBuffer userId:(NSString *)userId {
    if (pixelBuffer == nil || userId.length == 0) {
        return;
    }

    [self.captureStateLock lock];
    if (!self.desiredEnabled) {
        [self.captureStateLock unlock];
        return;
    }
    if (self.selectedUserId == nil) {
        self.selectedUserId = userId;
    }
    if (![self.selectedUserId isEqualToString:userId] || self.frameTaskPending) {
        [self.captureStateLock unlock];
        return;
    }
    self.frameTaskPending = YES;
    NSUInteger generation = self.generation;
    CVPixelBufferRetain(pixelBuffer);
    [self.captureStateLock unlock];

    dispatch_async(self.frameQueue, ^{
        CVPixelBufferRef compatiblePixelBuffer =
            [self copyDisplayCompatiblePixelBuffer:pixelBuffer];
        CVPixelBufferRelease(pixelBuffer);

        CMSampleBufferRef sampleBuffer = nil;
        size_t width = 0;
        size_t height = 0;
        if (compatiblePixelBuffer != nil) {
            width = CVPixelBufferGetWidth(compatiblePixelBuffer);
            height = CVPixelBufferGetHeight(compatiblePixelBuffer);
            sampleBuffer = [self createSampleBuffer:compatiblePixelBuffer];
            CVPixelBufferRelease(compatiblePixelBuffer);
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            BOOL validGeneration = NO;
            [self.captureStateLock lock];
            BOOL currentGeneration =
                self.desiredEnabled && self.generation == generation;
            validGeneration = currentGeneration &&
                [self.selectedUserId isEqualToString:userId];
            if (currentGeneration) {
                self.frameTaskPending = NO;
            }
            [self.captureStateLock unlock];

            if (!validGeneration || sampleBuffer == nil || self.videoView == nil) {
                if (sampleBuffer != nil) {
                    CFRelease(sampleBuffer);
                }
                return;
            }

            AVSampleBufferDisplayLayer *displayLayer = self.videoView.displayLayer;
            BOOL requiresFlush = NO;
            if (@available(iOS 14.0, *)) {
                requiresFlush = displayLayer.requiresFlushToResumeDecoding;
            }
            if (requiresFlush ||
                displayLayer.status == AVQueuedSampleBufferRenderingStatusFailed) {
                [displayLayer flush];
            }
            [displayLayer enqueueSampleBuffer:sampleBuffer];
            CFRelease(sampleBuffer);

            if (width > 0 && height > 0) {
                self.contentViewController.preferredContentSize =
                    CGSizeMake((CGFloat)width, (CGFloat)height);
            }
            self.receivedFirstFrame = YES;
            [self beginStartRetryForGeneration:generation];
        });
    });
}

- (void)callDidDisconnect {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self disableWithReason:@"callDisconnected" notify:YES];
    });
}

- (void)remoteUserDidLeft:(NSString *)userId reason:(RCCallDisconnectReason)reason {
    if (userId.length == 0) {
        return;
    }

    [self.captureStateLock lock];
    BOOL selectedUserLeft = [self.selectedUserId isEqualToString:userId];
    if (selectedUserLeft) {
        self.selectedUserId = nil;
    }
    [self.captureStateLock unlock];
    if (!selectedUserLeft) {
        return;
    }

    dispatch_async(dispatch_get_main_queue(), ^{
        [self.videoView.displayLayer flushAndRemoveImage];
        NSLog(@"[RCCallDemoPiP] selected user left, waiting for the next stream: %@",
              userId);
    });
}

#pragma mark - AVPictureInPictureControllerDelegate

- (void)pictureInPictureControllerDidStartPictureInPicture:
    (AVPictureInPictureController *)pictureInPictureController {
    if (pictureInPictureController != self.pictureInPictureController) {
        return;
    }
    self.startPending = NO;
    self.startRetryActive = NO;
    [self notifyStateChangedWithReason:@"started" error:nil];
}

- (void)pictureInPictureController:
    (AVPictureInPictureController *)pictureInPictureController
    failedToStartPictureInPictureWithError:(NSError *)error {
    if (pictureInPictureController != self.pictureInPictureController) {
        return;
    }
    self.startPending = NO;
    self.startRetryActive = NO;
    [self disableWithReason:@"startFailed" notify:NO];
    [self notifyStateChangedWithReason:@"startFailed" error:error.localizedDescription];
}

- (void)pictureInPictureControllerDidStopPictureInPicture:
    (AVPictureInPictureController *)pictureInPictureController {
    if (pictureInPictureController != self.pictureInPictureController) {
        return;
    }
    self.startPending = NO;
    self.startRetryActive = NO;
    [self invalidateCaptureAndUnregister];
    [self resetPixelBufferPool];
    [self tearDownPictureInPictureController];
    [self notifyStateChangedWithReason:@"stopped" error:nil];
}

- (void)pictureInPictureController:
            (AVPictureInPictureController *)pictureInPictureController
    restoreUserInterfaceForPictureInPictureStopWithCompletionHandler:
        (void (^)(BOOL restored))completionHandler {
    completionHandler(YES);
}

#pragma mark - Picture in Picture lifecycle

- (BOOL)preparePictureInPictureController API_AVAILABLE(ios(15.0)) {
    UIView *sourceView = self.sourceView;
    if (sourceView == nil) {
        return NO;
    }

    RCCallDemoPictureInPictureVideoView *videoView =
        [[RCCallDemoPictureInPictureVideoView alloc] initWithFrame:CGRectZero];
    videoView.backgroundColor = UIColor.blackColor;
    videoView.displayLayer.videoGravity = AVLayerVideoGravityResizeAspect;

    AVPictureInPictureVideoCallViewController *contentViewController =
        [[AVPictureInPictureVideoCallViewController alloc] init];
    contentViewController.view = videoView;
    contentViewController.preferredContentSize = CGSizeMake(9.0, 16.0);

    AVPictureInPictureControllerContentSource *contentSource =
        [[AVPictureInPictureControllerContentSource alloc]
            initWithActiveVideoCallSourceView:sourceView
                       contentViewController:contentViewController];
    AVPictureInPictureController *controller =
        [[AVPictureInPictureController alloc] initWithContentSource:contentSource];
    if (controller == nil) {
        return NO;
    }
    controller.delegate = self;
    controller.canStartPictureInPictureAutomaticallyFromInline = NO;

    self.videoView = videoView;
    self.contentViewController = contentViewController;
    self.pictureInPictureController = controller;
    return YES;
}

- (void)beginStartRetryForGeneration:(NSUInteger)generation {
    if (self.startPending || self.startRetryActive ||
        self.pictureInPictureController.isPictureInPictureActive) {
        return;
    }
    self.startRetryActive = YES;
    [self attemptStartForGeneration:generation attempt:0];
}

- (void)attemptStartForGeneration:(NSUInteger)generation
                           attempt:(NSUInteger)attempt {
    [self.captureStateLock lock];
    BOOL validGeneration = self.desiredEnabled && self.generation == generation;
    [self.captureStateLock unlock];
    if (!validGeneration || !self.startRetryActive) {
        return;
    }

    AVPictureInPictureController *controller = self.pictureInPictureController;
    if (controller == nil || controller.isPictureInPictureActive) {
        self.startRetryActive = NO;
        return;
    }
    if (controller.isPictureInPicturePossible) {
        self.startRetryActive = NO;
        self.startPending = YES;
        [self notifyStateChangedWithReason:@"starting" error:nil];
        [controller startPictureInPicture];
        return;
    }

    if (attempt >= RCCallDemoPictureInPictureStartRetryLimit) {
        self.startRetryActive = NO;
        NSError *error = [NSError errorWithDomain:@"RCCallDemoPictureInPicture"
                                             code:1
                                         userInfo:@{
                                             NSLocalizedDescriptionKey :
                                                 @"Picture in Picture did not become possible."
                                         }];
        [self disableWithReason:@"notPossible" notify:NO];
        [self notifyStateChangedWithReason:@"notPossible"
                                     error:error.localizedDescription];
        return;
    }

    dispatch_after(
        dispatch_time(DISPATCH_TIME_NOW,
                      (int64_t)(RCCallDemoPictureInPictureStartRetryDelay * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
            [self attemptStartForGeneration:generation attempt:attempt + 1];
        });
}

- (void)disableWithReason:(NSString *)reason notify:(BOOL)notify {
    NSAssert(NSThread.isMainThread, @"PiP lifecycle must run on the main thread.");
    [self invalidateCaptureAndUnregister];
    [self resetPixelBufferPool];

    self.startRetryActive = NO;
    self.receivedFirstFrame = NO;
    AVPictureInPictureController *controller = self.pictureInPictureController;
    BOOL needsAsynchronousStop = controller.isPictureInPictureActive || self.startPending;
    self.startPending = NO;
    if (needsAsynchronousStop) {
        self.cleanupPending = YES;
        [controller stopPictureInPicture];
        NSUInteger generation = [self currentGeneration];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
            if (self.cleanupPending && [self currentGeneration] == generation) {
                [self tearDownPictureInPictureController];
            }
        });
    } else {
        [self tearDownPictureInPictureController];
    }

    if (notify) {
        [self notifyStateChangedWithReason:reason error:nil];
    }
}

- (void)invalidateCaptureAndUnregister {
    [self.captureStateLock lock];
    BOOL wasEnabled = self.desiredEnabled;
    self.desiredEnabled = NO;
    if (wasEnabled) {
        self.generation += 1;
    }
    self.selectedUserId = nil;
    self.frameTaskPending = NO;
    [self.captureStateLock unlock];

    RCCallSession *session = self.registeredSession;
    self.registeredSession = nil;
    [session removeDelegate:self];
}

- (void)tearDownPictureInPictureController {
    self.cleanupPending = NO;
    [self.videoView.displayLayer flushAndRemoveImage];
    self.pictureInPictureController.delegate = nil;
    if (@available(iOS 15.0, *)) {
        self.pictureInPictureController.contentSource = nil;
    }
    self.pictureInPictureController = nil;
    self.contentViewController = nil;
    self.videoView = nil;
}

- (void)notifyStateChangedWithReason:(NSString *)reason
                               error:(nullable NSString *)error {
    if (![NSThread isMainThread]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyStateChangedWithReason:reason error:error];
        });
        return;
    }
    NSMutableDictionary<NSString *, id> *arguments = [[self state] mutableCopy];
    arguments[@"reason"] = reason;
    if ([reason isEqualToString:@"started"]) {
        arguments[@"state"] = @"active";
    } else if ([reason isEqualToString:@"startFailed"] ||
               [reason isEqualToString:@"notPossible"]) {
        arguments[@"state"] = @"failed";
    } else if ([reason isEqualToString:@"starting"]) {
        arguments[@"state"] = @"starting";
    } else if ([reason isEqualToString:@"enabled"]) {
        arguments[@"state"] = @"waiting";
    } else {
        arguments[@"state"] = @"inactive";
    }
    if (error.length > 0) {
        arguments[@"error"] = error;
        arguments[@"message"] = error;
    }
    NSLog(@"[RCCallDemoPiP] %@", arguments);
    [self.channel invokeMethod:@"onStateChanged" arguments:arguments];
}

- (BOOL)isCaptureEnabled {
    [self.captureStateLock lock];
    BOOL enabled = self.desiredEnabled;
    [self.captureStateLock unlock];
    return enabled;
}

- (NSUInteger)currentGeneration {
    [self.captureStateLock lock];
    NSUInteger generation = self.generation;
    [self.captureStateLock unlock];
    return generation;
}

#pragma mark - Pixel buffers

- (CVPixelBufferRef)copyDisplayCompatiblePixelBuffer:(CVPixelBufferRef)pixelBuffer
    CF_RETURNS_RETAINED {
    OSType sourceFormat = CVPixelBufferGetPixelFormatType(pixelBuffer);
    OSType destinationFormat = 0;
    switch (sourceFormat) {
        case kCVPixelFormatType_32BGRA:
        case kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange:
        case kCVPixelFormatType_420YpCbCr8BiPlanarFullRange:
            destinationFormat = sourceFormat;
            break;
        case kCVPixelFormatType_420YpCbCr8Planar:
            destinationFormat = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
            break;
        case kCVPixelFormatType_420YpCbCr8PlanarFullRange:
            destinationFormat = kCVPixelFormatType_420YpCbCr8BiPlanarFullRange;
            break;
        default: {
            NSTimeInterval now = NSProcessInfo.processInfo.systemUptime;
            if (_lastUnsupportedPixelFormat != sourceFormat ||
                now - _lastUnsupportedPixelFormatLogTime >= 5.0) {
                _lastUnsupportedPixelFormat = sourceFormat;
                _lastUnsupportedPixelFormatLogTime = now;
                NSLog(@"[RCCallDemoPiP] Unsupported pixel format: %u", sourceFormat);
            }
            return nil;
        }
    }

    if (sourceFormat == destinationFormat && CVPixelBufferGetIOSurface(pixelBuffer) != nil) {
        CVPixelBufferRetain(pixelBuffer);
        return pixelBuffer;
    }

    size_t width = CVPixelBufferGetWidth(pixelBuffer);
    size_t height = CVPixelBufferGetHeight(pixelBuffer);
    CVPixelBufferRef destination =
        [self createPixelBufferWithWidth:width height:height format:destinationFormat];
    if (destination == nil) {
        return nil;
    }

    BOOL copied = [self copyPixelBuffer:pixelBuffer toPixelBuffer:destination];
    if (!copied) {
        CVPixelBufferRelease(destination);
        return nil;
    }
    CVBufferPropagateAttachments(pixelBuffer, destination);
    return destination;
}

- (CVPixelBufferRef)createPixelBufferWithWidth:(size_t)width
                                        height:(size_t)height
                                        format:(OSType)format CF_RETURNS_RETAINED {
    BOOL poolChanged = _pixelBufferPool == nil || _pixelBufferPoolWidth != width ||
        _pixelBufferPoolHeight != height || _pixelBufferPoolFormat != format;
    if (poolChanged) {
        if (_pixelBufferPool != nil) {
            CVPixelBufferPoolRelease(_pixelBufferPool);
            _pixelBufferPool = nil;
        }
        NSDictionary *poolAttributes = @{
            (id)kCVPixelBufferPoolMinimumBufferCountKey : @3,
        };
        NSDictionary *pixelBufferAttributes = @{
            (id)kCVPixelBufferPixelFormatTypeKey : @(format),
            (id)kCVPixelBufferWidthKey : @(width),
            (id)kCVPixelBufferHeightKey : @(height),
            (id)kCVPixelBufferIOSurfacePropertiesKey : @{},
            (id)kCVPixelBufferMetalCompatibilityKey : @YES,
        };
        CVReturn result = CVPixelBufferPoolCreate(
            kCFAllocatorDefault, (__bridge CFDictionaryRef)poolAttributes,
            (__bridge CFDictionaryRef)pixelBufferAttributes, &_pixelBufferPool);
        if (result != kCVReturnSuccess || _pixelBufferPool == nil) {
            return nil;
        }
        _pixelBufferPoolWidth = width;
        _pixelBufferPoolHeight = height;
        _pixelBufferPoolFormat = format;
    }

    CVPixelBufferRef pixelBuffer = nil;
    CVReturn result = CVPixelBufferPoolCreatePixelBuffer(
        kCFAllocatorDefault, _pixelBufferPool, &pixelBuffer);
    return result == kCVReturnSuccess ? pixelBuffer : nil;
}

- (BOOL)copyPixelBuffer:(CVPixelBufferRef)source
          toPixelBuffer:(CVPixelBufferRef)destination {
    CVPixelBufferLockFlags readOnly = kCVPixelBufferLock_ReadOnly;
    if (CVPixelBufferLockBaseAddress(source, readOnly) != kCVReturnSuccess) {
        return NO;
    }
    if (CVPixelBufferLockBaseAddress(destination, 0) != kCVReturnSuccess) {
        CVPixelBufferUnlockBaseAddress(source, readOnly);
        return NO;
    }

    OSType sourceFormat = CVPixelBufferGetPixelFormatType(source);
    BOOL copied = NO;
    if (sourceFormat == kCVPixelFormatType_32BGRA) {
        copied = [self copyPackedPixelBuffer:source toPixelBuffer:destination bytesPerPixel:4];
    } else if (sourceFormat == kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange ||
               sourceFormat == kCVPixelFormatType_420YpCbCr8BiPlanarFullRange) {
        copied = [self copyBiPlanarPixelBuffer:source toPixelBuffer:destination];
    } else if (sourceFormat == kCVPixelFormatType_420YpCbCr8Planar ||
               sourceFormat == kCVPixelFormatType_420YpCbCr8PlanarFullRange) {
        copied = [self copyPlanarPixelBuffer:source toPixelBuffer:destination];
    }

    CVPixelBufferUnlockBaseAddress(destination, 0);
    CVPixelBufferUnlockBaseAddress(source, readOnly);
    return copied;
}

- (BOOL)copyPackedPixelBuffer:(CVPixelBufferRef)source
                toPixelBuffer:(CVPixelBufferRef)destination
                 bytesPerPixel:(size_t)bytesPerPixel {
    uint8_t *sourceBase = CVPixelBufferGetBaseAddress(source);
    uint8_t *destinationBase = CVPixelBufferGetBaseAddress(destination);
    if (sourceBase == nil || destinationBase == nil) {
        return NO;
    }
    size_t sourceStride = CVPixelBufferGetBytesPerRow(source);
    size_t destinationStride = CVPixelBufferGetBytesPerRow(destination);
    size_t rowBytes = MIN(CVPixelBufferGetWidth(source) * bytesPerPixel,
                          MIN(sourceStride, destinationStride));
    size_t rows = MIN(CVPixelBufferGetHeight(source),
                      CVPixelBufferGetHeight(destination));
    for (size_t row = 0; row < rows; row++) {
        memcpy(destinationBase + row * destinationStride,
               sourceBase + row * sourceStride, rowBytes);
    }
    return YES;
}

- (BOOL)copyBiPlanarPixelBuffer:(CVPixelBufferRef)source
                  toPixelBuffer:(CVPixelBufferRef)destination {
    if (CVPixelBufferGetPlaneCount(source) < 2 ||
        CVPixelBufferGetPlaneCount(destination) < 2) {
        return NO;
    }
    for (size_t plane = 0; plane < 2; plane++) {
        uint8_t *sourceBase = CVPixelBufferGetBaseAddressOfPlane(source, plane);
        uint8_t *destinationBase =
            CVPixelBufferGetBaseAddressOfPlane(destination, plane);
        if (sourceBase == nil || destinationBase == nil) {
            return NO;
        }
        size_t sourceStride = CVPixelBufferGetBytesPerRowOfPlane(source, plane);
        size_t destinationStride =
            CVPixelBufferGetBytesPerRowOfPlane(destination, plane);
        size_t samples = MIN(CVPixelBufferGetWidthOfPlane(source, plane),
                             CVPixelBufferGetWidthOfPlane(destination, plane));
        size_t rowBytes = plane == 0 ? samples : samples * 2;
        rowBytes = MIN(rowBytes, MIN(sourceStride, destinationStride));
        size_t rows = MIN(CVPixelBufferGetHeightOfPlane(source, plane),
                          CVPixelBufferGetHeightOfPlane(destination, plane));
        for (size_t row = 0; row < rows; row++) {
            memcpy(destinationBase + row * destinationStride,
                   sourceBase + row * sourceStride, rowBytes);
        }
    }
    return YES;
}

- (BOOL)copyPlanarPixelBuffer:(CVPixelBufferRef)source
                toPixelBuffer:(CVPixelBufferRef)destination {
    if (CVPixelBufferGetPlaneCount(source) < 3 ||
        CVPixelBufferGetPlaneCount(destination) < 2) {
        return NO;
    }

    uint8_t *sourceY = CVPixelBufferGetBaseAddressOfPlane(source, 0);
    uint8_t *sourceU = CVPixelBufferGetBaseAddressOfPlane(source, 1);
    uint8_t *sourceV = CVPixelBufferGetBaseAddressOfPlane(source, 2);
    uint8_t *destinationY = CVPixelBufferGetBaseAddressOfPlane(destination, 0);
    uint8_t *destinationUV = CVPixelBufferGetBaseAddressOfPlane(destination, 1);
    if (sourceY == nil || sourceU == nil || sourceV == nil || destinationY == nil ||
        destinationUV == nil) {
        return NO;
    }

    size_t sourceYStride = CVPixelBufferGetBytesPerRowOfPlane(source, 0);
    size_t destinationYStride = CVPixelBufferGetBytesPerRowOfPlane(destination, 0);
    size_t ySamples = MIN(CVPixelBufferGetWidthOfPlane(source, 0),
                          CVPixelBufferGetWidthOfPlane(destination, 0));
    size_t yRowBytes = MIN(ySamples, MIN(sourceYStride, destinationYStride));
    size_t yRows = MIN(CVPixelBufferGetHeightOfPlane(source, 0),
                       CVPixelBufferGetHeightOfPlane(destination, 0));
    for (size_t row = 0; row < yRows; row++) {
        memcpy(destinationY + row * destinationYStride,
               sourceY + row * sourceYStride, yRowBytes);
    }

    size_t sourceUStride = CVPixelBufferGetBytesPerRowOfPlane(source, 1);
    size_t sourceVStride = CVPixelBufferGetBytesPerRowOfPlane(source, 2);
    size_t destinationUVStride = CVPixelBufferGetBytesPerRowOfPlane(destination, 1);
    size_t chromaSamples = MIN(CVPixelBufferGetWidthOfPlane(source, 1),
                               CVPixelBufferGetWidthOfPlane(source, 2));
    chromaSamples = MIN(chromaSamples,
                        CVPixelBufferGetWidthOfPlane(destination, 1));
    chromaSamples = MIN(chromaSamples, destinationUVStride / 2);
    if (sourceUStride < chromaSamples || sourceVStride < chromaSamples) {
        return NO;
    }
    size_t chromaRows = MIN(CVPixelBufferGetHeightOfPlane(source, 1),
                            CVPixelBufferGetHeightOfPlane(source, 2));
    chromaRows = MIN(chromaRows,
                     CVPixelBufferGetHeightOfPlane(destination, 1));
    for (size_t row = 0; row < chromaRows; row++) {
        uint8_t *sourceURow = sourceU + row * sourceUStride;
        uint8_t *sourceVRow = sourceV + row * sourceVStride;
        uint8_t *destinationUVRow = destinationUV + row * destinationUVStride;
        for (size_t column = 0; column < chromaSamples; column++) {
            destinationUVRow[column * 2] = sourceURow[column];
            destinationUVRow[column * 2 + 1] = sourceVRow[column];
        }
    }
    return YES;
}

- (CMSampleBufferRef)createSampleBuffer:(CVPixelBufferRef)pixelBuffer
    CF_RETURNS_RETAINED {
    CMVideoFormatDescriptionRef formatDescription = nil;
    OSStatus status = CMVideoFormatDescriptionCreateForImageBuffer(
        kCFAllocatorDefault, pixelBuffer, &formatDescription);
    if (status != noErr || formatDescription == nil) {
        return nil;
    }

    CMSampleTimingInfo timing = {
        .duration = kCMTimeInvalid,
        .presentationTimeStamp = CMClockGetTime(CMClockGetHostTimeClock()),
        .decodeTimeStamp = kCMTimeInvalid,
    };
    CMSampleBufferRef sampleBuffer = nil;
    status = CMSampleBufferCreateReadyWithImageBuffer(
        kCFAllocatorDefault, pixelBuffer, formatDescription, &timing, &sampleBuffer);
    CFRelease(formatDescription);
    if (status != noErr || sampleBuffer == nil) {
        return nil;
    }
    CMSetAttachment(sampleBuffer, kCMSampleAttachmentKey_DisplayImmediately,
                    kCFBooleanTrue, kCMAttachmentMode_ShouldPropagate);
    return sampleBuffer;
}

- (void)resetPixelBufferPool {
    dispatch_async(self.frameQueue, ^{
        if (self->_pixelBufferPool != nil) {
            CVPixelBufferPoolRelease(self->_pixelBufferPool);
            self->_pixelBufferPool = nil;
        }
        self->_pixelBufferPoolWidth = 0;
        self->_pixelBufferPoolHeight = 0;
        self->_pixelBufferPoolFormat = 0;
    });
}

@end
