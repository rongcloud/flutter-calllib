import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_call_plugin_example/config.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_beauty_wrapper_plugin/rongcloud_beauty_wrapper_plugin.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_constants.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_options.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'utils/utils.dart';
// import 'package:audio_routing/audio_routing.dart';

enum AppState {
  disconnected,
  connected,
  ringing,
  calling,
  chatting,
}

class CallPage extends StatefulWidget {
  const CallPage({Key? key}) : super(key: key);

  @override
  State<CallPage> createState() => _CallPageState();
}

class _CallPageState extends State<CallPage> {
  static const MethodChannel _pictureInPictureChannel = MethodChannel(
    'cn.rongcloud.call.demo/picture_in_picture',
  );

  @override
  void initState() {
    super.initState();

    _state = AppState.connected;
    if (Platform.isIOS) {
      _pictureInPictureChannel.setMethodCallHandler(
        _handlePictureInPictureMethodCall,
      );
      _syncPictureInPictureState();
    }
    _initEngine();
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      _pictureInPictureChannel.setMethodCallHandler(null);
      _pictureInPictureChannel.invokeMethod<bool>(
        'setEnabled',
        <String, bool>{'enabled': false},
      ).catchError((Object error) {
        debugPrint('[PiP] disable during dispose failed: $error');
        return false;
      });
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: MaterialApp(
        home: Scaffold(
          appBar: AppBar(
            title: const Text('flutter call plugin'),
            actions: [
              if (Platform.isIOS && _state == AppState.chatting)
                IconButton(
                  tooltip: _pictureInPictureActive
                      ? '关闭系统画中画'
                      : (_pictureInPictureEnabled ? '取消画中画' : '开启系统画中画'),
                  onPressed:
                      _pictureInPictureBusy ? null : _togglePictureInPicture,
                  icon: _pictureInPictureBusy
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Icon(
                          _pictureInPictureEnabled
                              ? Icons.picture_in_picture
                              : Icons.picture_in_picture_alt,
                          color: _pictureInPictureActive ? Colors.green : null,
                        ),
                ),
            ],
          ),
          body: _build(),
        ),
      ),
      onWillPop: () {
        return Future.value(false);
      },
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
        child: Column(
      children: [
        Text("当前登录 id : ${Utils.currentUserId}"),
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
        AppConfig.isDebug
            ? TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: '请输入对方 id',
                ),
              )
            : Container(),
        TextButton(
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
        Divider(
          height: 50,
          color: Colors.transparent,
        ),
        TextButton(
          onPressed: () => _disconnect(),
          child: Text(
            '退出',
            style: TextStyle(
              color: Colors.green,
              fontSize: 15,
              decoration: TextDecoration.none,
            ),
          ),
        ),
      ],
    ));
  }

  Widget _buildRingingPage() {
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
                TextButton(
                  onPressed: () => _openPreview(),
                  child: Text(
                    _preview ? '关闭预览' : '打开预览',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
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
            )
          ],
        ),
      ],
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
                TextButton(
                  onPressed: () => _openPreview(),
                  child: Text(
                    _preview ? '关闭预览' : '打开预览',
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
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
            )
          ],
        ),
      ],
    );
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

  Future<void> _initEngine() async {
    await RCBeautyEngine.setBeautyFilter(RCBeautyFilter.none);
    await RCBeautyEngine.resetBeauty();
    await RCBeautyEngine.setBeautyOptions(false);

    RCCallAudioConfig audioConfig = RCCallAudioConfig.create();
    await Utils.callEngine?.setAudioConfig(audioConfig);

    RCCallVideoConfig videoConfig = RCCallVideoConfig.create(
        profile: RCCallVideoProfile.profile_1080_1920_high);
    await Utils.callEngine?.setVideoConfig(videoConfig);
    Utils.callEngine?.enableCamera(false);

    Utils.callEngine?.onReceiveCall = (session) async {
      if (Platform.isAndroid) {
        // routing.startAudioRouteing();
      }

      _background = await RCCallView.create(fit: BoxFit.cover);
      await Utils.callEngine?.setVideoView(Utils.currentUserId!, _background);
      setState(() {
        _session = session;
        _state = AppState.ringing;
      });
    };

    Utils.callEngine?.onConnect = () async {
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

      Utils.callEngine?.enableSpeaker(_speaker);

      _big = await RCCallView.create(fit: BoxFit.cover);
      _small = await RCCallView.create(fit: BoxFit.cover);

      _state = AppState.chatting;

      if (mounted) {
        setState(() {});
      }

      await Utils.callEngine?.setVideoView(_bigUserId!, _big);
      await Utils.callEngine?.setVideoView(_smallUserId!, _small);
    };

    Utils.callEngine?.onRemoteUserDidChangeCameraState = (user, enable) async {
      if (enable) {
        if (_mine) {
          if (_small == null) {
            _small = await RCCallView.create(fit: BoxFit.cover);
            await Utils.callEngine?.setVideoView(_smallUserId!, _small);
          }
        } else {
          if (_big == null) {
            _big = await RCCallView.create(fit: BoxFit.cover);
            await Utils.callEngine?.setVideoView(_bigUserId!, _big);
          }
        }
      } else {
        if (_mine) {
          if (_small != null) {
            _small = null;
            await Utils.callEngine?.setVideoView(_smallUserId!, null);
          }
        } else {
          if (_big != null) {
            _big = null;
            await Utils.callEngine?.setVideoView(_bigUserId!, null);
          }
        }
      }

      if (mounted) {
        setState(() {});
      }
    };

    Utils.callEngine?.onDisconnect = (reason) async {
      if (Platform.isAndroid) {
        // routing.stopAudioRouteing();
      }

      await _setPictureInPictureEnabled(false);

      'Disconnect, reason = $reason'.toast();
      _state = AppState.connected;
      _background = null;
      _big = null;
      _small = null;

      _beauty = false;

      if (mounted) {
        setState(() {});
      }
    };

    Utils.callEngine?.onCallError = (error) {
      'Call Error, error = $error'.toast();
    };
  }

  void _call() async {
    String target;

    if (!AppConfig.isDebug) {
      if (Platform.isAndroid) {
        target = AppConfig.user_b;
      } else {
        target = AppConfig.user_a;
      }
    } else {
      target = _controller.text;
    }

    Utils.callEngine?.enableCamera(false);
    _session =
        await Utils.callEngine?.startCall(target, RCCallMediaType.audio_video);
    if (Platform.isAndroid) {
      // routing.startAudioRouteing();
    }

    if (_session != null) {
      _state = AppState.calling;
      _background = await RCCallView.create(fit: BoxFit.cover);
      if (mounted) {
        setState(() {});
      }
      await Utils.callEngine?.setVideoView(_session!.mine.userId, _background);
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

  void _accept() async {
    int code = await Utils.callEngine?.accept() ?? -1;
    if (code != 0) {
      'Accept Call Error $code'.toast();
    }
  }

  void _hangup() async {
    await _setPictureInPictureEnabled(false);
    int code = await Utils.callEngine?.hangup() ?? -1;
    if (code != 0) {
      'Hangup Call Error $code'.toast();
    }
    _state = AppState.connected;
    if (mounted) {
      setState(() {});
    }
  }

  _openPreview() {
    _preview = !_preview;
    Utils.callEngine?.enableCamera(_preview);
    // 根据_preview判断是否开启摄像头
    Toast.toast(_preview ? '开启摄像头' : '关闭摄像头');
    if (mounted) {
      setState(() {});
    }
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

  void _cameraSwitch() async {
    _camera = !_camera;
    await Utils.callEngine?.enableCamera(_camera);
    if (_camera) {
      if (_mine) {
        _big = await RCCallView.create(fit: BoxFit.cover);
        await Utils.callEngine?.setVideoView(_bigUserId!, _big);
      } else {
        _small = await RCCallView.create(fit: BoxFit.cover);
        await Utils.callEngine?.setVideoView(_smallUserId!, _small);
      }
    } else {
      if (_mine) {
        _big = null;
        await Utils.callEngine?.setVideoView(_bigUserId!, null);
      } else {
        _small = null;
        await Utils.callEngine?.setVideoView(_smallUserId!, null);
      }
    }
    setState(() {});
  }

  void _switchCamera() async {
    await Utils.callEngine?.switchCamera();
  }

  void _microphoneSwitch() async {
    _microphone = !_microphone;
    await Utils.callEngine?.enableMicrophone(_microphone);
    setState(() {});
  }

  void _speakerSwitch() async {
    _speaker = !_speaker;
    await Utils.callEngine?.enableSpeaker(_speaker);
    setState(() {});
  }

  Future<dynamic> _handlePictureInPictureMethodCall(MethodCall call) async {
    if (call.method != 'onStateChanged') {
      return null;
    }

    final Map<dynamic, dynamic> arguments =
        call.arguments as Map<dynamic, dynamic>? ?? <dynamic, dynamic>{};
    final bool enabled = arguments['enabled'] == true;
    final bool active = arguments['active'] == true;
    final String state = arguments['state'] as String? ?? 'unknown';
    final String? message = arguments['message'] as String?;

    debugPrint(
      '[PiP] native state=$state enabled=$enabled active=$active'
      '${message == null ? '' : ' message=$message'}',
    );
    if (!mounted) {
      return null;
    }

    setState(() {
      _pictureInPictureEnabled = enabled;
      _pictureInPictureActive = active;
      _pictureInPictureBusy = false;
    });
    if (state == 'active') {
      '系统画中画已启动'.toast();
    } else if (state == 'failed') {
      (message ?? '系统画中画启动失败').toast();
    }
    return null;
  }

  Future<void> _syncPictureInPictureState() async {
    try {
      final Map<dynamic, dynamic>? state =
          await _pictureInPictureChannel.invokeMapMethod<dynamic, dynamic>(
        'getState',
      );
      if (!mounted || state == null) {
        return;
      }
      setState(() {
        _pictureInPictureEnabled = state['enabled'] == true;
        _pictureInPictureActive = state['active'] == true;
      });
    } on MissingPluginException {
      debugPrint('[PiP] demo native channel is unavailable');
    } on PlatformException catch (error) {
      debugPrint('[PiP] failed to query state: ${error.message}');
    }
  }

  Future<void> _togglePictureInPicture() async {
    await _setPictureInPictureEnabled(!_pictureInPictureEnabled,
        showResult: true);
  }

  Future<void> _setPictureInPictureEnabled(
    bool enabled, {
    bool showResult = false,
  }) async {
    if (!Platform.isIOS || _pictureInPictureBusy) {
      return;
    }
    if (!enabled && !_pictureInPictureEnabled) {
      return;
    }

    if (mounted) {
      setState(() {
        _pictureInPictureBusy = true;
      });
    }
    try {
      final bool actualEnabled =
          await _pictureInPictureChannel.invokeMethod<bool>(
                'setEnabled',
                <String, bool>{'enabled': enabled},
              ) ??
              false;
      debugPrint(
        '[PiP] set enabled=$enabled result=$actualEnabled',
      );
      if (!mounted) {
        return;
      }
      setState(() {
        _pictureInPictureEnabled = actualEnabled;
        if (!actualEnabled) {
          _pictureInPictureActive = false;
        }
      });
      if (showResult) {
        (actualEnabled ? '画中画已开启，等待远端视频帧' : '画中画已关闭').toast();
      }
    } on PlatformException catch (error) {
      debugPrint(
        '[PiP] set enabled=$enabled failed: ${error.code} ${error.message}',
      );
      if (showResult && mounted) {
        (error.message ?? '画中画操作失败').toast();
      }
    } finally {
      if (mounted) {
        setState(() {
          _pictureInPictureBusy = false;
        });
      }
    }
  }

  void _switchView() async {
    _mine = !_mine;

    _big = null;
    _small = null;

    if (_bigUserId != null) {
      await Utils.callEngine?.setVideoView(_bigUserId!, null);
    }
    if (_smallUserId != null) {
      await Utils.callEngine?.setVideoView(_smallUserId!, null);
    }

    String? temp = _bigUserId;
    _bigUserId = _smallUserId;
    _smallUserId = temp;

    if (_bigUserId != null) {
      _big = await RCCallView.create(fit: BoxFit.cover);
      await Utils.callEngine?.setVideoView(_bigUserId!, _big);
    }
    if (_smallUserId != null) {
      _small = await RCCallView.create(fit: BoxFit.cover);
      await Utils.callEngine?.setVideoView(_smallUserId!, _small);
    }

    if (mounted) {
      setState(() {});
    }
  }

  _disconnect() {
    Utils.imEngine?.disconnect(false);
    // 返回上一个页面
    Navigator.pop(context);
  }

  AppState _state = AppState.disconnected;
  // AudioRouting routing = AudioRouting();
  RCCallView? _background;
  RCCallSession? _session;

  bool _mine = true;
  RCCallView? _big;
  String? _bigUserId;
  RCCallView? _small;
  String? _smallUserId;

  bool _beauty = false;
  bool _camera = true;
  bool _preview = true;
  bool _microphone = true;
  bool _speaker = false;
  bool _pictureInPictureEnabled = false;
  bool _pictureInPictureActive = false;
  bool _pictureInPictureBusy = false;

  TextEditingController _controller = TextEditingController();
}
