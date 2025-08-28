//
//  RCCallIWFlutterView.h
//  RongCallWrapper
//
//  Created by 潘铭达 on 2021/6/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCCallIWFlutterViewDelegate <NSObject>

- (void)changeSize:(int)width height:(int)height;

- (void)changeRotation:(int)rotation;

- (void)firstFrameRendered;

- (void)frameRendered;

// 当原生层摄像头进行操作的时候 通知 Flutter 层的 view 进行视图的镜像操作
- (void)onMirrorChanged:(BOOL)mirror;

@end

@interface RCCallIWFlutterView : NSObject

@property (nonatomic, weak) id<RCCallIWFlutterViewDelegate> textureViewDelegate;

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)new NS_UNAVAILABLE;

- (instancetype)initWithCoder:(NSCoder *)coder NS_UNAVAILABLE;

+ (RCCallIWFlutterView *)create;

@end

NS_ASSUME_NONNULL_END
