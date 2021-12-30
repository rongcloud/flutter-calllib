//
//  RCCallIWDefine.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#ifndef RCCallIWDefine_h
#define RCCallIWDefine_h

#import <Foundation/Foundation.h>

/*!
 用户身份类型
 */
typedef NS_ENUM(NSInteger, RCCallIWUserType) {
    /*!
     普通身份
     */
    RCCallIWUserTypeNormal            = 1,
    /*!
     观察者身份
     */
    RCCallIWUserTypeObserver          = 2
};

/*!
 通话类型
 */
typedef NS_ENUM(NSInteger, RCCallIWCallType) {
    /*!
     单聊通话
     */
    RCCallIWCallTypeSingle           = 0,
    /*!
     群聊通话
     */
    RCCallIWCallTypeGroup            = 1
};

/*!
 通话媒体类型
 */
typedef NS_ENUM(NSInteger, RCCallIWMediaType) {
    /*!
     音频通话
     */
    RCCallIWMediaTypeAudio            = 0,
    /*!
     音视频通话
     */
    RCCallIWMediaTypeAudioVideo       = 2
};

/*!
 相机类型
 */
typedef NS_ENUM(NSInteger, RCCallIWCamera) {
    /*!
     未指定
     */
    RCCallIWCameraNone                = -1,
    /*!
     前置相机
     */
    RCCallIWCameraFront               = 0,
    /*!
     后置相机
     */
    RCCallIWCameraBack                = 1,
};

/*!
 网络质量
 */
typedef NS_ENUM(NSInteger, RCCallIWNetworkQuality) {
    /*!
     未知
     */
    RCCallIWNetworkQualityUnknown     = 0,
    /*!
     极好
     */
    RCCallIWNetworkQualityExcellent   = 1,
    /*!
     好
     */
    RCCallIWNetworkQualityGood        = 2,
    /*!
     一般
     */
    RCCallIWNetworkQualityPoor        = 3,
    /*!
     差
     */
    RCCallIWNetworkQualityBad         = 4,
    /*!
     极差
     */
    RCCallIWNetworkQualityTerrible    = 5,
};

/*!
 视频显示模式
 */
typedef NS_ENUM(NSInteger, RCCallIWViewFitType) {
    /*!
     拉伸全屏
     */
    RCCallIWViewFitTypeFill           = 0,
    /*!
     满屏显示， 等比例填充， 直到填充满整个试图区域，其中一个维度的部分区域会被裁剪
     */
    RCCallIWViewFitTypeCover          = 1,
    /*!
     完整显示， 填充黑边， 等比例填充，直达一个维度到达区域边界
     */
    RCCallIWViewFitTypeCenter         = 2,
};


/*!
 通话视频参数
 */
typedef NS_ENUM (NSInteger, RCCallIWVideoProfile) {
    /*!
     144x256, 15fps, 120~240kbps
     */
    RCCallIW_VIDEO_PROFILE_144_256              = 10,
    /*!
     240x240, 15fps, 120~280kbps
     */
    RCCallIW_VIDEO_PROFILE_240_240              = 20,
    /*!
     240x320, 15fps, 120~400kbps
     */
    RCCallIW_VIDEO_PROFILE_240_320              = 30,
    /*!
     360x480, 15fps, 150~650kbps
     */
    RCCallIW_VIDEO_PROFILE_360_480              = 40,
    /*!
     360x640, 15fps, 180~800kbps
     */
    RCCallIW_VIDEO_PROFILE_360_640              = 50,
    /*!
     480x640, 15fps, 200~900kbps
     */
    RCCallIW_VIDEO_PROFILE_480_640              = 60,
    /*!
     480x720, 15fps, 200~1000kbps
     */
    RCCallIW_VIDEO_PROFILE_480_720              = 70,
    /*!
     720x1280, 15fps, 250~2200kbps
     */
    RCCallIW_VIDEO_PROFILE_720_1280             = 80,
    /*!
     1080x1920, 15fps, 400~4000kbps
     */
    RCCallIW_VIDEO_PROFILE_1080_1920            = 90,
    /*!
     144x256, 30fps, 240~480kbps
     */
    RCCallIW_VIDEO_PROFILE_144_256_HIGH         = 11,
    /*!
     240x240, 30fps, 240~360kbps
     */
    RCCallIW_VIDEO_PROFILE_240_240_HIGH         = 21,
    /*!
     240x320, 30fps, 240~800kbps
     */
    RCCallIW_VIDEO_PROFILE_240_320_HIGH         = 31,
    /*!
     360x480, 30fps, 300~1300kbps
     */
    RCCallIW_VIDEO_PROFILE_360_480_HIGH         = 41,
    /*!
     360x640, 30fps, 360~1600kbps
     */
    RCCallIW_VIDEO_PROFILE_360_640_HIGH         = 51,
    /*!
     480x640, 30fps, 400~1800kbps
     */
    RCCallIW_VIDEO_PROFILE_480_640_HIGH         = 61,
    /*!
     480x720, 30fps, 400~2000kbps
     */
    RCCallIW_VIDEO_PROFILE_480_720_HIGH         = 71,
    /*!
     720x1080, 30fps, 500~4400kbps
     */
    RCCallIW_VIDEO_PROFILE_720_1280_HIGH        = 81,
    /*!
     1080x1920, 30fps, 800~8000kbps
     */
    RCCallIW_VIDEO_PROFILE_1080_1920_HIGH       = 91,
};


/*!
 摄像机方向
 值与 AVCaptureVideoOrientation 一致
 */
typedef NS_ENUM(NSInteger, RCCallIWCameraOrientation) {
      RCCallIWCameraOrientationPortrait           = 1,
      RCCallIWCameraOrientationPortraitUpsideDown = 2,
      RCCallIWCameraOrientationLandscapeRight     = 3,
      RCCallIWCameraOrientationLandscapeLeft      = 4,
};

/*!
 通话结束原因
 */
typedef NS_ENUM (NSInteger, RCCallIWDisconnectReason) {
    /*!
     己方取消已发出的通话请求
     */
    RCCallIWDisconnectReasonCancel                        = 1,
    /*!
     己方拒绝收到的通话请求
     */
    RCCallIWDisconnectReasonReject                        = 2,
    /*!
     己方挂断
     */
    RCCallIWDisconnectReasonHangup                        = 3,
    /*!
     己方忙碌
     */
    RCCallIWDisconnectReasonBusyLine                      = 4,
    /*!
     己方未接听
     */
    RCCallIWDisconnectReasonNoResponse                    = 5,
    /*!
     己方不支持当前引擎
     */
    RCCallIWDisconnectReasonEngineUnsupported             = 6,
    /*!
     己方网络出错
     */
    RCCallIWDisconnectReasonNetworkError                  = 7,
    /*!
     己方获取媒体资源失败
     */
    RCCallIWDisconnectReasonResourceError                 = 8,
    /*!
     己方发布资源失败
     */
    RCCallIWDisconnectReasonPublishError                  = 9,
    /*!
     己方订阅资源失败
     */
    RCCallIWDisconnectReasonSubscribeError                = 10,
    /*!
     对方取消已发出的通话请求
     */
    RCCallIWDisconnectReasonRemoteCancel                  = 11,
    /*!
     对方拒绝收到的通话请求
     */
    RCCallIWDisconnectReasonRemoteReject                  = 12,
    /*!
     通话过程对方挂断
     */
    RCCallIWDisconnectReasonRemoteHangup                  = 13,
    /*!
     对方忙碌
     */
    RCCallIWDisconnectReasonRemoteBusyLine                = 14,
    /*!
     对方未接听
     */
    RCCallIWDisconnectReasonRemoteNoResponse              = 15,
    /*!
     对方不支持当前引擎
     */
    RCCallIWDisconnectReasonRemoteEngineUnsupported       = 16,
    /*!
     对方网络错误
     */
    RCCallIWDisconnectReasonRemoteNetworkError            = 17,
    /*!
     对方获取媒体资源失败
     */
    RCCallIWDisconnectReasonRemoteResourceError           = 18,
    /*!
     对方发布资源失败
     */
    RCCallIWDisconnectReasonRemotePublishError            = 19,
    /*!
     对方订阅资源失败
     */
    RCCallIWDisconnectReasonRemoteSubscribeError          = 20,
    /*!
     己方其他端已加入新通话
     */
    RCCallIWDisconnectReasonKickedByOtherCall             = 21,
    /*!
     己方其他端已在通话中
     */
    RCCallIWDisconnectReasonInOtherCall                   = 22,
    /*!
     己方已被禁止通话
     */
    RCCallIWDisconnectReasonKickedByServer                = 23,
    /*!
     对方其他端已加入新通话
     */
    RCCallIWDisconnectReasonRemoteKickedByOtherCall       = 24,
    /*!
     对方其他端已在通话中
     */
    RCCallIWDisconnectReasonRemoteInOtherCall             = 25,
    /*!
     对方已被禁止通话
     */
    RCCallIWDisconnectReasonRemoteKickedByServer          = 26,
    /*!
     己方其他端已接听
     */
    RCCallIWDisconnectReasonAcceptByOtherClient           = 27,
    /*!
     己方其他端已挂断
     */
    RCCallIWDisconnectReasonHangupByOtherClient           = 28,
    /*!
     己方被对方加入黑名单
     */
    RCCallIWDisconnectReasonAddToBlackList                = 29,
    /*!
     音视频服务已关闭
     */
    RCCallIWDisconnectReasonMediaServerClosed             = 30,
    /*!
     己方被降级为观察者
     */
    RCCallIWDisconnectReasonDegrade                       = 31,
    /*!
     己方摄像头初始化错误，可能是没有打开使用摄像头权限
     */
    RCCallIWDisconnectReasonInitVideoError                = 32,
    /*!
     其他端已经接听
     */
    RCCallIWDisconnectReasonOtherDeviceHadAccepted        = 33,
    /*!
     im ipc服务已断开
     */
    RCCallIWDisconnectReasonServiceDisconnected           = 34
};


/*!
 通话错误类型
 */
typedef NS_ENUM (NSInteger, RCCallIWErrorCode) {
    /*!
     成功
     */
    RCCallIWSuccess                           = 0,
    /*!
     开通的音视频服务没有及时生效或音视频服务已关闭，请等待3-5小时后重新安装应用或开启音视频服务再进行测试
     */
    RCCallIWEngineNotFound                    = 1,
    /*!
     网络不可用
     */
    RCCallIWNetworkUnavailable                = 2,
    /*!
     已经处于通话中了
     */
    RCCallIWOneCallExisted                    = 3,
    /*!
     无效操作
     */
    RCCallIWOperationUnavailable              = 4,
    /*!
     参数错误
     */
    RCCallIWInvalidParam                      = 5,
    /*!
     网络不稳定
     */
    RCCallIWNetworkUnstable                   = 6,
    /*!
     媒体服务请求失败
     */
    RCCallIWMediaRequestFailed                = 7,
    /*!
     媒体服务初始化失败
     */
    RCCallIWMediaServerNotReady               = 8,
    /*!
     媒体服务未初始化
     */
    RCCallIWMediaServerNotInitialized         = 9,
    /*!
     媒体服务请求超时
     */
    RCCallIWMediaRequestTimeout               = 10,
    /*!
     未知的媒体服务错误
     */
    RCCallIWMediaUnkownError                  = 11,
    /*!
     已被禁止通话
     */
    RCCallIWMediaKickedByServerError          = 12,
    /*!
     音视频服务已关闭
     */
    RCCallIWMediaServerClosedError            = 13,
    /*!
     音视频发布资源失败
     */
    RCCallIWMediaServerPublishError           = 14,
    /*!
     音视频订阅资源失败
     */
    RCCallIWMediaServerSubscribeError         = 15,
    /*!
     其他端已在通话中错误
     */
    RCCallIWMediaJoinRoomRefuseError          = 16
};

/**
 滤镜类型
 */
typedef NS_ENUM(NSInteger, RCCallIWBeautyFilter) {
    /*!
     原图
     */
    RCCallIWBeautyFilterNone = 0,
    /*!
     唯美
     */
    RCCallIWBeautyFilterEsthetic = 1,
    /*!
     清新
     */
    RCCallIWBeautyFilterFresh = 2,
    /*!
     浪漫
     */
    RCCallIWBeautyFilterRomantic = 3
};

#endif /* RCCallIWDefine_h */
