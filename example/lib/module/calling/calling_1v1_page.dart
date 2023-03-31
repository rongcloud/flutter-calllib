import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/frame/ui/loading.dart';
import 'package:flutter_call_plugin_example/frame/utils/extension.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';
import 'package:flutter_call_plugin_example/widgets/ui.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_beauty_wrapper_plugin/rongcloud_beauty_wrapper_plugin.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_constants.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_options.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'calling_page_contract.dart';
import 'calling_page_presenter.dart';

class Chatting1v1Page extends AbstractView {
  @override
  _Chatting1v1PageState createState() => _Chatting1v1PageState();
}

class _Chatting1v1PageState
    extends AbstractViewState<ChattingPagePresenter, Chatting1v1Page>
    implements View {
  @override
  ChattingPagePresenter createPresenter() {
    return ChattingPagePresenter();
  }

  @override
  void init(BuildContext context) {
    super.init(context);
    _state = Utils.state;
    if (mounted) {
      setState(() {});
    }

    _session = ModalRoute.of(context)!.settings.arguments as RCCallSession?;
    if (_session != null) {
      if (_session!.mediaType == RCCallMediaType.audio_video) {
        createBackground();
      }
    }
  }

  void createBackground() async {
    _localView = await RCCallView.create(fit: BoxFit.cover);
    await Utils.callEngine!.enableCamera(true);
    await Utils.callEngine?.setVideoView(_session!.mine.userId, _localView);
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {

    if (_state == AppState.ringing) {
      return _buildRingingPage();
    } else if (_state == AppState.calling) {
      return _buildCallingPage();
    } else if (_state == AppState.chatting) {
      return _buildChattingPage();
    } else {
      return _buildWrongStatePage();
    }
  }

  Widget _buildWrongStatePage() {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(
                  height: 150,
                  color: Colors.transparent,
                ),
                Text(
                  '状态： $_state',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                  ),
                ),
                Divider(
                  height: 50,
                  color: Colors.transparent,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Utils.resetState();
                        _exit();
                      },
                      child: Text(
                        '返回',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 15,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
      onWillPop: _exit,
    );
  }

  Widget _buildRingingPage() {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(
                  height: 150,
                  color: Colors.transparent,
                ),
                Text(
                  '来自 ${_caller()} 的${_type()}',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
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
            ),
          ],
        ),
      ),
      onWillPop: _exit,
    );
  }

  Widget _buildCallingPage() {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.black45,
        body: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Divider(
                  height: 150,
                  color: Colors.transparent,
                ),
                Text(
                  '正在呼叫 ${_session!.targetId} ...',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
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
                        '取消',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
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
        ),
      ),
      onWillPop: _exit,
    );
  }

  bool _isAudioOnly() {
    if (_session!.mediaType == RCCallMediaType.audio) {
      return true;
    }

    return false;
  }

  Widget _myControlPanel() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _isAudioOnly()
              ? Container()
              : Row(
                  children: [
                    VerticalDivider(),
                    Button(
                      _camera ? '关闭摄像头' : '开启摄像头',
                      callback: () {
                        _camera = !_camera;
                        _enableCamera(_camera);
                      },
                    ),
                  ],
                ),
          Divider(
            height: 2.dp,
            color: Colors.transparent,
          ),
          _isAudioOnly()
              ? Container()
              : Row(
                  children: [
                    VerticalDivider(),
                    Button(
                      '切换摄像头',
                      callback: _switchCameraAction,
                    ),
                  ],
                ),
          Divider(
            height: 2.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              VerticalDivider(),
              Button(
                _microphone ? '关闭麦克风' : '开启麦克风',
                callback: _microphoneAction,
              ),
            ],
          ),
          Divider(
            height: 2.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              VerticalDivider(),
              Button(
                _speaker ? '扬声器' : '听筒',
                callback: _speakerAction,
              ),
            ],
          ),
          Divider(
            height: 2.dp,
            color: Colors.transparent,
          ),
          _isAudioOnly()
              ? Container()
              : Row(
                  children: [
                    VerticalDivider(),
                    Button(
                      '切成语音通话',
                      callback: _switchToAudioChat,
                    ),
                  ],
                ),
          Divider(
            height: 2.dp,
            color: Colors.transparent,
          ),
          Row(
            children: [
              VerticalDivider(),
              (_state == AppState.chatting &&
                      _session!.mediaType == RCCallMediaType.audio_video)
                  ? Button(
                      _isShowBeautyPanel ? '隐藏美颜面板' : '显示美颜面板',
                      callback: () {
                        _showBeautyPanel(context);
                      },
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  String _bigTitle() {
    if (_state == AppState.chatting) {
      if (_localIsBig) {
        return _localUserId!;
      } else {
        return _remoteUserId!;
      }
    } else {
      return '';
    }
  }

  String _smallTitle() {
    if (_state == AppState.chatting) {
      if (!_localIsBig) {
        return _localUserId!;
      } else {
        return _remoteUserId!;
      }
    } else {
      return '';
    }
  }

  Widget _getView(bool big) {
    if ((_localIsBig && big) || (!_localIsBig && !big)) {
      if (_localView != null) {
        return _localView!;
      } else {
        return Container();
      }
    }
    if ((_localIsBig && !big) || (!_localIsBig && big)) {
      if (_remoteView != null) {
        return _remoteView!;
      } else {
        return Container();
      }
    }

    return Container();
  }

  Widget _bigView() {
    return Container(
      color: Colors.white54,
      child: Stack(
        children: [
          _getView(true),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(
                left: 5,
                top: 20.dp,
              ),
              child: Text(
                '${_bigTitle()}',
                softWrap: true,
                style: TextStyle(
                  color: Colors.lightBlueAccent,
                  fontSize: 15,
                  decoration: TextDecoration.none,
                ),
              ),
            ),
          ),
          (_getAudioVolume(true) != null)
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 5.dp,
                      bottom: 55.dp,
                    ),
                    child: Text(
                      '音量 ${_getAudioVolume(true)!}',
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 15.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                )
              : Container(),
          (_getNetQuality(true) != null)
              ? Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: 5.dp,
                      bottom: 35.dp,
                    ),
                    child: Text(
                      '网络: ${Utils.networkQualityText(_getNetQuality(true)!)}',
                      softWrap: true,
                      style: TextStyle(
                        color: Colors.lightBlueAccent,
                        fontSize: 15.sp,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                )
              : Container(),
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
            _getView(false),
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  left: 5,
                  top: 5,
                ),
                child: Text(
                  '${_smallTitle()}',
                  softWrap: true,
                  style: TextStyle(
                    color: Colors.lightBlueAccent,
                    fontSize: 15,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ),
            (_getAudioVolume(false) != null)
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 5.dp,
                        bottom: 25.dp,
                      ),
                      child: Text(
                        '音量 ${_getAudioVolume(false)!}',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 15.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  )
                : Container(),
            (_getNetQuality(false) != null)
                ? Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: 5.dp,
                        bottom: 5.dp,
                      ),
                      child: Text(
                        '网络: ${Utils.networkQualityText(_getNetQuality(false)!)}',
                        softWrap: true,
                        style: TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 15.sp,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  void _switchView() async {
    _localIsBig = !_localIsBig;

    _localView = null;
    _remoteView = null;

    if (_localUserId != null) {
      await Utils.callEngine?.setVideoView(_localUserId!, null);
      _localView = await RCCallView.create(fit: BoxFit.cover);
      await Utils.callEngine?.setVideoView(_localUserId!, _localView);
    }
    if (_remoteUserId != null) {
      await Utils.callEngine?.setVideoView(_remoteUserId!, null);
      _remoteView = await RCCallView.create(fit: BoxFit.cover);
      await Utils.callEngine?.setVideoView(_remoteUserId!, _remoteView);
    }

    if (mounted) {
      setState(() {});
    }
  }

  Widget _buildChattingPage() {
    return WillPopScope(
      child: Scaffold(
        body: Container(
          color: Colors.white54,
          child: Stack(
            children: [
              _bigView(),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(
                    right: 10.dp,
                    top: 20.dp,
                  ),
                  child: _smallView(),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 35.dp,
                  ),
                  child: Container(
                    width: 400,
                    height: 200,
                    child: _myControlPanel(),
                  ),
                ),
              ),
              !_isShowBeautyPanel
                  ? Container()
                  : Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 150.dp,
                        ),
                        child: _beautyOptionPanel(),
                      ),
                    ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: EdgeInsets.only(
                    bottom: 100,
                  ),
                  child: Container(
                    width: 60,
                    height: 60,
                    child: IconButton(
                      icon: Icon(
                        Icons.call_end,
                        color: Colors.white,
                      ),
                      onPressed: _hangup,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: _exit,
    );
  }

  Widget _beautyOptionPanel() {
    return Container(
      color: Colors.white70,
      child: Wrap(
        children: <Widget>[
          Row(
            children: [
              Spacer(),
              CheckBoxes(
                '美颜开关',
                checked: _enableBeauty,
                onChanged: (checked) {
                  _enableBeauty = checked;
                  _setBeautyOption(_enableBeauty);
                },
              ),
              Spacer(),
              Text('美白：'),
              Slider(
                value: _whitenessValue.toDouble(),
                max: 9,
                min: 0,
                divisions: 9,
                label: '${_whitenessValue.round()}',
                onChanged: (value) {
                  setState(() {
                    _whitenessValue = value.round();
                  });
                },
                onChangeEnd: (double newValue) {
                  _whitenessValue = newValue.round();
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Text('红润：'),
              Slider(
                value: _ruddyValue.toDouble(),
                max: 9,
                min: 0,
                divisions: 9,
                label: '${_ruddyValue.round()}',
                onChanged: (value) {
                  setState(() {
                    _ruddyValue = value.round();
                  });
                },
                onChangeEnd: (double newValue) {
                  _ruddyValue = newValue.round();
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Text('磨皮：'),
              Slider(
                value: _smoothValue.toDouble(),
                max: 9,
                min: 0,
                divisions: 9,
                label: '${_smoothValue.round()}',
                onChanged: (value) {
                  setState(() {
                    _smoothValue = value.round();
                  });
                },
                onChangeEnd: (double newValue) {
                  _smoothValue = newValue.round();
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Text('亮度：'),
              Slider(
                value: _brightValue.toDouble(),
                max: 9,
                min: 0,
                divisions: 9,
                label: '${_brightValue.round()}',
                onChanged: (value) {
                  setState(() {
                    _brightValue = value.round();
                  });
                },
                onChangeEnd: (double newValue) {
                  _brightValue = newValue.round();
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
            ],
          ),
          Row(
            children: [
              Spacer(),
              Text('滤镜：', textScaleFactor: 1.2),
              Spacer(),
              Radios(
                '原画',
                value: RCBeautyFilter.none,
                groupValue: _beautyFilter,
                onChanged: (dynamic value) {
                  _beautyFilter = value;
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
              Spacer(),
              Radios(
                '唯美',
                value: RCBeautyFilter.esthetic,
                groupValue: _beautyFilter,
                onChanged: (dynamic value) {
                  _beautyFilter = value;
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
              Spacer(),
              Radios(
                '清新',
                value: RCBeautyFilter.fresh,
                groupValue: _beautyFilter,
                onChanged: (dynamic value) {
                  _beautyFilter = value;
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
              Spacer(),
              Radios(
                '浪漫',
                value: RCBeautyFilter.romantic,
                groupValue: _beautyFilter,
                onChanged: (dynamic value) {
                  _beautyFilter = value;
                  if (_enableBeauty) {
                    _setBeautyOption();
                  }
                  setState(() {});
                },
              ),
              Spacer(),
            ],
          ),
        ],
      ),
    );
  }

  void _showBeautyPanel(BuildContext context) async {
    if (_session!.mediaType == RCCallMediaType.audio) {
      '语音通话不能使用美颜功能'.toast();
      return;
    }

    Loading.show(context);
    _isShowBeautyPanel = !_isShowBeautyPanel;
    if (!_isShowBeautyPanel) {
      if (!_enableBeauty) {
        _setBeautyOption(false);
      }
    }
    setState(() {});
    Loading.dismiss(context);
  }

  /// 参数 beauty 为 false 时，去掉美颜效果
  void _setBeautyOption([bool beauty = true]) async {
    RCBeautyOptions options = RCBeautyOptions.create(
      whitenessLevel: _whitenessValue,
      smoothLevel: _smoothValue,
      ruddyLevel: _ruddyValue,
      brightLevel: _brightValue,
    );
    if (beauty) {
      await RCBeautyEngine.setBeautyOptions(_isShowBeautyPanel, options);
      await RCBeautyEngine.setBeautyFilter(_beautyFilter);
    } else {
      await RCBeautyEngine.resetBeauty();
      _enableBeauty = false;
      RCBeautyOptions options = await RCBeautyEngine.getCurrentBeautyOptions();
      _whitenessValue = options.whitenessLevel;
      _smoothValue = options.smoothLevel;
      _ruddyValue = options.ruddyLevel;
      _brightValue = options.brightLevel;

      RCBeautyFilter filter = await RCBeautyEngine.getCurrentBeautyFilter();
      _beautyFilter = filter;
    }
  }

  void _accept() async {
    bool ret = await presenter.accept();
    if (!ret) {
      'Accept Call Error $ret'.toast();
    }
  }

  void _enableCamera(bool enabled) async {
    if (_session!.mediaType == RCCallMediaType.audio) {
      '语音通话不能使用摄像头'.toast();
      return;
    }

    int result = await presenter.enableCamera(enabled);
    if (result == 0) {
      setState(() {
        _camera = enabled;
      });
    }

    if (enabled) {
      RCCallView? view;
      if (_state == AppState.chatting) {
        _localView = await RCCallView.create(mirror: true, fit: BoxFit.cover);
        view = _localView;
      }

      if (view != null) {
        _localUserId = _session?.mine.userId;
        await Utils.callEngine?.setVideoView(_localUserId!, view);
      }
    } else {
      _localView = null;
      await Utils.callEngine?.setVideoView(_localUserId!, null);
    }
  }

  void _switchCameraAction() async {
    if (_session!.mediaType == RCCallMediaType.audio) {
      '语音通话不能使用摄像头'.toast();
      return;
    }
    if (!_camera) {
      '请先开启摄像头'.toast();
      return;
    }
    await Utils.callEngine!.switchCamera();
  }

  void _microphoneAction() async {
    _microphone = !_microphone;
    await Utils.callEngine!.enableMicrophone(_microphone);
    setState(() {});
  }

  void _speakerAction() async {
    _speaker = !_speaker;
    await Utils.callEngine!.enableSpeaker(_speaker);
    setState(() {});
  }

  void _switchToAudioChat() async {
    if (_session!.mediaType == RCCallMediaType.audio) {
      return;
    }

    int ret = await Utils.callEngine!.changeMediaType(RCCallMediaType.audio);
    if (ret == 0) {
      _isShowBeautyPanel = false;
      _localView = null;
      await Utils.callEngine?.setVideoView(_localUserId!, null);

      _session = await Utils.callEngine!.getCurrentCallSession();
      setState(() {});
    }
  }

  void _hangup() async {
    Loading.show(context);
    await presenter.hangup(_session!.targetId);
    setState(() {});
    Loading.dismiss(context);
  }

  Future<bool> _exit() async {
    Loading.show(context);
    presenter.exit();
    return Future.value(false);
  }

  RCCallNetworkQuality? _getNetQuality(bool big) {
    if ((_localIsBig && big) || (!_localIsBig && !big)) {
      return _localNetQuality;
    }
    if ((_localIsBig && !big) || (!_localIsBig && big)) {
      return _remoteNetQuality;
    }

    return null;
  }

  int? _getAudioVolume(bool big) {
    if ((_localIsBig && big) || (!_localIsBig && !big)) {
      return _localAudioVolume;
    }
    if ((_localIsBig && !big) || (!_localIsBig && big)) {
      return _remoteAudioVolume;
    }

    return null;
  }

  @override
  void onConnect() async {
    _localUserId = _session?.mine.userId;
    _session?.users.forEach((user) {
      if (user.userId != _localUserId) {
        _remoteUserId = user.userId;
      }
    });

    _camera = true;
    _microphone = true;
    _speaker = false;

    Utils.callEngine?.enableMicrophone(_microphone);
    Utils.callEngine?.enableSpeaker(_speaker);

    _localView = await RCCallView.create(fit: BoxFit.cover);
    _remoteView = await RCCallView.create(fit: BoxFit.cover);

    _state = Utils.state;
    if (mounted) {
      setState(() {});
    }

    await Utils.callEngine?.setVideoView(_localUserId!, _localView);
    await Utils.callEngine?.setVideoView(_remoteUserId!, _remoteView);

    Utils.onRemoteUserDidChangeCameraState = (user, enable) async {
      if (enable) {
        if (_remoteView == null) {
          _remoteView = await RCCallView.create(fit: BoxFit.cover);
          await Utils.callEngine?.setVideoView(_remoteUserId!, _remoteView);
        }
      } else {
        if (_remoteView != null) {
          _remoteView = null;
          await Utils.callEngine?.setVideoView(_remoteUserId!, null);
        }
      }

      if (mounted) {
        setState(() {});
      }
    };
  }

  @override
  void onDisconnect(RCCallDisconnectReason reason) async {
    'Disconnect, reason = $reason'.toast();
    _state = Utils.state;
    _localView = null;
    _remoteView = null;

    _isShowBeautyPanel = false;

    await RCBeautyEngine.resetBeauty();
    await RCBeautyEngine.setBeautyOptions(false);

    Utils.onRemoteUserDidChangeCameraState = null;
    _pop(context);
  }

  @override
  void onCallError(int errorCode) {
    'onCallError code: $errorCode'.toast();
  }

  @override
  void onRemoteUserDidChangeMediaType(
      RCCallUserProfile user, RCCallMediaType mediaType) async {
    if (_state == AppState.chatting) {
      if (user.userId == _remoteUserId) {
        if (mediaType == RCCallMediaType.audio) {
          int result = await presenter.enableCamera(false);
          if (result == 0) {
            setState(() {
              _camera = false;
            });
          }

          _localView = null;
          Utils.callEngine!.setVideoView(_localUserId!, null);
          _isShowBeautyPanel = false;
        }
      }
    }
  }

  @override
  void onRemoteLeave(String userId, int reason) {
    Loading.dismiss(context);
    _pop(context);
  }

  @override
  void onNetworkQuality(RCCallUserProfile user, RCCallNetworkQuality quality) {
    if (user.userId == _remoteUserId) {
      _remoteNetQuality = quality;
    }
    if (user.userId == _localUserId) {
      _localNetQuality = quality;
    }
    setState(() {});
  }

  @override
  void onAudioVolume(RCCallUserProfile user, int volume) {
    if (user.userId == _remoteUserId) {
      _remoteAudioVolume = volume;
    }
    if (user.userId == _localUserId) {
      _localAudioVolume = volume;
    }
    setState(() {});
  }

  @override
  void onSwitchCamera(RCCallCamera camera) {
    if (_camera) {
      if (camera == RCCallCamera.back) {
        if (_localView != null) {
          _localView!.mirror = false;
        }
      } else {
        if (_localView != null) {
          _localView!.mirror = true;
        }
      }
    }
  }

  @override
  void onExit() {
    Loading.dismiss(context);
    _pop(context);
  }

  @override
  void onExitWithError(int code) {
    Loading.dismiss(context);
    'Exit with error, code = $code'.toast();
    _pop(context);
  }

  void _pop(BuildContext context) {
    if (!mounted) return;
    if (!_isPopping) {
      _isPopping = true;
      Navigator.pop(context);
    }
  }

  String _caller() {
    return _session?.caller?.userId ?? 'Unknown';
  }

  String _type() {
    if (_session?.mediaType == RCCallMediaType.audio_video) {
      return '视频通话';
    } else if (_session?.mediaType == RCCallMediaType.audio) {
      return '语音通话';
    }
    return '通话';
  }

  AppState _state = AppState.connected;

  late RCCallSession? _session;

  bool _isPopping = false;

  RCCallNetworkQuality? _remoteNetQuality;
  int? _remoteAudioVolume;

  RCCallNetworkQuality? _localNetQuality;
  int? _localAudioVolume;

  bool _localIsBig = true;
  RCCallView? _localView;
  String? _localUserId;
  RCCallView? _remoteView;
  String? _remoteUserId;

  // 美颜滤镜类型
  RCBeautyFilter _beautyFilter = RCBeautyFilter.none;

  // 美颜参数
  int _whitenessValue = 0;
  int _smoothValue = 0;
  int _ruddyValue = 0;
  int _brightValue = 5;

  bool _isShowBeautyPanel = false;
  bool _enableBeauty = false;
  bool _camera = true;
  bool _microphone = true;
  bool _speaker = true;
}
