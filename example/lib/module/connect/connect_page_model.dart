import 'dart:async';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/data/data.dart';
import 'package:flutter_call_plugin_example/frame/network/network.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/global_config.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
// import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';

import 'connect_page_contract.dart';

class ConnectPageModel extends AbstractModel implements Model {
  @override
  void clear() {
    DefaultData.clear();
  }

  @override
  void load() {
    DefaultData.loadUsers();
  }

  @override
  Future<Result> token(String key, [String? userId]) {
    if (key.isEmpty) key = GlobalConfig.appKey;
    int current = DateTime.now().millisecondsSinceEpoch;
    String id = '${GlobalConfig.prefix}$current';
    if (userId != null) {
      id = userId;
    }
    Completer<Result> completer = Completer();
    Http.post(
      GlobalConfig.host + '/token/$id',
      {'key': key},
      (error, data) {
        String? token = data['token'];
        String? userId = data['userId'];
        completer.complete(Result(0, token, userId));
      },
      (error) {
        completer.complete(Result(-1, 'Get token error.', null));
      },
      tag,
    );
    return completer.future;
  }

  @override
  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
    StateCallback callback,
  ) async {
    if (key.isEmpty) key = GlobalConfig.appKey;
    if (navigate.isEmpty) navigate = GlobalConfig.navServer;
    if (file.isEmpty) file = GlobalConfig.fileServer;
    if (media.isEmpty) media = GlobalConfig.mediaServer;

    RCIMIWEngineOptions options = RCIMIWEngineOptions.create(logLevel: RCIMIWLogLevel.verbose);
    options.naviServer = navigate;
    options.fileServer = file;

    Utils.imEngine = await RCIMIWEngine.create(key, options);
    Utils.callEngine = await RCCallEngine.create();
    // Utils.rtcEngine = await RCRTCEngine.create();

    Utils.imEngine?.onConnected = (int? code, String? userId) {
      if (code == 0) {
        User user = User.create(
          userId!,
          key,
          navigate,
          file,
          media,
          token,
        );
        DefaultData.user = user;
      }
      callback(code, userId);
    };
    await Utils.imEngine?.connect(token, 0);
  }
}
