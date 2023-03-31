import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/presenter.dart';
import 'package:flutter_call_plugin_example/frame/template/mvp/view.dart';

abstract class View implements IView {
  void onConnect();

  void onDisconnect(RCCallDisconnectReason reason);

  void onCallError(int errorCode);

  void onRemoteUserDidChangeMediaType(RCCallUserProfile user, RCCallMediaType mediaType);

  void onRemoteLeave(String userId, int reason);

  void onNetworkQuality(RCCallUserProfile user, RCCallNetworkQuality quality);

  void onAudioVolume(RCCallUserProfile user, int volume);

  void onSwitchCamera(RCCallCamera camera);

  void onExit();

  void onExitWithError(int code);
}

abstract class Model implements IModel {
  Future<int> enableSpeaker(bool enabled);

  Future<int> enableCamera(bool enabled, [RCCallCamera? camera]);

  Future<int> changeMediaType(RCCallMediaType mediaType);

  Future<int> switchCamera();

  Future<int> resetBeauty();

  Future<bool> accept();

  Future<bool> hangup(String targetId);

  Future<int> changeProfile(RCCallVideoProfile profile);

  Future<int> exit();
}

abstract class Presenter implements IPresenter {
  Future<int> enableSpeaker(bool enabled);

  Future<int> enableCamera(bool enabled, [RCCallCamera? camera]);

  Future<int> changeMediaType(RCCallMediaType mediaType);

  Future<int> switchCamera();

  Future<int> resetBeauty();

  Future<bool> accept();

  Future<bool> hangup(String targetId);

  Future<int> changeProfile(RCCallVideoProfile profile);

  void exit();
}
