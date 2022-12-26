import 'dart:async';
import 'dart:io';

import 'package:context_holder/context_holder.dart';
import 'package:flutter/material.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_beauty_wrapper_plugin/rongcloud_beauty_wrapper_plugin.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_constants.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_options.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';

/// 示例说明：本示例需要分别在 iOS 和 android 设备中运行
/// 其中 android 设备会登陆用户 A
/// iOS 设备会登陆用户 B
/// 以下 TODO 参数需要自行配置

/// TODO app key
const String app_key = '';

/// TODO user a token
const String token_a = '';

/// TODO user a id
const String user_a = '';

/// TODO user b token
const String token_b = '';

/// TODO user b id
const String user_b = '';

void main() {
  runApp(MaterialApp(
    navigatorKey: ContextHolder.key,
    home: const MyApp(),
  ));
}

enum AppState {
  disconnected,
  connected,
  ringing,
  calling,
  chatting,
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {

    RCIMIWEngineOptions options = RCIMIWEngineOptions.create();

    RCIMIWEngine imEngine = await RCIMIWEngine.create(app_key, options);

    String token = Platform.isAndroid ? token_a : token_b;
    imEngine.onConnected = (int? code, String? userId) async {
      _state = AppState.connected;
      await _initEngine();
      if (mounted) {
        setState(() {});
      }
    };
    imEngine.connect(token, 0);
  }

  Future<void> _initEngine() async {
    _engine = await RCCallEngine.create();

    RCCallAudioConfig audioConfig = RCCallAudioConfig.create();
    await _engine?.setAudioConfig(audioConfig);

    RCCallVideoConfig videoConfig = RCCallVideoConfig.create(profile: RCCallVideoProfile.profile_1080_1920_high);
    await _engine?.setVideoConfig(videoConfig);

    _engine?.onReceiveCall = (session) {
      setState(() {
        _session = session;
        _state = AppState.ringing;
      });
    };

    _engine?.onConnect = () => _connected();

    _engine?.onRemoteUserDidChangeCameraState = (user, enable) async {
      if (enable) {
        if (_mine) {
          if (_small == null) {
            _small = await RCCallView.create(fit: BoxFit.cover);
            await _engine?.setVideoView(_smallUserId!, _small);
          }
        } else {
          if (_big == null) {
            _big = await RCCallView.create(fit: BoxFit.cover);
            await _engine?.setVideoView(_bigUserId!, _big);
          }
        }
      } else {
        if (_mine) {
          if (_small != null) {
            _small = null;
            await _engine?.setVideoView(_smallUserId!, null);
          }
        } else {
          if (_big != null) {
            _big = null;
            await _engine?.setVideoView(_bigUserId!, null);
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
    };

    _engine?.onDisconnect = (reason) async {
      'Disconnect, reason = $reason'.toast();
      _state = AppState.connected;
      _background = null;
      _big = null;
      _small = null;

      _beauty = false;
      await RCBeautyEngine.setBeautyFilter(RCBeautyFilter.none);
      await RCBeautyEngine.resetBeauty();
      await RCBeautyEngine.setBeautyOptions(false);

      if (mounted) {
        setState(() {});
      }
    };

    _engine?.onCallError = (error) {
      'Call Error, error = $error'.toast();
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter call plugin'),
        ),
        body: _build(),
      ),
    );
  }

  Widget _build() {
    switch (_state) {
      case AppState.disconnected:
        return Center(
          child: CircularProgressIndicator(),
        );
      case AppState.connected:
        return _buildConnectedPage();
      case AppState.ringing:
        return _buildRingingPage();
      case AppState.calling:
        return _buildCallingPage();
      case AppState.chatting:
        return _buildChattingPage();
    }
  }

  Widget _buildConnectedPage() {
    return Center(
      child: TextButton(
        onPressed: () => _call(),
        child: Text(
          '呼叫',
          style: TextStyle(
            color: Colors.green,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCallingPage() {
    return Stack(
      children: [
        _background != null ? _background! : Container(),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Divider(
              height: 150,
              color: Colors.transparent,
            ),
            Text(
              '正在呼叫${_target()}...',
              softWrap: true,
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                decoration: TextDecoration.none,
              ),
            ),
            Divider(
              height: 50,
              color: Colors.transparent,
            ),
            Row(
              children: [
                Spacer(),
                TextButton(
                  onPressed: () => _hangup(),
                  child: Text(
                    '挂断',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
                Spacer(),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildRingingPage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Divider(
          height: 150,
          color: Colors.transparent,
        ),
        Text(
          '来自${_caller()}的${_type()}电话',
          softWrap: true,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            decoration: TextDecoration.none,
          ),
        ),
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
        Row(
          children: [
            Spacer(),
            TextButton(
              onPressed: () => _accept(),
              child: Text(
                '接听',
                style: TextStyle(
                  color: Colors.green,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Spacer(),
            TextButton(
              onPressed: () => _hangup(),
              child: Text(
                '拒绝',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
            Spacer(),
          ],
        )
      ],
    );
  }

  void _accept() async {
    int code = await _engine?.accept() ?? -1;
    if (code != 0) {
      'Accept Call Error $code'.toast();
    }
  }

  void _hangup() async {
    int code = await _engine?.hangup() ?? -1;
    if (code != 0) {
      'Hangup Call Error $code'.toast();
    }
    _state = AppState.connected;
    if (mounted) {
      setState(() {});
    }
  }

  String _target() {
    return _session?.targetId ?? 'Unknown';
  }

  String _caller() {
    return _session?.caller?.userId ?? 'Unknown';
  }

  String _type() {
    return _session?.mediaType.toString() ?? 'Unknown';
  }

  Widget _buildChattingPage() {
    return Stack(
      children: [
        _bigView(),
        Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.only(
              right: 10,
              top: 10,
            ),
            child: _smallView(),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 200,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () => _cameraSwitch(),
                      child: Text(
                        '${_camera ? '关闭摄像头' : '开启摄像头'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => _camera ? _switchCamera() : null,
                      child: Text(
                        '切换摄像头',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () => _microphoneSwitch(),
                      child: Text(
                        '${_microphone ? '关闭麦克风' : '开启麦克风'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Spacer(),
                    TextButton(
                      onPressed: () => _speakerSwitch(),
                      child: Text(
                        '${_speaker ? '扬声器' : '听筒'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
                Row(
                  children: [
                    Spacer(),
                    TextButton(
                      onPressed: () => _beautySwitch(),
                      child: Text(
                        '${_beauty ? '关闭美颜' : '开启美颜'}',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Spacer(),
                  ],
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: 100,
            ),
            child: TextButton(
              onPressed: () => _hangup(),
              child: Text(
                '挂断',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _bigView() {
    return Container(
      color: Colors.yellow,
      child: Stack(
        children: [
          _big != null ? _big! : Container(),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 5,
                top: 5,
              ),
              child: Text(
                '$_bigUserId',
                softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallView() {
    return Container(
      width: 100,
      height: 130,
      color: Colors.blue,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _switchView(),
        child: Stack(
          children: [
            _small != null ? _small! : Container(),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  top: 5,
                ),
                child: Text(
                  '$_smallUserId',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _switchView() async {
    _mine = !_mine;

    _big = null;
    _small = null;

    if (_bigUserId != null) {
      await _engine?.setVideoView(_bigUserId!, null);
    }
    if (_smallUserId != null) {
      await _engine?.setVideoView(_smallUserId!, null);
    }

    String? temp = _bigUserId;
    _bigUserId = _smallUserId;
    _smallUserId = temp;

    if (_bigUserId != null) {
      _big = await RCCallView.create(fit: BoxFit.cover);
      await _engine?.setVideoView(_bigUserId!, _big);
    }
    if (_smallUserId != null) {
      _small = await RCCallView.create(fit: BoxFit.cover);
      await _engine?.setVideoView(_smallUserId!, _small);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void _call() async {
    String target = Platform.isAndroid ? user_b : user_a;
    _session = await _engine?.startCall(target, RCCallMediaType.audio_video);
    if (_session != null) {
      _state = AppState.calling;
      _background = await RCCallView.create(fit: BoxFit.cover);
      if (mounted) {
        setState(() {});
      }
      await _engine?.setVideoView(_session!.mine.userId, _background);
    }
  }

  void _connected() async {
    _background = null;

    _bigUserId = _session?.mine.userId;
    _session?.users.forEach((user) {
      if (user.userId != _bigUserId) {
        _smallUserId = user.userId;
      }
    });

    _mine = true;
    _camera = true;
    _microphone = true;
    _speaker = false;

    _engine?.enableSpeaker(_speaker);

    _big = await RCCallView.create(fit: BoxFit.cover);
    _small = await RCCallView.create(fit: BoxFit.cover);

    _state = AppState.chatting;

    if (mounted) {
      setState(() {});
    }

    await _engine?.setVideoView(_bigUserId!, _big);
    await _engine?.setVideoView(_smallUserId!, _small);
  }

  void _cameraSwitch() async {
    _camera = !_camera;
    await _engine?.enableCamera(_camera);
    if (_camera) {
      if (_mine) {
        _big = await RCCallView.create(fit: BoxFit.cover);
        await _engine?.setVideoView(_bigUserId!, _big);
      } else {
        _small = await RCCallView.create(fit: BoxFit.cover);
        await _engine?.setVideoView(_smallUserId!, _small);
      }
    } else {
      if (_mine) {
        _big = null;
        await _engine?.setVideoView(_bigUserId!, null);
      } else {
        _small = null;
        await _engine?.setVideoView(_smallUserId!, null);
      }
    }
    setState(() {});
  }

  void _switchCamera() async {
    await _engine?.switchCamera();
  }

  void _microphoneSwitch() async {
    _microphone = !_microphone;
    await _engine?.enableMicrophone(_microphone);
    setState(() {});
  }

  void _speakerSwitch() async {
    _speaker = !_speaker;
    await _engine?.enableSpeaker(_speaker);
    setState(() {});
  }

  void _beautySwitch() async {
    RCBeautyOptions options = RCBeautyOptions.create(
      whitenessLevel: 2,
      smoothLevel: 4,
      ruddyLevel: 3,
      brightLevel: 5,
    );

    _beauty = !_beauty;
    if (_beauty) {
      await RCBeautyEngine.setBeautyOptions(_beauty, options);
      await RCBeautyEngine.setBeautyFilter(RCBeautyFilter.romantic);
    } else {
      await RCBeautyEngine.setBeautyFilter(RCBeautyFilter.none);
      await RCBeautyEngine.setBeautyOptions(_beauty, options);
    }

    setState(() {});
  }

  AppState _state = AppState.disconnected;
  RCCallEngine? _engine;
  RCCallSession? _session;
  RCCallView? _background;

  bool _mine = true;
  RCCallView? _big;
  String? _bigUserId;
  RCCallView? _small;
  String? _smallUserId;

  bool _beauty = false;
  bool _camera = true;
  bool _microphone = true;
  bool _speaker = false;
}
