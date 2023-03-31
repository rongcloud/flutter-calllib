import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/data/data.dart';

abstract class View implements IView {
  void onConnected(String id);

  void onConnectError(int code, String? id);

  void onDone(RCCallSession? session);

  void onError(int code, String? errMsg);

  void onClear();
}

abstract class Model implements IModel {
  void load();

  void clear();

  Future<Result> token(String key, [String? userId]);

  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
    StateCallback callback,
  );

  void disconnect();

  void action(
    String targetId,
    RCCallMediaType mediaType,
    RCCallMode mode,
    StartCallCallback callback,
  );
}

abstract class Presenter implements IPresenter {
  void clear();

  Future<Result> token(String key, [String? userId]);

  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
  );

  void disconnect();

  void action(
    String id,
    RCCallMediaType type,
    RCCallMode mode,
  );
}
