import 'package:flutter/widgets.dart';
import 'package:flutter_call_plugin_example/data/constants.dart';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'package:flutter_call_plugin_example/data/data.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';

import 'connect_page_contract.dart';
import 'connect_page_model.dart';

class ConnectPagePresenter extends AbstractPresenter<View, Model> implements Presenter {
  @override
  IModel createModel() {
    return ConnectPageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
    disconnect();
    model.load();
  }

  @override
  void clear() {
    model.clear();
    view.onClear();
  }

  @override
  Future<Result> token(String key, [String? userId]) {
    return model.token(key, userId);
  }

  @override
  void connect(
    String key,
    String navigate,
    String file,
    String media,
    String token,
  ) {
    model.connect(
      key,
      navigate,
      file,
      media,
      token,
      (code, info) {
        if (code != 0) {
          view.onConnectError(code, info);
        } else {
          view.onConnected(info);
        }
      },
    );
  }

  @override
  void disconnect() {
    model.disconnect();
  }

  @override
  void action(
    String targetId,
    RCCallMediaType type,
    RCCallMode mode,
  ) {
    model.action(
      targetId,
      type,
      mode,
      (code, session) {
        if (code != 0) {
          String errMsg = 'error $code';
          view.onError(code, errMsg);
        } else {
          view.onDone(session);
        }
      },
    );
  }
}
