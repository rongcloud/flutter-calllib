import 'dart:async';

import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:rongcloud_beauty_wrapper_plugin/rongcloud_beauty_wrapper_plugin.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

import 'package:flutter_call_plugin_example/frame/template/mvp/model.dart';
import 'package:flutter_call_plugin_example/utils/utils.dart';

import 'calling_page_contract.dart';

class ChattingPageModel extends AbstractModel implements Model {
  @override
  Future<int> enableSpeaker(bool enabled) async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      int ret = await Utils.callEngine!.enableSpeaker(enabled);
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<int> switchCamera() async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      int ret = await Utils.callEngine!.switchCamera();
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<int> changeMediaType(RCCallMediaType mediaType) async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      int ret = await Utils.callEngine!.changeMediaType(mediaType);
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<int> enableCamera(bool enabled, [RCCallCamera? camera]) async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      int ret = await Utils.callEngine!.enableCamera(enabled, camera);
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<int> resetBeauty() async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      int ret = await RCBeautyEngine.resetBeauty();
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<bool> accept() async {
    if (Utils.callEngine != null) {
      Completer<bool> completer = Completer();
      int ret = await Utils.callEngine!.accept();
      completer.complete(ret == 0);
      return completer.future;
    }
    return Future.value(false);
  }

  @override
  Future<bool> hangup(String targetId) async {
    if (Utils.callEngine != null) {
      Completer<bool> completer = Completer();
      int ret = await Utils.hangup();
      completer.complete(ret == 0);
      return completer.future;
    }
    return Future.value(false);
  }

  @override
  Future<int> changeProfile(RCCallVideoProfile profile) async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      RCCallVideoConfig config = RCCallVideoConfig.create(profile: profile);
      int ret = await Utils.callEngine!.setVideoConfig(config);
      completer.complete(ret);
      return completer.future;
    }
    return Future.value(-1);
  }

  @override
  Future<int> exit() async {
    if (Utils.callEngine != null) {
      Completer<int> completer = Completer();
      AppState state = Utils.state;
      if (state == AppState.calling || state == AppState.ringing || state == AppState.chatting) {
        int ret = await Utils.callEngine!.hangup();
        if (ret != 0) {
          print('hangup error $ret');
        }
        completer.complete(0);
      } else {
        print('calling page model: exit|wrong state: $state');
        await Utils.callEngine!.hangup();
        completer.complete(0);
      }
      return completer.future;
    }
    return Future.value(0);
  }
}
