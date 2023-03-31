import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handy_toast/handy_toast.dart';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/data/data.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/frame/ui/loading.dart';
import 'package:flutter_call_plugin_example/frame/utils/extension.dart';
import 'package:flutter_call_plugin_example/global_config.dart';
import 'package:flutter_call_plugin_example/router/router.dart';
import 'package:flutter_call_plugin_example/widgets/ui.dart';

import 'connect_page_contract.dart';
import 'connect_page_presenter.dart';

// ignore: use_key_in_widget_constructors
class ConnectPage extends AbstractView {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends AbstractViewState<ConnectPagePresenter, ConnectPage> implements View {
  @override
  ConnectPagePresenter createPresenter() {
    return ConnectPagePresenter();
  }

  @override
  void dispose() {
    if (_state != AppState.disconnected) _disconnect();
    super.dispose();
  }

  @override
  Widget buildWidget(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'CallLib DEMO',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.info_outlined,
            ),
            onPressed: () => _showInfo(context),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10.dp),
        child: ListView(
          children: [
            Column(
              children: [
                (_state == AppState.disconnected)
                    ? Row(
                        children: [
                          DropdownButton(
                            hint: const Text('从缓存用户中选择'),
                            items: _buildUserItems(),
                            onChanged: (dynamic user) {
                              var localUser = user as User?;
                              if (localUser != null) {
                                _keyInputController.text = localUser.key!;
                                _navigateInputController.text = localUser.navigate!;
                                _fileInputController.text = localUser.file!;
                                _mediaInputController.text = localUser.media!;
                                _tokenInputController.text = localUser.token!;
                                _localUserInputController.text = localUser.id;
                              }
                            },
                          ),
                          const Spacer(),
                          Button(
                            '清空',
                            callback: () {
                              presenter.clear();
                              setState(() {});
                            },
                          ),
                        ],
                      )
                    : Container(),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                InputBox(
                  hint: 'App Key',
                  controller: _keyInputController,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9a-zA-Z]')),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                InputBox(
                  hint: 'Navigate Url',
                  controller: _navigateInputController,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\w\-\/\/\.:]')),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                InputBox(
                  hint: 'File Url',
                  controller: _fileInputController,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\w\-\/\/\.:]')),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                InputBox(
                  hint: 'Media Url',
                  controller: _mediaInputController,
                  formatter: [
                    FilteringTextInputFormatter.allow(RegExp(r'[\w\-\/\/\.:]')),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                InputBox(
                  hint: 'User Id, 必填',
                  controller: _localUserInputController,
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    Expanded(
                      child: InputBox(
                        hint: 'Token',
                        controller: _tokenInputController,
                      ),
                    ),
                    VerticalDivider(
                      width: 10.dp,
                      color: Colors.transparent,
                    ),
                    Button(
                      '生成',
                      callback: () => _token(context),
                    ),
                  ],
                ),
                Divider(
                  height: 10.dp,
                  color: Colors.transparent,
                ),
                Row(
                  children: [
                    const Spacer(),
                    Button(
                      _state != AppState.disconnected ? '断开链接' : '链接',
                      callback: () => _state != AppState.disconnected ? _disconnect() : _connect(),
                    ),
                  ],
                ),
                _state != AppState.disconnected
                    ? Container(
                        padding: EdgeInsets.only(top: 10.dp),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Radios(
                                  '单聊',
                                  value: RCCallMode.private_chat,
                                  groupValue: _callMode,
                                  onChanged: (dynamic value) {
                                    _inputController.text = '';
                                    setState(() {
                                      _callMode = value;
                                    });
                                  },
                                ),
                                const Spacer(),
                              ],
                            ),
                            Divider(
                              height: 10.dp,
                              color: Colors.transparent,
                            ),
                            _buildMediaType(context),
                            Divider(
                              height: 10.dp,
                              color: Colors.transparent,
                            ),
                            _mediaType == RCCallMediaType.audio_video
                                ? Padding(
                                    padding: EdgeInsets.only(top: 5.dp, bottom: 5.dp),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(color: Colors.blue),
                                      ),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        mainAxisSize: MainAxisSize.max,
                                        children: [
                                          Spacer(),
                                          Text(
                                            "profile 设置",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 15.sp,
                                              decoration: TextDecoration.none,
                                            ),
                                          ),
                                          Spacer(),
                                          Column(
                                            children: [
                                              Row(
                                                children: [
                                                  DropdownButtonHideUnderline(
                                                    child: DropdownButton(
                                                      isDense: true,
                                                      value: _videoConfig.profile,
                                                      items: videoProfileItems(),
                                                      onChanged: (dynamic profile) => _setVideoConfig(profile),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Spacer(),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(),
                            Divider(
                              height: 10.dp,
                              color: Colors.transparent,
                            ),
                            Row(
                              children: [
                                const Spacer(),
                                Button(
                                  _getAction(),
                                  callback: _action,
                                ),
                                const Spacer(),
                              ],
                            ),
                          ],
                        ),
                      )
                    : Container(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void init(BuildContext context) {}

  void _setVideoConfig(RCCallVideoProfile profile) async {
    _videoConfig = RCCallVideoConfig.create(profile: profile);
    await Utils.callEngine?.setVideoConfig(_videoConfig);
  }

  void _showInfo(BuildContext context) {
    String info = '默认参数: \n'
        'App Key:${GlobalConfig.appKey}\n'
        'Nav Server:${GlobalConfig.navServer}\n'
        'File Server:${GlobalConfig.fileServer}\n'
        'Media Server:${GlobalConfig.mediaServer.isEmpty ? '自动获取' : GlobalConfig.mediaServer}\n';
    if (_state != AppState.disconnected) {
      info += '当前使用: \n'
          'App Key:${DefaultData.user?.key}\n'
          'Nav Server:${DefaultData.user?.navigate}\n'
          'File Server:${DefaultData.user?.file}\n'
          'Media Server:${DefaultData.user?.media?.isEmpty ?? true ? '自动获取' : DefaultData.user?.media}\n';
    }
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('默认配置'),
          content: SelectableText(
            info,
          ),
          actions: [
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  List<DropdownMenuItem<User>> _buildUserItems() {
    List<DropdownMenuItem<User>> items = [];
    for (var user in DefaultData.users) {
      items.add(DropdownMenuItem(
        value: user,
        child: Text(
          '${user.key}-${user.id}',
          style: TextStyle(
            fontSize: 10.sp,
            color: Colors.black,
            decoration: TextDecoration.none,
          ),
        ),
      ));
    }
    return items;
  }

  void _token(BuildContext context) async {
    Loading.show(context);
    String key = _keyInputController.text;
    String? userId = _localUserInputController.text;
    if (userId.isEmpty) {
      userId = null;
    }
    Result result = await presenter.token(key, userId);
    if (result.code != 0) {
      result.content!.toast();
    } else {
      _tokenInputController.text = result.content!;
      if (result.userId?.isNotEmpty ?? false) {
        _localUserInputController.text = result.userId!;
      }
      if (_keyInputController.text.isEmpty) {
        _keyInputController.text = GlobalConfig.appKey;
      }
      if (_navigateInputController.text.isEmpty) {
        _navigateInputController.text = GlobalConfig.navServer;
      }
      if (_fileInputController.text.isEmpty) {
        _fileInputController.text = GlobalConfig.fileServer;
      }
      if (_mediaInputController.text.isEmpty) {
        _mediaInputController.text = GlobalConfig.mediaServer;
      }
    }
    Loading.dismiss(context);
  }

  void _disconnect() {
    presenter.disconnect();
    setState(() {
      _state = AppState.disconnected;
    });
  }

  void _connect() {
    FocusScope.of(context).requestFocus(FocusNode());

    String key = _keyInputController.text;
    String navigate = _navigateInputController.text;
    String file = _fileInputController.text;
    String media = _mediaInputController.text;
    String token = _tokenInputController.text;
    String localUserId = _localUserInputController.text;

    if (token.isEmpty) return '必须提供 Token 值'.toast();
    if (localUserId.isEmpty) return '请输入本地用户 Id'.toast();

    Loading.show(context);
    presenter.connect(key, navigate, file, media, token);
  }

  String _getHint() {
    switch (_callMode) {
      case RCCallMode.private_chat:
        return '请输入对方 Id';
      case RCCallMode.group_chat:
        return '请输入群聊参数';
    }
  }

  Widget _buildMediaType(BuildContext context) {
    switch (_callMode) {
      case RCCallMode.group_chat:
        return Container();
      case RCCallMode.private_chat:
        return Column(
          children: [
            InputBox(
              hint: '${_getHint()}.',
              controller: _inputController,
            ),
            Divider(
              height: 10.dp,
              color: Colors.transparent,
            ),
            Row(
              children: [
                const Spacer(),
                Radios(
                  '音视频模式',
                  value: RCCallMediaType.audio_video,
                  groupValue: _mediaType,
                  onChanged: (dynamic value) {
                    setState(() {
                      _mediaType = value;
                    });
                  },
                ),
                const Spacer(),
                Radios(
                  '音频模式',
                  value: RCCallMediaType.audio,
                  groupValue: _mediaType,
                  onChanged: (dynamic value) {
                    setState(() {
                      _mediaType = value;
                    });
                  },
                ),
                const Spacer(),
              ],
            ),
          ],
        );
    }
  }

  String _getAction() {
    switch (_callMode) {
      case RCCallMode.private_chat:
        return '呼叫';
      case RCCallMode.group_chat:
        return '加入群聊';
    }
  }

  void _action() {
    String targetId = _inputController.text;
    if (targetId.isEmpty) return '${_getHint()}'.toast();

    if (_localUserInputController.text.isEmpty) return '请输入本地用户 Id'.toast();

    Loading.show(context);
    RCCallMediaType type = _mediaType;
    FocusScope.of(context).requestFocus(FocusNode());
    presenter.action(targetId, type, _callMode);
  }

  Future<void> _initEngine() async {
    RCCallAudioConfig audioConfig = RCCallAudioConfig.create();
    await Utils.callEngine?.setAudioConfig(audioConfig);
    await Utils.callEngine?.setVideoConfig(_videoConfig);

    Utils.onReceiveCall = (RCCallSession session) {
      _toCallingPage(session);
    };
  }

  @override
  void onConnected(String id) {
    Loading.dismiss(context);
    'IM Connected.'.toast();
    _initEngine();
    setState(() {
      _state = AppState.connected;
    });
  }

  @override
  void onConnectError(int code, String? id) {
    Loading.dismiss(context);
    'IM Connect Error, code = $code'.toast();
    setState(() {
      _state = AppState.disconnected;
    });
  }

  @override
  void onDone(RCCallSession? session) {
    Loading.dismiss(context);
    switch (_callMode) {
      case RCCallMode.private_chat:
        _toCallingPage(session);
        break;
      case RCCallMode.group_chat:
        '暂不提供群聊页面'.toast();
        break;
    }
  }

  void _toCallingPage(RCCallSession? session) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pushNamed(
      context,
      RouterManager.CHATTING1V1,
      arguments: session,
    );
  }

  @override
  void onError(int code, String? errMsg) {
    Loading.dismiss(context);
    'Error: ${_getAction()}, code = $code, errMsg = $errMsg'.toast();
  }

  @override
  void onClear() {
    _keyInputController.clear();
    _navigateInputController.clear();
    _fileInputController.clear();
    _mediaInputController.clear();
    _localUserInputController.clear();
    _tokenInputController.clear();
    _inputController.clear();
  }

  final TextEditingController _keyInputController = TextEditingController();
  final TextEditingController _navigateInputController = TextEditingController();
  final TextEditingController _fileInputController = TextEditingController();
  final TextEditingController _mediaInputController = TextEditingController();
  final TextEditingController _localUserInputController = TextEditingController();
  final TextEditingController _tokenInputController = TextEditingController();
  final TextEditingController _inputController = TextEditingController();

  AppState _state = AppState.disconnected;
  RCCallMediaType _mediaType = RCCallMediaType.audio_video;
  RCCallMode _callMode = RCCallMode.private_chat;

  late RCCallVideoConfig _videoConfig = RCCallVideoConfig.create(profile: RCCallVideoProfile.profile_1080_1920_high);
}
