import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:context_holder/context_holder.dart';
// import 'package:wakelock/wakelock.dart';

import 'package:flutter_call_plugin_example/frame/utils/local_storage.dart';
import 'global_config.dart';
import 'router/router.dart';

void main() {
  // 确保Flutter已初始化。
  WidgetsFlutterBinding.ensureInitialized();
  
  // 初始化本地存储，然后运行应用程序。
  LocalStorage.init().then((value) => runApp(const RCCallFlutter()));
}

class RCCallFlutter extends StatelessWidget {
  const RCCallFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 设置首选方向为垂直向上和垂直向下。
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 定义系统UI叠加样式，包括透明状态栏和暗色图标。
    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    // 启用设备唤醒锁定。
    // Wakelock.enable();

    return MaterialApp(
      // 使用Context Holder插件的导航键。
      navigatorKey: ContextHolder.key,
      // 设置应用程序的标题。
      title: GlobalConfig.appTitle,
      // 设置应用程序的主题数据。
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // 设置应用程序的初始路由。
      initialRoute: RouterManager.CONNECT,
      // 初始化路由表。
      routes: RouterManager.initRouters(),
      // 注释掉的部分可以用于添加导航观察器。
      // navigatorObservers: [
      //   LeakNavigatorObserver(),
      // ],
    );
  }
}