typedef void StartCallCallback(code, session);

typedef void StateCallback(code, info);

const List<String> ProfileStrings = [
  '144x256, 15fps, 120~240kbps',
  '240x240, 15fps, 120~280kbps',
  '240x320, 15fps, 120~400kbps',
  '360x480, 15fps, 150~650kbps',
  '360x640, 15fps, 180~800kbps',
  '480x640, 15fps, 200~900kbps',
  '480x720, 15fps, 200~1000kbps',
  '720x1280, 15fps, 250~2200kbps',
  '1080x1920, 15fps, 400~4000kbps',
  '144x256, 30fps, 240~480kbps',
  '240x240, 30fps, 240~360kbps',
  '240x320, 30fps, 240~800kbps',
  '360x480, 30fps, 300~1300kbps',
  '360x640, 30fps, 360~1600kbps',
  '480x640, 30fps, 400~1800kbps',
  '480x720, 30fps, 400~2000kbps',
  '720x1080, 30fps, 500~4400kbps',
  '1080x1920, 30fps, 800~8000kbps',
];

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
