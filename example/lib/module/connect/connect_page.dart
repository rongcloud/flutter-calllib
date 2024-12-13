import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:handy_toast/handy_toast.dart';

import 'package:flutter_call_plugin_example/data/data.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/frame/ui/loading.dart';
import 'package:flutter_call_plugin_example/frame/utils/extension.dart';
import 'package:flutter_call_plugin_example/global_config.dart';
import 'package:flutter_call_plugin_example/router/router.dart';
import 'package:flutter_call_plugin_example/widgets/ui.dart';

import '../../utils/utils.dart';
import 'connect_page_contract.dart';
import 'connect_page_presenter.dart';

// ignore: use_key_in_widget_constructors
class ConnectPage extends AbstractView {
  @override
  _ConnectPageState createState() => _ConnectPageState();
}

class _ConnectPageState extends AbstractViewState<ConnectPagePresenter, ConnectPage> implements RCView {
  @override
  ConnectPagePresenter createPresenter() {
    return ConnectPagePresenter();
  }

  @override
  void dispose() {
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
                Row(
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
                ),
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
                      '链接',
                      callback: () => _connect(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void init(BuildContext context) {}

  void _showInfo(BuildContext context) {
    String info = '默认参数: \n'
        'App Key:${GlobalConfig.appKey}\n'
        'Nav Server:${GlobalConfig.navServer}\n'
        'File Server:${GlobalConfig.fileServer}\n'
        'Media Server:${GlobalConfig.mediaServer.isEmpty ? '自动获取' : GlobalConfig.mediaServer}\n';

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

  @override
  void onConnected(String id) {
    Loading.dismiss(context);
    'IM Connected.'.toast();
    Utils.currentUserId = id;
    _toCallingPage(id);
  }

  @override
  void onConnectError(int code, String? id) {
    Loading.dismiss(context);
    'IM Connect Error, code = $code'.toast();
    Utils.currentUserId = id;
  }

  void _toCallingPage(String id) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pushNamed(
      context,
      RouterManager.CHATTING1V1,
    );
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

  RCCallMode _callMode = RCCallMode.private_chat;
}
