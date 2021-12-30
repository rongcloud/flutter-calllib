/// vivo 推送类型
enum RCCallVivoPushType {
  /// 运营消息
  operation,

  /// 系统消息
  system,
}

/// huawei 推送紧急程度
enum RCCallHuaWeiPushImportance {
  /// 正常
  normal,

  /// 低
  low,
}

/// 用户身份类型
enum RCCallUserType {
  normal,
  observer,
}

/// 通话类型
enum RCCallCallType {
  single,
  group,
}

/// 通话媒体类型
enum RCCallMediaType {
  audio,
  audio_video,
}

/// 音频编码类型
enum RCCallAudioCodecType {
  /// 0
  pcmu,

  /// 111
  opus
}

enum RCCallVideoBitrateMode {
  /// 0
  cq,

  /// 1
  vbr,

  /// 2
  cbr
}

/// 相机类型
enum RCCallCamera {
  /// 未指定
  none,

  /// 前置相机
  front,

  /// 后置相机
  back
}

/// 网络质量
enum RCCallNetworkQuality {
  unknown,
  excellent,
  good,
  poor,
  bad,
  terrible,
}

/// 视频显示模式
enum RCCallViewFitType {
  /// 拉伸全屏
  fill,

  /// 满屏显示
  ///
  /// 等比例填充， 直到填充满整个试图区域，其中一个维度的部分区域会被裁剪
  cover,

  /// 完整显示
  ///
  /// 填充黑边， 等比例填充，直达一个维度到达区域边界
  center
}

/// 通话视频参数
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

/// 摄像机方向
///
/// 值与 AVCaptureVideoOrientation 一致
enum RCCallCameraOrientation {
  portrait,
  portrait_upside_down,
  landscape_right,
  landscape_left,
}

/// 通话结束原因
enum RCCallDisconnectReason {
  /// 己方取消已发出的通话请求
  cancel,

  /// 己方拒绝收到的通话请求
  reject,

  /// 己方挂断
  hangup,

  /// 己方忙碌
  busy_line,

  /// 己方未接听
  no_response,

  /// 己方不支持当前引擎
  engine_unsupported,

  /// 己方网络出错
  network_error,

  /// 己方获取媒体资源失败
  resource_error,

  /// 己方发布资源失败
  publish_error,

  /// 己方订阅资源失败
  subscribe_error,

  /// 对方取消已发出的通话请求
  remote_cancel,

  /// 对方拒绝收到的通话请求
  remote_reject,

  /// 通话过程对方挂断
  remote_hangup,

  /// 对方忙碌
  remote_busy_line,

  /// 对方未接听
  remote_no_response,

  /// 对方不支持当前引擎
  remote_engine_unsupported,

  /// 对方网络错误
  remote_network_error,

  /// 对方获取媒体资源失败
  remote_resource_error,

  /// 对方发布资源失败
  remote_publish_error,

  /// 对方订阅资源失败
  remote_subscribe_error,

  /// 己方其他端已加入新通话
  kicked_by_other_call,

  /// 己方其他端已在通话中
  in_other_call,

  /// 己方已被禁止通话
  kicked_by_server,

  /// 对方其他端已加入新通话
  remote_kicked_by_other_call,

  /// 对方其他端已在通话中
  remote_in_other_call,

  /// 对方已被禁止通话
  remote_kicked_by_server,

  /// 己方其他端已接听
  accept_by_other_client,

  /// 己方其他端已挂断
  hangup_by_other_client,

  /// 己方被对方加入黑名单
  add_to_black_list,

  /// 音视频服务已关闭
  media_server_closed,

  /// 己方被降级为观察者
  degrade,

  /// 己方摄像头初始化错误，可能是没有打开使用摄像头权限
  init_video_error,

  /// 其他端已经接听
  other_device_had_accepted,

  /// im ipc服务已断开
  service_disconnected,
}

/// 通话错误类型
class RCCallErrorCode {
  /// 成功
  static const int success = 0;

  /// 开通的音视频服务没有及时生效或音视频服务已关闭，请等待3-5小时后重新安装应用或开启音视频服务再进行测试
  static const int engineNotFound = 1;

  /// 网络不可用
  static const int networkUnavailable = 2;

  /// 已经处于通话中了
  static const int oneCallExisted = 3;

  /// 无效操作
  static const int operationUnavailable = 4;

  /// 参数错误
  static const int invalidParam = 5;

  /// 网络不稳定
  static const int networkUnstable = 6;

  /// 媒体服务请求失败
  static const int mediaRequestFailed = 7;

  /// 媒体服务初始化失败
  static const int mediaServerNotReady = 8;

  /// 媒体服务未初始化
  static const int mediaServerNotInitialized = 9;

  /// 媒体服务请求超时
  static const int mediaRequestTimeout = 10;

  /// 未知的媒体服务错误
  static const int mediaUnkownError = 11;

  /// 已被禁止通话
  static const int mediaKickedByServerError = 12;

  /// 音视频服务已关闭
  static const int mediaServerClosedError = 13;

  /// 音视频发布资源失败
  static const int mediaServerPublishError = 14;

  /// 音视频订阅资源失败
  static const int mediaServerSubscribeError = 15;

  /// 其他端已在通话中错误
  static const int mediaJoinRoomRefuseError = 16;
}

/// 滤镜类型
enum RCCallBeautyFilter {
  /// 原图
  none,

  /// 唯美
  esthetic,

  /// 清新
  fresh,

  /// 浪漫
  romantic
}
