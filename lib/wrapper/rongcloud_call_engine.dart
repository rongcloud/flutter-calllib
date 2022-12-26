import 'dart:async';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'rongcloud_call_abstract.dart';
import 'rongcloud_call_constants.dart';
import 'rongcloud_call_module.dart';

part 'rongcloud_call_view.dart';

class RCCallSession {
  RCCallSession.fromJson(Map<dynamic, dynamic> json)
      : callType = RCCallCallType.values[json["callType"]],
        mediaType = RCCallMediaType.values[json["mediaType"]],
        callId = json['callId'],
        targetId = json['targetId'],
        sessionId = json['sessionId'],
        startTime = json['startTime'],
        connectedTime = json['connectedTime'],
        endTime = json['endTime'],
        caller = json['caller'] != null ? RCCallUserProfile.fromJson(json['caller']) : null,
        inviter = json['inviter'] != null ? RCCallUserProfile.fromJson(json['inviter']) : null,
        mine = RCCallUserProfile.fromJson(json['mine']),
        extra = json['extra'],
        users = [] {
    var userList = json['users'];
    if (userList != null) {
      for (var element in userList) {
        if (element != null) {
          var user = RCCallUserProfile.fromJson(element);
          users.add(user);
        }
      }
    }
  }

  void _updateFromJson(Map<dynamic, dynamic> json) {
    callType = RCCallCallType.values[json["callType"]];
    mediaType = RCCallMediaType.values[json["mediaType"]];
    callId = json['callId'];
    targetId = json['targetId'];
    sessionId = json['sessionId'];
    startTime = json['startTime'];
    connectedTime = json['connectedTime'];
    endTime = json['endTime'];
    caller = json['caller'] != null ? RCCallUserProfile.fromJson(json['caller']) : null;
    inviter = json['inviter'] != null ? RCCallUserProfile.fromJson(json['inviter']) : null;
    mine = RCCallUserProfile.fromJson(json['mine']);
    extra = json['extra'];
    users.clear();
    var userList = json['users'];
    if (userList != null) {
      for (var element in userList) {
        if (element != null) {
          var user = RCCallUserProfile.fromJson(element);
          users.add(user);
        }
      }
    }
  }

  /// 通话类型
  RCCallCallType callType;

  /// 通话媒体类型
  RCCallMediaType mediaType;

  /// 通话id
  String callId;

  /// 通话目标 id
  String targetId;

  /// RTC 会话唯一标识, 用于 Server API
  String? sessionId;

  /// 通话的扩展信息
  String? extra;

  /// 通话开始的时间
  ///
  /// 如果是用户呼出的通话，则 startTime 为通话呼出时间；如果是呼入的通话，则 startTime 为通话呼入时间。
  int startTime;

  /// 通话接通时间
  int connectedTime;

  /// 通话结束时间
  int endTime;

  /// 当前通话发起者
  RCCallUserProfile? caller;

  /// 邀请当前用户到当前通话的邀请者
  RCCallUserProfile? inviter;

  /// 当前用户
  RCCallUserProfile mine;

  /// 当前通话的全部用户列表
  List<RCCallUserProfile> users;
}

class RCCallEngine extends CallEngine {
  RCCallEngine._() : _channel = const MethodChannel('cn.rongcloud.call.flutter/engine') {
    _channel.setMethodCallHandler(_handler);
  }

  static Future<RCCallEngine> create() {
    _instance ??= RCCallEngine._();
    return _instance!._create();
  }

  Future<RCCallEngine> _create() async {
    await _channel.invokeMethod('create');
    return Future.value(this);
  }

  Future<dynamic> _handler(MethodCall call) async {
    switch (call.method) {
      case 'engine:didReceiveCall':
        Map<dynamic, dynamic> arguments = call.arguments;
        _currentSession = RCCallSession.fromJson(arguments);
        onReceiveCall?.call(_currentSession!);
        break;
      case 'engine:callDidConnect':
        await getCurrentCallSession();
        onConnect?.call();
        break;
      case 'engine:callDidDisconnect':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        int reason = arguments['reason'];
        onDisconnect?.call(RCCallDisconnectReason.values[reason]);
        _currentSession = null;
        break;
      // case 'engine:remoteUserDidJoin':
      //   await getCurrentCallSession();
      //   Map<dynamic, dynamic> arguments = call.arguments;
      //   var userProfile = RCCallUserProfile.fromJson(arguments);
      //   onRemoteUserJoin?.call(userProfile);
      //   break;
      // case 'engine:remoteUserDidLeave':
      //   await getCurrentCallSession();
      //   Map<dynamic, dynamic> arguments = call.arguments;
      //   int reason = arguments['reason'];
      //   String userId = arguments['userId'];
      //   onRemoteUserLeave?.call(userId, reason);
      //   break;

      // optional event
      case 'engine:didEnableCamera':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        RCCallCamera camera = RCCallCamera.values[arguments['camera']];
        bool enabled = arguments['enabled'];
        onEnableCamera?.call(camera, enabled);
        break;
      case 'engine:didSwitchCamera':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        RCCallCamera camera = RCCallCamera.values[arguments['camera']];
        onSwitchCamera?.call(camera);
        break;
      case 'engine:callDidError':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        int errorCode = arguments['errorCode'];
        onCallError?.call(errorCode);
        break;
      case 'engine:callDidMake':
        await getCurrentCallSession();
        onCallDidMake?.call();
        break;
      case 'engine:remoteUserDidRing':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        String userId = arguments['userId'];
        onRemoteUserDidRing?.call(userId);
        break;
      // case 'engine:remoteUserDidInvite':
      //   await getCurrentCallSession();
      //   Map<dynamic, dynamic> arguments = call.arguments;
      //   String userId = arguments['userId'];
      //   RCCallMediaType mediaType = RCCallMediaType.values[arguments['mediaType']];
      //   onRemoteUserDidInvite?.call(userId, mediaType);
      //   break;
      case 'engine:remoteUserDidChangeMediaType':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        var user = RCCallUserProfile.fromJson(arguments['user']);
        RCCallMediaType mediaType = RCCallMediaType.values[arguments['mediaType']];
        onRemoteUserDidChangeMediaType?.call(user, mediaType);
        break;
      case 'engine:remoteUserDidChangeMicrophoneState':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        var user = RCCallUserProfile.fromJson(arguments['user']);
        bool enabled = arguments['enabled'];
        onRemoteUserDidChangeMicrophoneState?.call(user, enabled);
        break;
      case 'engine:remoteUserDidChangeCameraState':
        await getCurrentCallSession();
        Map<dynamic, dynamic> arguments = call.arguments;
        var user = RCCallUserProfile.fromJson(arguments['user']);
        bool enabled = arguments['enabled'];
        onRemoteUserDidChangeCameraState?.call(user, enabled);
        break;
      case 'engine:networkQuality':
        Map<dynamic, dynamic> arguments = call.arguments;
        var user = RCCallUserProfile.fromJson(arguments['user']);
        var quality = RCCallNetworkQuality.values[arguments['quality']];
        onNetworkQuality?.call(user, quality);
        break;
      case 'engine:audioVolume':
        Map<dynamic, dynamic> arguments = call.arguments;
        var user = RCCallUserProfile.fromJson(arguments['user']);
        int volume = arguments['volume'];
        onAudioVolume?.call(user, volume);
        break;
    }
  }

  /// 配置推送
  ///
  /// [config]          呼叫推送配置
  /// [hangupConfig]    挂断推送配置
  /// [enableApple] 设置是否使用苹果 PushKit 推送， true 使用, false 不使用
  Future<int> setPushConfig(RCCallPushConfig config, RCCallPushConfig hangupConfig, [bool? enableApple]) async {
    Map<String, dynamic> arguments = {'push': config.toJson(), 'hangupPush': hangupConfig.toJson()};
    if (enableApple != null) {
      arguments['useApple'] = enableApple;
    }
    int code = await _channel.invokeMethod('setPushConfig', arguments) ?? -1;
    return code;
  }

  Future<RCCallSession?> startCall(String targetId, RCCallMediaType mediaType, [String? extra]) async {
    Map<String, dynamic> arguments = {
      'targetId': targetId,
      'mediaType': mediaType.index,
      'extra': extra,
    };
    Map? result = await _channel.invokeMethod('startCall', arguments);
    if (result != null) {
      _currentSession = RCCallSession.fromJson(result);
    }
    // TODO 调用失败current session是否置空？
    return _currentSession;
  }

  /// 配置音频
  ///
  /// [config] 音频配置
  Future<int> setAudioConfig(RCCallAudioConfig config) async {
    Map<String, dynamic> arguments = config.toJson();
    int code = await _channel.invokeMethod('setAudioConfig', arguments) ?? -1;
    return code;
  }

  /// 配置视频
  ///
  /// [config] 视频配置
  Future<int> setVideoConfig(RCCallVideoConfig config) async {
    Map<String, dynamic> arguments = config.toJson();
    int code = await _channel.invokeMethod('setVideoConfig', arguments) ?? -1;
    return code;
  }

  /// 获取当前通话 Session
  ///
  /// return 当前通话 Session
  Future<RCCallSession?> getCurrentCallSession() async {
    Map? result = await _channel.invokeMethod('getCurrentCallSession');
    if (result != null) {
      if (_currentSession != null) {
        _currentSession?._updateFromJson(result);
      } else {
        _currentSession = RCCallSession.fromJson(result);
      }
    } else {
      _currentSession = null;
    }
    return _currentSession;
  }

  /// 接电话
  ///
  /// 如果呼入类型为语音通话，即接受语音通话，如果呼入类型为视频通话，即接受视频通话，打开默认（前置）摄像头。观察者不开启摄像头。
  Future<int> accept() async {
    int code = await _channel.invokeMethod('accept') ?? -1;
    await getCurrentCallSession();
    return code;
  }

  /// 挂断电话
  Future<int> hangup() async {
    int code = await _channel.invokeMethod('hangup') ?? -1;
    await getCurrentCallSession();
    return code;
  }

  /// 麦克风控制
  ///
  /// [enable] true 开启麦克风，false 关闭麦克风
  Future<int> enableMicrophone(bool enabled) async {
    Map<String, dynamic> arguments = {'enabled': enabled};
    int code = await _channel.invokeMethod('enableMicrophone', arguments) ?? -1;
    await getCurrentCallSession();
    return code;
  }

  /// 获取当前麦克风状态
  ///
  /// return 当前麦克风是否开启
  Future<bool> isEnableMicrophone() async {
    bool enabled = await _channel.invokeMethod('isEnableMicrophone');
    return enabled;
  }

  /// 扬声器控制
  ///
  /// [enable] true 开启扬声器，false 关闭扬声器
  Future<int> enableSpeaker(bool enabled) async {
    Map<String, dynamic> arguments = {'enabled': enabled};
    int code = await _channel.invokeMethod('enableSpeaker', arguments) ?? -1;
    await getCurrentCallSession();
    return code;
  }

  ///  获取当前扬声器状态
  ///
  ///  return 当前扬声器是否开启
  Future<bool> isEnableSpeaker() async {
    bool enabled = await _channel.invokeMethod('isEnableSpeaker');
    return enabled;
  }

  /// 摄像头控制
  ///
  /// [enable] true 开启摄像头，false 关闭摄像头
  /// [camera] 指定摄像头
  Future<int> enableCamera(bool enabled, [RCCallCamera? camera]) async {
    Map<String, dynamic> arguments = {'enabled': enabled};
    if (camera != null) {
      arguments['camera'] = camera.index;
    }
    int code = await _channel.invokeMethod('enableCamera', arguments) ?? -1;
    await getCurrentCallSession();
    return code;
  }

  /// 获取当前摄像头状态
  ///
  /// return 当前摄像头是否开启
  Future<bool> isEnableCamera() async {
    bool enabled = await _channel.invokeMethod('isEnableCamera');
    return enabled;
  }

  /// 获取当前摄像头
  ///
  /// return 当前摄像头
  Future<RCCallCamera> currentCamera() async {
    int code = await _channel.invokeMethod('currentCamera');
    if (code < 0 || code >= RCCallCamera.values.length) return RCCallCamera.none;
    return RCCallCamera.values[code];
  }

  /// 翻转摄像头
  Future<int> switchCamera() async {
    int code = await _channel.invokeMethod('switchCamera') ?? -1;
    await getCurrentCallSession();
    return code;
  }

  /// 设置预览窗口
  ///
  /// [userId] 用户 id
  /// [view] 视频预览视图
  Future<int> setVideoView(String userId, RCCallView? view) async {
    Map<String, dynamic> arguments = {'userId': userId, 'view': view?._id ?? -1};
    int code = await _channel.invokeMethod('setVideoView', arguments) ?? -1;
    return code;
  }

  /// 修改通话媒体类型
  ///
  /// [mediaType] 通话媒体类型
  Future<int> changeMediaType(RCCallMediaType mediaType) async {
    Map<String, dynamic> arguments = {'mediaType': mediaType.index};
    int code = await _channel.invokeMethod('changeMediaType', arguments) ?? -1;
    await getCurrentCallSession();
    return code;
  }

  static RCCallEngine? _instance;

  final MethodChannel _channel;

  RCCallSession? _currentSession;
}
