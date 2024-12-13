import 'package:flutter/widgets.dart';
import 'package:flutter_call_plugin_example/call.dart';
import 'package:flutter_call_plugin_example/config.dart';
import 'package:flutter_call_plugin_example/connect.dart';
import 'package:flutter_call_plugin_example/module/connect/connect_page.dart';

class RouterManager {
  static initRouters() {
    _routes = {
      CONNECT: (context) => AppConfig.isDebug ? ConnectPage() : Connect(),
      CHATTING1V1: (context) => CallPage(),
    };
    return _routes;
  }

  static const String CONNECT = '/connect';
  static const String CHATTING1V1 = '/chatting1v1';

  static late Map<String, WidgetBuilder> _routes;
}
