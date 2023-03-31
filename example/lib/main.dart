import 'package:flutter/services.dart';
import 'package:flutter/material.dart';

import 'package:context_holder/context_holder.dart';
// import 'package:wakelock/wakelock.dart';

import 'package:flutter_call_plugin_example/frame/utils/local_storage.dart';
import 'global_config.dart';
import 'router/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  LocalStorage.init().then((value) => runApp(const RCCallFlutter()));
}

class RCCallFlutter extends StatelessWidget {
  const RCCallFlutter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);

    // Wakelock.enable();

    return MaterialApp(
      navigatorKey: ContextHolder.key,
      title: GlobalConfig.appTitle,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: RouterManager.CONNECT,
      routes: RouterManager.initRouters(),
      // navigatorObservers: [
      //   LeakNavigatorObserver(),
      // ],
    );
  }
}
