/// [ZH]
/// ---
/// vivo 推送类型
/// ---
/// [EN]
/// ---
/// Vivo push type
/// ---
enum RCCallVivoPushType {
  /// [ZH]
  /// ---
  /// 运营消息
  /// ---
  /// [EN]
  /// ---
  /// Operational message
  /// ---
  operation,

  /// [ZH]
  /// ---
  /// 系统消息
  /// ---
  /// [EN]
  /// ---
  /// System message
  /// ---
  system,
}

/// [ZH]
/// ---
/// huawei 推送紧急程度
/// ---
/// [EN]
/// ---
/// Huawei push importance level
/// ---
enum RCCallHuaWeiPushImportance {
  /// [ZH]
  /// ---
  /// 正常
  /// ---
  /// [EN]
  /// ---
  /// Normal
  /// ---
  normal,

  /// [ZH]
  /// ---
  /// 低
  /// ---
  /// [EN]
  /// ---
  /// Low
  /// ---
  low,
}

/// [ZH]
/// ---
/// 用户身份类型
/// ---
/// [EN]
/// ---
/// User role type
/// ---
enum RCCallUserType { normal, observer }

/// [ZH]
/// ---
/// 通话类型
/// ---
/// [EN]
/// ---
/// Call type
/// ---
enum RCCallCallType { single, group }

/// [ZH]
/// ---
/// 通话媒体类型
/// ---
/// [EN]
/// ---
/// Call media type
/// ---
enum RCCallMediaType { audio, audio_video }

/// [ZH]
/// ---
/// 音频编码类型
/// ---
/// [EN]
/// ---
/// Audio codec type
/// ---
enum RCCallAudioCodecType {
  /// 0
  pcmu,

  /// 111
  opus,
}

enum RCCallVideoBitrateMode {
  /// [ZH]
  /// ---
  /// Constant quality mode
  ///
  /// 完全不控制码率，尽最大可能保证图像质量；
  /// 质量要求高、带宽足够、解码器支持码率剧烈波动的情况下，可以选择 CQ 码率控制策略。
  /// ---
  /// [EN]
  /// ---
  /// Constant quality mode
  ///
  /// Maximizes image quality without bitrate control
  /// Ideal when quality matters, bandwidth is sufficient, and the decoder handles bitrate fluctuations
  /// ---
  cq,

  /// [ZH]
  /// ---
  /// Variable bitrate mode
  ///
  /// 码率可以随着图像的复杂程度的不同而变化，因此其编码效率比较高，马赛克很少。适合的应用场景是媒体存储，而不是网络传输；
  /// VBR 输出码率会在一定范围内波动，对于小幅晃动，方块效应会有所改善，但对剧烈晃动仍无能为力；连续调低码率则会导致码率急剧下降，如果无法接受这个问题，那 VBR 就不是好的选择。
  /// ---
  /// [EN]
  /// ---
  /// Variable bitrate mode
  ///
  /// Bitrate adjusts to image complexity for higher encoding efficiency with minimal artifacts. Best for media storage, not streaming.
  /// VBR bitrate fluctuates within a range—reduces blocking for minor motion but struggles with rapid movement. Consistently lowering bitrate may cause sharp drops. Avoid VBR if this is unacceptable.
  /// ---
  vbr,

  /// [ZH]
  /// ---
  /// Constant bitrate mode
  ///
  /// 码率在流的进行过程中基本保持恒定并且接近目标码率，当对复杂内容编码时质量会下降。在流式播放方案中使用CBR编码最为有效
  /// CBR 的优点是稳定可控，这样对实时性的保证有帮助.
  /// ---
  /// [EN]
  /// ---
  /// Constant bitrate mode
  ///
  /// Maintains steady bitrate close to target, though complex content may reduce quality. Best for streaming
  /// CBR ensures stable performance for real-time needs
  /// ---
  cbr,
}

/// [ZH]
/// ---
/// 相机类型
/// ---
/// [EN]
/// ---
/// Camera type
/// ---
enum RCCallCamera {
  /// [ZH]
  /// ---
  /// 未指定
  /// ---
  /// [EN]
  /// ---
  /// Unspecified
  /// ---
  none,

  /// [ZH]
  /// ---
  /// 前置相机
  /// ---
  /// [EN]
  /// ---
  /// Front camera
  /// ---
  front,

  /// [ZH]
  /// ---
  /// 后置相机
  /// ---
  /// [EN]
  /// ---
  /// Rear camera
  /// ---
  back,
}

/// [ZH]
/// ---
/// 网络质量
/// ---
/// [EN]
/// ---
/// Network quality
/// ---
enum RCCallNetworkQuality { unknown, excellent, good, poor, bad, terrible }

/// [ZH]
/// ---
/// 视频显示模式
/// ---
/// [EN]
/// ---
/// Video display mode
/// ---
enum RCCallViewFitType {
  /// [ZH]
  /// ---
  /// 拉伸全屏
  /// ---
  /// [EN]
  /// ---
  /// Stretch to fill
  ///
  fill,

  /// [ZH]
  /// ---
  /// 满屏显示
  ///
  /// 等比例填充，直到填充满整个视图区域，其中一个维度的部分区域会被裁剪
  /// ---
  /// [EN]
  /// ---
  /// Cover
  ///
  /// Scale to fill while preserving aspect ratio until the view is covered; one dimension may be cropped
  /// ---
  cover,

  /// [ZH]
  /// ---
  /// 完整显示
  ///
  /// 填充黑边，等比例填充，直到一个维度到达区域边界
  /// ---
  /// [EN]
  /// ---
  /// Contain
  ///
  /// Letterbox to show the whole content; scale to fit until one dimension reaches the boundary
  /// ---
  center,
}

/// [ZH]
/// ---
/// 通话视频参数
/// ---
/// [EN]
/// ---
/// Call video profiles
/// ---
enum RCCallVideoProfile {
  /// 144x256, 15fps, 120~240kbps
  profile_144_256,

  /// 240x240, 15fps, 120~280kbps
  profile_240_240,

  /// 240x320, 15fps, 120~400kbps
  profile_240_320,

  ///  360x480, 15fps, 150~650kbps
  profile_360_480,

  /// 360x640, 15fps, 180~800kbps
  profile_360_640,

  /// 480x640, 15fps, 200~900kbps
  profile_480_640,

  ///  480x720, 15fps, 200~1000kbps
  profile_480_720,

  ///  720x1280, 15fps, 250~2200kbps
  profile_720_1280,

  /// 1080x1920, 15fps, 400~4000kbps
  profile_1080_1920,

  /// 144x256, 30fps, 240~480kbps
  profile_144_256_high,

  ///  240x240, 30fps, 240~360kbps
  profile_240_240_high,

  /// 240x320, 30fps, 240~800kbps
  profile_240_320_high,

  /// 360x480, 30fps, 300~1300kbps
  profile_360_480_high,

  /// 360x640, 30fps, 360~1600kbps
  profile_360_640_high,

  /// 480x640, 30fps, 400~1800kbps
  profile_480_640_high,

  ///  480x720, 30fps, 400~2000kbps
  profile_480_720_high,

  /// 720x1080, 30fps, 500~4400kbps
  profile_720_1080_high,

  /// 1080x1920, 30fps, 800~8000kbps
  profile_1080_1920_high,
}

/// [ZH]
/// ---
/// 摄像机方向
/// 值与 AVCaptureVideoOrientation 一致
/// ---
/// [EN]
/// ---
/// Camera orientation
/// Values align with AVCaptureVideoOrientation
/// ---
enum RCCallCameraOrientation {
  portrait,
  portrait_upside_down,
  landscape_right,
  landscape_left,
}

/// [ZH]
/// ---
/// 通话结束原因
/// ---
/// [EN]
/// ---
/// Call disconnect reasons
/// ---
enum RCCallDisconnectReason {
  /// [ZH]
  /// ---
  /// 己方取消已发出的通话请求
  /// ---
  /// [EN]
  /// ---
  /// Local cancelled outgoing call
  /// ---
  cancel,

  /// [ZH]
  /// ---
  /// 己方拒绝收到的通话请求
  /// ---
  /// [EN]
  /// ---
  /// Local rejected incoming call
  /// ---
  reject,

  /// [ZH]
  /// ---
  /// 己方挂断
  /// ---
  /// [EN]
  /// ---
  /// Local hung up
  /// ---
  hangup,

  /// [ZH]
  /// ---
  /// 己方忙碌
  /// ---
  /// [EN]
  /// ---
  /// Local busy
  /// ---
  busy_line,

  /// [ZH]
  /// ---
  /// 己方未接听
  /// ---
  /// [EN]
  /// ---
  /// Local no response
  /// ---
  no_response,

  /// [ZH]
  /// ---
  /// 己方不支持当前引擎
  /// ---
  /// [EN]
  /// ---
  /// Local engine unsupported
  /// ---
  engine_unsupported,

  /// [ZH]
  /// ---
  /// 己方网络出错
  /// ---
  /// [EN]
  /// ---
  /// Local network error
  /// ---
  network_error,

  /// [ZH]
  /// ---
  /// 己方获取媒体资源失败
  /// ---
  /// [EN]
  /// ---
  /// Local media resource acquisition failed
  /// ---
  resource_error,

  /// [ZH]
  /// ---
  /// 己方发布资源失败
  /// ---
  /// [EN]
  /// ---
  /// Local publish resource failed
  publish_error,

  /// [ZH]
  /// ---
  /// 己方订阅资源失败
  /// ---
  /// [EN]
  /// ---
  /// Local subscribe resource failed
  /// ---
  subscribe_error,

  /// [ZH]
  /// ---
  /// 对方取消已发出的通话请求
  /// ---
  /// [EN]
  /// ---
  /// Remote cancelled outgoing call
  /// ---
  remote_cancel,

  /// [ZH]
  /// ---
  /// 对方拒绝收到的通话请求
  /// ---
  /// [EN]
  /// ---
  /// Remote rejected incoming call
  /// ---
  remote_reject,

  /// [ZH]
  /// ---
  /// 通话过程对方挂断
  /// ---
  /// [EN]
  /// ---
  /// Remote hung up during call
  /// ---
  remote_hangup,

  /// [ZH]
  /// ---
  /// 对方忙碌
  /// ---
  /// [EN]
  /// ---
  /// Remote busy
  /// ---
  remote_busy_line,

  /// [ZH]
  /// ---
  /// 对方未接听
  /// ---
  /// [EN]
  /// ---
  /// Remote no response
  /// ---
  remote_no_response,

  /// [ZH]
  /// ---
  /// 对方不支持当前引擎
  /// ---
  /// [EN]
  /// ---
  /// Remote engine unsupported
  /// ---
  remote_engine_unsupported,

  /// [ZH]
  /// ---
  /// 对方网络错误
  /// ---
  /// [EN]
  /// ---
  /// Remote network error
  /// ---
  remote_network_error,

  /// [ZH]
  /// ---
  /// 对方获取媒体资源失败
  /// ---
  /// [EN]
  /// ---
  /// Remote media resource acquisition failed
  /// ---
  remote_resource_error,

  /// [ZH]
  /// ---
  /// 对方发布资源失败
  /// ---
  /// [EN]
  /// ---
  /// Remote publish resource failed
  /// ---
  remote_publish_error,

  /// [ZH]
  /// ---
  /// 对方订阅资源失败
  /// ---
  /// [EN]
  /// ---
  /// Remote subscribe resource failed
  /// ---
  remote_subscribe_error,

  /// [ZH]
  /// ---
  /// 己方其他端已加入新通话
  /// ---
  /// [EN]
  /// ---
  /// Local device joined another call
  /// ---
  kicked_by_other_call,

  /// [ZH]
  /// ---
  /// 己方其他端已在通话中
  /// ---
  /// [EN]
  /// ---
  /// Local device in another call
  /// ---
  in_other_call,

  /// [ZH]
  /// ---
  /// 己方已被禁止通话
  /// ---
  /// [EN]
  /// ---
  /// Local banned from calling
  /// ---
  kicked_by_server,

  /// [ZH]
  /// ---
  /// 对方其他端已加入新通话
  /// ---
  /// [EN]
  /// ---
  /// Remote device joined another call
  /// ---
  remote_kicked_by_other_call,

  /// [ZH]
  /// ---
  /// 对方其他端已在通话中
  /// ---
  /// [EN]
  /// ---
  /// Remote device in another call
  /// ---
  remote_in_other_call,

  /// [ZH]
  /// ---
  /// 对方已被禁止通话
  /// ---
  /// [EN]
  /// ---
  /// Remote banned from calling
  /// ---
  remote_kicked_by_server,

  /// [ZH]
  /// ---
  /// 己方其他端已接听
  /// ---
  /// [EN]
  /// ---
  /// Accepted by another local client
  /// ---
  accept_by_other_client,

  /// [ZH]
  /// ---
  /// 己方其他端已挂断
  /// ---
  /// [EN]
  /// ---
  /// Hung up by another local client
  /// ---
  hangup_by_other_client,

  /// [ZH]
  /// ---
  /// 己方被对方加入黑名单
  /// ---
  /// [EN]
  /// ---
  /// Blocked by the remote user
  /// ---
  add_to_black_list,

  /// [ZH]
  /// ---
  /// 音视频服务已关闭
  /// ---
  /// [EN]
  /// ---
  /// Media service closed
  /// ---
  media_server_closed,

  /// [ZH]
  /// ---
  /// 己方被降级为观察者
  /// ---
  /// [EN]
  /// ---
  /// Local degraded to observer
  /// ---
  degrade,

  /// [ZH]
  /// ---
  /// 己方摄像头初始化错误，可能是没有打开使用摄像头权限
  /// ---
  /// [EN]
  /// ---
  /// Local camera initialization error, possibly due to missing camera permission
  /// ---
  init_video_error,

  /// [ZH]
  /// ---
  /// 其他端已经接听
  /// ---
  /// [EN]
  /// ---
  /// Another device has accepted
  /// ---
  other_device_had_accepted,

  /// [ZH]
  /// ---
  /// im ipc服务已断开
  /// ---
  /// [EN]
  /// ---
  /// IM IPC service disconnected
  /// ---
  service_disconnected,
}

/// [ZH]
/// ---
/// 通话错误类型
/// ---
/// [EN]
/// ---
/// Call error codes
/// ---
class RCCallErrorCode {
  /// [ZH]
  /// ---
  /// 成功
  /// ---
  /// [EN]
  /// ---
  /// Success
  /// ---
  static const int success = 0;

  /// [ZH]
  /// ---
  /// 开通的音视频服务没有及时生效或音视频服务已关闭，请等待3-5小时后重新安装应用或开启音视频服务再进行测试
  /// ---
  /// [EN]
  /// ---
  /// The audio/video service is not yet active or has been disabled. Please wait 3–5 hours, then reinstall the app or enable the service before testing again
  /// ---
  static const int engineNotFound = 1;

  /// [ZH]
  /// ---
  /// 网络不可用
  /// ---
  /// [EN]
  /// ---
  /// Network unavailable
  /// ---
  static const int networkUnavailable = 2;

  /// [ZH]
  /// ---
  /// 已经处于通话中了
  /// ---
  /// [EN]
  /// ---
  /// Already in a call
  /// ---
  static const int oneCallExisted = 3;

  /// [ZH]
  /// ---
  /// 无效操作
  /// ---
  /// [EN]
  /// ---
  /// Invalid operation
  /// ---
  static const int operationUnavailable = 4;

  /// [ZH]
  /// ---
  /// 参数错误
  /// ---
  /// [EN]
  /// ---
  /// Invalid parameter
  /// ---
  static const int invalidParam = 5;

  /// [ZH]
  /// ---
  /// 网络不稳定
  /// ---
  /// [EN]
  /// ---
  /// Network unstable
  /// ---
  static const int networkUnstable = 6;

  /// [ZH]
  /// ---
  /// 媒体服务请求失败
  /// ---
  /// [EN]
  /// ---
  /// Media service request failed
  /// ---
  static const int mediaRequestFailed = 7;

  /// [ZH]
  /// ---
  /// 媒体服务初始化失败
  /// ---
  /// [EN]
  /// ---
  /// Media service initialization failed
  /// ---
  static const int mediaServerNotReady = 8;

  /// [ZH]
  /// ---
  /// 媒体服务未初始化
  /// ---
  /// [EN]
  /// ---
  /// Media service not initialized
  /// ---
  static const int mediaServerNotInitialized = 9;

  /// [ZH]
  /// ---
  /// 媒体服务请求超时
  /// ---
  /// [EN]
  /// ---
  /// Media service request timeout
  /// ---
  static const int mediaRequestTimeout = 10;

  /// [ZH]
  /// ---
  /// 未知的媒体服务错误
  /// ---
  /// [EN]
  /// ---
  /// Unknown media service error
  /// ---
  static const int mediaUnkownError = 11;

  /// [ZH]
  /// ---
  /// 已被禁止通话
  /// ---
  /// [EN]
  /// ---
  /// Banned from calling
  /// ---
  static const int mediaKickedByServerError = 12;

  /// [ZH]
  /// ---
  /// 音视频服务已关闭
  /// ---
  /// [EN]
  /// ---
  /// Media service closed
  /// ---
  static const int mediaServerClosedError = 13;

  /// [ZH]
  /// ---
  /// 音视频发布资源失败
  /// ---
  /// [EN]
  /// ---
  /// Media publish failed
  /// ---
  static const int mediaServerPublishError = 14;

  /// [ZH]
  /// ---
  /// 音视频订阅资源失败
  /// ---
  /// [EN]
  /// ---
  /// Media subscribe failed
  /// ---
  static const int mediaServerSubscribeError = 15;

  /// [ZH]
  /// ---
  /// 其他端已在通话中错误
  /// ---
  /// [EN]
  /// ---
  /// Another endpoint is already in a call
  /// ---
  static const int mediaJoinRoomRefuseError = 16;
}

/// [ZH]
/// ---
/// 滤镜类型
/// ---
/// [EN]
/// ---
/// Beauty filter type
/// ---
enum RCCallBeautyFilter {
  /// [ZH]
  /// ---
  /// 原图
  /// ---
  /// [EN]
  /// ---
  /// None (original)
  /// ---
  none,

  /// [ZH]
  /// ---
  /// 唯美
  /// ---
  /// [EN]
  /// ---
  /// Esthetic
  /// ---
  esthetic,

  /// [ZH]
  /// ---
  /// 清新
  /// ---
  /// [EN]
  /// ---
  /// Fresh
  /// ---
  fresh,

  /// [ZH]
  /// ---
  /// 浪漫
  /// ---
  /// [EN]
  /// ---
  /// Romantic
  /// ---
  romantic,
}
