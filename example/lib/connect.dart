// 创建一个链接页面, 包含一个 appkey 的输入框和一个 token 的输入框，点击连接按钮后，会调用 connect 方法，连接融云服务器。并且会跳转到下一个页面

// Path: example/lib/module/connect/connect_page.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_call_plugin_example/config.dart';
import 'package:flutter_call_plugin_example/router/router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rongcloud_call_wrapper_plugin/wrapper/rongcloud_call_engine.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
// import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';
import 'utils/utils.dart';

class Connect extends StatelessWidget {
  const Connect({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    requestPermission();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter call plugin'),
        ),
        body: Center(
          child: Column(
            children: [
              Divider(
                height: 50,
                color: Colors.transparent,
              ),
              //添加一个输入框，用于输入 appkey
              TextField(
                decoration: InputDecoration(
                  hintText: '请输入 AppKey, 如已在 config.dart 中配置，可不填',
                ),
              ),
              Divider(
                height: 50,
                color: Colors.transparent,
              ),
              // 添加一个输入框，用于输入 token
              TextField(
                decoration: InputDecoration(
                  hintText: '请输入 Token, 如已在 config.dart 中配置，可不填',
                ),
              ),
              Divider(
                height: 50,
                color: Colors.transparent,
              ),
              //添加一个按钮，用于连接融云服务器
              TextButton(
                  onPressed: () => _connect(context),
                  child: Text(
                    '连接融云服务器',
                    style: TextStyle(
                      color: Colors.green,
                      fontSize: 15,
                      decoration: TextDecoration.none,
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  // 连接融云服务器
  void _connect(BuildContext context) async {
    // 获取输入框的值
    // 调用 connect 方法，连接融云服务器
    // 跳转到 CallPage 页面

    RCIMIWEngineOptions options =
        RCIMIWEngineOptions.create(logLevel: RCIMIWLogLevel.verbose);
    Utils.imEngine = await RCIMIWEngine.create(AppConfig.app_key, options);
    Utils.callEngine = await RCCallEngine.create();
    // Utils.rtcEngine = await RCRTCEngine.create();

    String token = Platform.isAndroid ? AppConfig.token_a : AppConfig.token_b;

    Utils.imEngine?.connect(token, 0,
        callback: RCIMIWConnectCallback(onConnected: (code, userId) {
      print('onConnected: $code, $userId');
      Utils.currentUserId = userId;
      _toCallingPage(context);
    }));
  }

  void _toCallingPage(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    Navigator.pushNamed(
      context,
      RouterManager.CHATTING1V1,
    );
  }

  Future<bool> requestPermission() async {
    bool hasBluetoothPermission = await requestBluePermission();
    if (hasBluetoothPermission) {
      print("蓝牙权限申请通过");
      // setState(() {
      //   this.hasPermission = true;
      // });
    } else {
      print("蓝牙权限申请不通过");
      // this.hasPermission = false;
    }
    return hasBluetoothPermission;
  }

  Future<bool> requestBluePermission() async {
    //获取当前的权限
    var status = await Permission.bluetooth.status;
    if (status == PermissionStatus.granted) {
      //已经授权
      return true;
    } else {
      //未授权则发起一次申请
      status = await Permission.bluetooth.request();
      if (status == PermissionStatus.granted) {
        return true;
      } else {
        return false;
      }
    }
  }
}
