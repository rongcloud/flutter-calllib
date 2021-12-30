//
//  RCCallIWVideoConfig.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <RongCallWrapper/RCCallIWDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallIWVideoConfig : NSObject

/*!
 视频配置
 默认值 RCCallIW_VIDEO_PROFILE_720_1280
 */
@property (nonatomic, assign) RCCallIWVideoProfile profile;
/*!
 摄像头
 默认值 RCCallIWCameraFront
 */
@property (nonatomic, assign) RCCallIWCamera defaultCamera;
/*!
 相机方向
 默认值 RCCallIWCameraOrientationPortrait
 */
@property (nonatomic, assign) RCCallIWCameraOrientation cameraOrientation;

/*!
 本地摄像头采集是否镜像
 
 前置摄像头默认: YES，后置摄像头默认: NO
 */
@property (nonatomic, assign) BOOL isPreviewMirror;

@end

NS_ASSUME_NONNULL_END
