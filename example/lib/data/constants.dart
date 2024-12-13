typedef void StartCallCallback(code, session);

typedef void StateCallback(code, info);

enum RCCallMode {
  private_chat,
  group_chat,
}

enum AppState {
  disconnected,
  connected,
  ringing,
  calling,
  chatting,
}

enum AppBeautyOption {
  /// 滤镜
  filter,

  /// 美白
  whiteness,

  /// 磨皮
  smooth,

  /// 红润
  ruddy,

  /// 亮度
  bright,
}
