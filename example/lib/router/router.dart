import 'package:flutter/widgets.dart';
import 'package:flutter_call_plugin_example/module/calling/calling_1v1_page.dart';

import 'package:flutter_call_plugin_example/module/connect/connect_page.dart';
import 'package:flutter_call_plugin_example/module/calling/calling_page.dart';

class RouterManager {
  static initRouters() {
    _routes = {
      CONNECT: (context) => ConnectPage(),
      CHATTING: (context) => ChattingPage(),
      CHATTING1V1: (context) => Chatting1v1Page(),
    };
    return _routes;
  }

  static const String CONNECT = '/connect';
  static const String CHATTING = '/chatting';
  static const String CHATTING1V1 = '/chatting1v1';

  static late Map<String, WidgetBuilder> _routes;
}
