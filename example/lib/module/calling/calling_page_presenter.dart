import 'package:flutter/widgets.dart';

import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';

import 'calling_page_contract.dart';
import 'calling_page_model.dart';

class ChattingPagePresenter extends AbstractPresenter<View, Model> implements Presenter {
  @override
  IModel createModel() {
    return ChattingPageModel();
  }

  @override
  Future<void> init(BuildContext context) async {
    Utils.onDisconnect = view.onDisconnect;
    Utils.onRemoteUserLeave = view.onRemoteLeave;
    Utils.onConnect = view.onConnect;
    Utils.onCallError = view.onCallError;
    Utils.onRemoteUserDidChangeMediaType = view.onRemoteUserDidChangeMediaType;
    Utils.onNetworkQuality = view.onNetworkQuality;
    Utils.onAudioVolume = view.onAudioVolume;
    Utils.onSwitchCamera = view.onSwitchCamera;
  }

  @override
  void exit() async {
    int ret = await model.exit();
    if (ret == 0) {
      view.onExit();
    } else {
      view.onExitWithError(ret);
    }

    Utils.onDisconnect = null;
    Utils.onRemoteUserLeave = null;
    Utils.onConnect = null;
    Utils.onCallError = null;
    Utils.onRemoteUserDidChangeMediaType = null;
    Utils.onNetworkQuality = null;
    Utils.onAudioVolume = null;
    Utils.onSwitchCamera = null;
  }

  @override
  Future<int> switchCamera() {
    return model.switchCamera();
  }

  @override
  Future<int> changeMediaType(RCCallMediaType mediaType) {
    return model.changeMediaType(mediaType);
  }

  @override
  Future<int> enableCamera(bool enabled, [RCCallCamera? camera]) async {
    return model.enableCamera(enabled);
  }

  @override
  Future<int> enableSpeaker(bool enabled) async {
    int ret = await model.enableSpeaker(enabled);
    return ret;
  }

  @override
  Future<int> resetBeauty() {
    return model.resetBeauty();
  }

  @override
  Future<bool> accept() async {
    bool ret = await model.accept();
    return ret;
  }

  @override
  Future<bool> hangup(String targetId) async {
    bool ret = await model.hangup(targetId);
    if (ret){
      view.onExit();
    }
    return ret;
  }

  @override
  Future<int> changeProfile(RCCallVideoProfile profile) {
    return model.changeProfile(profile);
  }
}
