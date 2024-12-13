import 'package:flutter/material.dart';
import 'package:flutter_call_plugin_example/data/data.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';

import 'connect_page_contract.dart';
import 'connect_page_model.dart';

class ConnectPagePresenter extends AbstractPresenter<RCView, Model> implements Presenter {
  @override
  IModel createModel() {
    return ConnectPageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
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

}
