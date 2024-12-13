
import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:flutter_call_plugin_example/data/data.dart';

abstract class RCView implements IView {
  void onConnected(String id);

  void onConnectError(int code, String? id);

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
}
