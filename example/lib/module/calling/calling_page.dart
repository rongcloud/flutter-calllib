import 'dart:async';

import 'package:flutter/material.dart';
import 'package:handy_toast/handy_toast.dart';
import 'package:rongcloud_beauty_wrapper_plugin/rongcloud_beauty_wrapper_plugin.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_constants.dart';
import 'package:rongcloud_beauty_wrapper_plugin/wrapper/rongcloud_beauty_options.dart';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/frame/ui/loading.dart';
import 'package:flutter_call_plugin_example/frame/utils/extension.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';
import 'package:flutter_call_plugin_example/widgets/ui.dart';

import 'calling_page_contract.dart';
import 'calling_page_presenter.dart';

class ChattingPage extends AbstractView {
  @override
  _ChattingPageState createState() => _ChattingPageState();
}

class _ChattingPageState extends AbstractViewState<ChattingPagePresenter, ChattingPage> implements View {
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
    return Stack(
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
    );
  }

  Widget _buildChattingPage() {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Text(Utils.stateText(_state)),
          actions: [
            IconButton(
              icon: Icon(
                _beauty ? Icons.face_retouching_natural : Icons.face,
              ),
              onPressed: () => _beautySwitch(context),
            ),
            IconButton(
              icon: Icon(
                Icons.control_camera,
              ),
              onPressed: () => _enableCamera(!_camera),
            ),
          ],
        ),
        body: Container(
          color: Colors.white54,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 200.dp,
                          height: 160.dp,
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              _localVideo(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 5.dp,
                                  ),
                                  child: Text(
                                    '$_localUserId',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 15.dp,
                                  ),
                                  child: BoxFitChooser(
                                    fit: _localView?.fit ?? BoxFit.cover,
                                    onSelected: (fit) {
                                      setState(() {
                                        _localView?.fit = fit;
                                      });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        _myControlPanel(),
                        Spacer(),
                      ],
                    ),
                    _beauty
                        ? Padding(
                            // 美颜
                            padding: EdgeInsets.all(5.dp),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                              ),
                              child: _beautyOptionPanel(),
                            ),
                          )
                        : Container(),
                    Divider(
                      height: 10.dp,
                      color: Colors.transparent,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 200.dp,
                          height: 160.dp,
                          color: Colors.blue,
                          child: Stack(
                            children: [
                              _remoteView ?? Container(),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 5.dp,
                                  ),
                                  child: Text(
                                    '$_remoteUserId',
                                    softWrap: true,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 15.sp,
                                      decoration: TextDecoration.none,
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left: 5.dp,
                                    top: 15.dp,
                                  ),
                                  child: BoxFitChooser(
                                    fit: _remoteView?.fit ?? BoxFit.contain,
                                    onSelected: (fit) {
                                      setState(() {
                                        _remoteView?.fit = fit;
                                      });
                                    },
                                  ),
                                ),
                              ),
                              (_remoteUserAudioVolume != null)
                                  ? Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          left: 5.dp,
                                          bottom: 5.dp,
                                        ),
                                        child: Text(
                                          '音量 ${_remoteUserAudioVolume!}',
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
                              (_remoteUserNetQuality != null)
                                  ? Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                          right: 5.dp,
                                          bottom: 5.dp,
                                        ),
                                        child: Text(
                                          '网络: ${Utils.networkQualityText(_remoteUserNetQuality!)}',
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
                        // Spacer(),
                        //  Container(),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      onWillPop: _exit,
    );
  }

  Widget _buildRingingPage() {
    return Stack(
      children: [
        // _background ?? Container(),
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
    );
  }

  Widget _buildCallingPage() {
    return Stack(
      children: [
        // _background ?? Container(),
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
      // decoration: BoxDecoration(
      //   border: Border.all(),
      // ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _isAudioOnly()
              ? Container()
              : Row(
                  children: [
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
              (_state == AppState.chatting)
                  ? Button(
                      '结束通话',
                      callback: _hangup,
                    )
                  : Container(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _beautyOptionPanel() {
    return Wrap(
      children: <Widget>[
        (_selectedOption != AppBeautyOption.filter)
            ? Slider(
                value: _currentBeautyValue(),
                max: 9,
                min: 0,
                divisions: 9,
                label: '${_currentBeautyValue().round()}',
                onChanged: (value) {
                  setState(() {
                    _setCurrentBeautyValue(value.round());
                  });
                },
                onChangeEnd: (double newValue) {
                  _setCurrentBeautyValue(newValue.round());
                  _setBeautyOption();
                  setState(() {});
                },
              )
            : Row(
                children: [
                  Spacer(),
                  Radios(
                    '原画',
                    value: RCCallBeautyFilter.none,
                    groupValue: _beautyFilter,
                    onChanged: (dynamic value) {
                      _beautyFilter = value;
                      _setBeautyOption();
                      setState(() {});
                    },
                  ),
                  Spacer(),
                  Radios(
                    '唯美',
                    value: RCCallBeautyFilter.esthetic,
                    groupValue: _beautyFilter,
                    onChanged: (dynamic value) {
                      _beautyFilter = value;
                      _setBeautyOption();
                      setState(() {});
                    },
                  ),
                  Spacer(),
                  Radios(
                    '清新',
                    value: RCCallBeautyFilter.fresh,
                    groupValue: _beautyFilter,
                    onChanged: (dynamic value) {
                      _beautyFilter = value;
                      _setBeautyOption();
                      setState(() {});
                    },
                  ),
                  Spacer(),
                  Radios(
                    '浪漫',
                    value: RCCallBeautyFilter.romantic,
                    groupValue: _beautyFilter,
                    onChanged: (dynamic value) {
                      _beautyFilter = value;
                      _setBeautyOption();
                      setState(() {});
                    },
                  ),
                  Spacer(),
                ],
              ),
        Row(
          children: [
            Spacer(),
            RawChip(
              label: Text('滤镜'),
              selected: _selectedOption == AppBeautyOption.filter,
              onSelected: (v) {
                if (v) {
                  _selectedOption = AppBeautyOption.filter;
                }
                setState(() {});
              },
              selectedColor: Colors.blue,
              selectedShadowColor: Colors.red,
            ),
            Spacer(),
            RawChip(
              label: Text('美白'),
              selected: _selectedOption == AppBeautyOption.whiteness,
              onSelected: (v) {
                if (v) {
                  _selectedOption = AppBeautyOption.whiteness;
                }
                setState(() {});
              },
              selectedColor: Colors.blue,
              selectedShadowColor: Colors.red,
            ),
            Spacer(),
            RawChip(
              label: Text('红润'),
              selected: _selectedOption == AppBeautyOption.ruddy,
              onSelected: (v) {
                if (v) {
                  _selectedOption = AppBeautyOption.ruddy;
                }
                setState(() {});
              },
              selectedColor: Colors.blue,
              selectedShadowColor: Colors.red,
            ),
            Spacer(),
            RawChip(
              label: Text('磨皮'),
              selected: _selectedOption == AppBeautyOption.smooth,
              onSelected: (v) {
                if (v) {
                  _selectedOption = AppBeautyOption.smooth;
                }
                setState(() {});
              },
              selectedColor: Colors.blue,
              selectedShadowColor: Colors.red,
            ),
            Spacer(),
            RawChip(
              label: Text('亮度'),
              selected: _selectedOption == AppBeautyOption.bright,
              onSelected: (v) {
                if (v) {
                  _selectedOption = AppBeautyOption.bright;
                }
                setState(() {});
              },
              selectedColor: Colors.blue,
              selectedShadowColor: Colors.red,
            ),
            Spacer(),
          ],
        ),
      ],
    );
  }

  Widget _localVideo() {
    if (_state == AppState.chatting && _localView != null) {
      return _localView!;
    }

    return Container();
  }

  void _beautySwitch(BuildContext context) async {
    if (_session!.mediaType == RCCallMediaType.audio) {
      '语音通话不能使用美颜功能'.toast();
      return;
    }

    Loading.show(context);
    _beauty = !_beauty;
    if (!_beauty) {
      await presenter.resetBeauty();
      RCBeautyOptions option = await RCBeautyEngine.getCurrentBeautyOptions();

      _whitenessValue = option.whitenessLevel;
      _smoothValue = option.smoothLevel;
      _ruddyValue = option.ruddyLevel;
      _brightValue = option.brightLevel;

      _beautyFilter = RCBeautyFilter.none;
      _selectedOption = AppBeautyOption.filter;
    } else {
      _setBeautyOption();
    }
    setState(() {});
    Loading.dismiss(context);
  }

  void _setBeautyOption() async {
    RCBeautyOptions option = RCBeautyOptions.create(
      whitenessLevel: _whitenessValue,
      smoothLevel: _smoothValue,
      ruddyLevel: _ruddyValue,
      brightLevel: _brightValue,
    );
    await RCBeautyEngine.setBeautyOptions(_beauty, option);
    await RCBeautyEngine.setBeautyFilter(_beautyFilter);
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
      _beauty = false;
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

    _beauty = false;
    await RCBeautyEngine.setBeautyFilter(RCBeautyFilter.none);
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
  void onRemoteUserDidChangeMediaType(RCCallUserProfile user, RCCallMediaType mediaType) async {
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
          _beauty = false;
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
      _remoteUserNetQuality = quality;
      setState(() {});
    }
  }

  @override
  void onAudioVolume(RCCallUserProfile user, int volume) {
    if (user.userId == _remoteUserId) {
      _remoteUserAudioVolume = volume;
      setState(() {});
    }
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

  double _currentBeautyValue() {
    switch (_selectedOption) {
      case AppBeautyOption.filter:
        return 0;
      case AppBeautyOption.whiteness:
        return _whitenessValue.toDouble();
      case AppBeautyOption.smooth:
        return _smoothValue.toDouble();
      case AppBeautyOption.ruddy:
        return _ruddyValue.toDouble();
      case AppBeautyOption.bright:
        return _brightValue.toDouble();
    }
  }

  void _setCurrentBeautyValue(int value) {
    switch (_selectedOption) {
      case AppBeautyOption.filter:
        return;
      case AppBeautyOption.whiteness:
        _whitenessValue = value;
        break;
      case AppBeautyOption.smooth:
        _smoothValue = value;
        break;
      case AppBeautyOption.ruddy:
        _ruddyValue = value;
        break;
      case AppBeautyOption.bright:
        _brightValue = value;
        break;
    }
  }

  AppState _state = AppState.connected;

  late RCCallSession? _session;

  bool _isPopping = false;

  RCCallNetworkQuality? _remoteUserNetQuality;
  int? _remoteUserAudioVolume;

  RCCallView? _localView;
  String? _localUserId;
  RCCallView? _remoteView;
  String? _remoteUserId;

  // 当前选择的美颜选项
  AppBeautyOption _selectedOption = AppBeautyOption.filter;

  // 美颜滤镜类型
  RCBeautyFilter _beautyFilter = RCBeautyFilter.none;

  // 美颜参数
  int _whitenessValue = 0;
  int _smoothValue = 0;
  int _ruddyValue = 0;
  int _brightValue = 5;

  bool _beauty = false;
  bool _camera = true;
  bool _microphone = true;
  bool _speaker = true;
}
