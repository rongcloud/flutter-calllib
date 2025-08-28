//
//  RCCallIWVideoView.h
//  RongCallWrapper
//
//  Created by RongCloud on 2023/5/12.
//

#import <UIKit/UIKit.h>
#import <RongRTCLib/RongRTCLib.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallIWVideoView : UIView

@property (nonatomic, weak, readonly) RCRTCVideoView *videoView;
// 预览是否镜像 （最终设置的是原生 videoView，所以要注意设置的时机）
@property (nonatomic, assign) BOOL isMirror;
// 原生 videoView 添加完成
@property (nonatomic, copy) void(^nativeVideoViewDidAdd)(RCRTCVideoView *videoView);

@end

NS_ASSUME_NONNULL_END
