import 'dart:async';

import 'package:flutter_call_plugin_example/data/constants.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
import 'package:rongcloud_im_wrapper_plugin/rongcloud_im_wrapper_plugin.dart';
// import 'package:rongcloud_rtc_wrapper_plugin/rongcloud_rtc_wrapper_plugin.dart';

enum CallEvent {
  hangup,
  accept,
  connect,
  disconnect,
  remote_leave,
  remote_join,
  receive_call,
}

class Utils {

  static set callEngine(RCCallEngine? engine) {
    _callEngine = engine;
    _onSetEngine();
  }

  static void _onSetEngine() {
    if (_callEngine != null) {
      _callEngine?.onReceiveCall = (RCCallSession session) {
        _onState(CallEvent.receive_call);
        onReceiveCall?.call(session);
      };
      _callEngine?.onConnect = () {
        _onState(CallEvent.connect);
        onConnect?.call();
      };
      _callEngine?.onDisconnect = (RCCallDisconnectReason reason) {
        _onState(CallEvent.disconnect);
        onDisconnect?.call(reason);
      };
      _callEngine?.onEnableCamera = (RCCallCamera camera, bool enable) {
        onEnableCamera?.call(camera, enable);
      };
      _callEngine?.onSwitchCamera = (RCCallCamera camera) {
        onSwitchCamera?.call(camera);
      };
      _callEngine?.onCallError = (int errorCode) {
        onCallError?.call(errorCode);
      };
      _callEngine?.onCallDidMake = () {
        // todo: event
        print('onCallDidMake called.');
      };
      _callEngine?.onRemoteUserDidRing = (String userId) {
        // todo: event
        print('onRemoteUserDidRing called.');
      };
      _callEngine?.onRemoteUserDidChangeMediaType = (RCCallUserProfile user, RCCallMediaType mediaType) {
        onRemoteUserDidChangeMediaType?.call(user, mediaType);
      };
      _callEngine?.onRemoteUserDidChangeMicrophoneState = (RCCallUserProfile user, bool enable) {
        // todo: event
        print('onRemoteUserDidChangeMicrophoneState called.');
      };
      _callEngine?.onRemoteUserDidChangeCameraState = (RCCallUserProfile user, bool enable) {
        onRemoteUserDidChangeCameraState?.call(user, enable);
      };
      // _engine?.onRemoteUserJoin = (RCCallUserProfile userProfile) {
      //   // todo: event
      //   print('onRemoteUserJoin called.');
      // };
      // _engine?.onRemoteUserLeave = (String userId, int reason) {
      //   print('onRemoteUserLeave called.');
      //   _onState(CallEvent.remote_leave);
      //   onRemoteUserLeave?.call(userId, reason);
      // };
      // _engine?.onRemoteUserDidInvite = (String userId, RCCallMediaType mediaType) {
      //   // todo: event
      //   print('onRemoteUserDidInvite called.');
      // };
      _callEngine?.onNetworkQuality = (RCCallUserProfile user, RCCallNetworkQuality quality) {
        onNetworkQuality?.call(user, quality);
      };
      _callEngine?.onAudioVolume = (RCCallUserProfile user, int volume) {
        onAudioVolume?.call(user, volume);
      };
    } else {
      onReceiveCall = null;
      onEnableCamera = null;
      onConnect = null;
      onDisconnect = null;
      onRemoteUserLeave = null;
      onRemoteUserDidChangeCameraState = null;
      onCallError = null;
      onRemoteUserDidChangeMediaType = null;
      onNetworkQuality = null;
      onAudioVolume = null;
      onSwitchCamera = null;
      _callEngine?.onReceiveCall = null;
      _callEngine?.onConnect = null;
      _callEngine?.onDisconnect = null;
      _callEngine?.onEnableCamera = null;
      _callEngine?.onSwitchCamera = null;
      _callEngine?.onCallError = null;
      _callEngine?.onCallDidMake = null;
      _callEngine?.onRemoteUserDidRing = null;
      _callEngine?.onRemoteUserDidChangeMediaType = null;
      _callEngine?.onRemoteUserDidChangeMicrophoneState = null;
      _callEngine?.onRemoteUserDidChangeCameraState = null;
      // _engine?.onRemoteUserJoin = null;
      // _engine?.onRemoteUserLeave = null;
      // _engine?.onRemoteUserDidInvite = null;
      _callEngine?.onNetworkQuality = null;
      _callEngine?.onAudioVolume = null;
    }
  }

  static Future<int> hangup() async {
    Completer<int> completer = Completer();
    if (_callEngine != null) {
      int ret = await _callEngine!.hangup();
      if (ret == 0) {
        _onState(CallEvent.hangup);
      }
      completer.complete(ret);
    } else {
      return Future.value(0);
    }

    return completer.future;
  }

  static void _onState(CallEvent event) {
    if (event == CallEvent.disconnect) {
      if (_state != AppState.disconnected) {
        _state = AppState.connected;
      }

      return;
    }

    var state = _state;
    switch (state) {
      case AppState.connected:
        if (event == CallEvent.receive_call) {
          _state = AppState.ringing;
        }
        break;
      case AppState.disconnected:
        if (event == CallEvent.receive_call) {
          _state = AppState.ringing;
        }
        break;
      case AppState.ringing:
        if (event == CallEvent.remote_leave) {
          _state = AppState.connected;
        } else if (event == CallEvent.connect) {
          _state = AppState.chatting;
        } else if (event == CallEvent.hangup) {
          _state = AppState.connected;
        }
        break;
      case AppState.calling:
        if (event == CallEvent.connect) {
          _state = AppState.chatting;
        } else if (event == CallEvent.hangup) {
          _state = AppState.connected;
        }
        break;
      case AppState.chatting:
        if (event == CallEvent.remote_leave) {
          _state = AppState.connected;
        }
        break;
    }
  }

  static Future<RCCallSession?> startCall(String targetId, RCCallMediaType mediaType, [String? extra]) async {
    _state = AppState.calling;
    var status = await Permission.camera.status;
    if (status.isDenied) {
      if (!await Permission.camera.request().isGranted) {
        return null;
      }
    }
    return await Utils.callEngine?.startCall(targetId, mediaType, extra);
  }

  static String stateText(AppState state) {
    if (state == AppState.calling) {
      return '正在拨打...';
    } else if (state == AppState.ringing) {
      return '正在振铃...';
    } else if (state == AppState.chatting) {
      return '正在通话...';
    } else if (state == AppState.connected) {
      return '已登录';
    } else if (state == AppState.disconnected) {
      return '已挂断';
    }
    return '未知状态';
  }

  static String networkQualityText(RCCallNetworkQuality quality) {
    switch (quality) {
      case RCCallNetworkQuality.unknown:
        return '未知';
      case RCCallNetworkQuality.excellent:
        return '极好';
      case RCCallNetworkQuality.good:
        return '好';
      case RCCallNetworkQuality.poor:
        return '一般';
      case RCCallNetworkQuality.bad:
        return '差';
      case RCCallNetworkQuality.terrible:
        return '极差';
    }
  }

  static RCCallEngine? get callEngine {
    return _callEngine;
  }

  static RCCallSession? get session {
    return _session;
  }

  static AppState get state {
    return _state;
  }

  static void resetState() {
    if (_callEngine != null) {
      _state = AppState.connected;
    } else {
      _state = AppState.disconnected;
    }
  }

  static RCIMIWEngine? imEngine;
  static RCCallEngine? _callEngine;
  static RCCallSession? _session;
  static String? currentUserId;
  // static RCRTCEngine? rtcEngine;

  static AppState _state = AppState.disconnected;

  static Function(RCCallSession session)? onReceiveCall;

  static Function(RCCallCamera camera, bool enable)? onEnableCamera;

  static Function()? onConnect;

  static Function(RCCallDisconnectReason reason)? onDisconnect;

  static Function(int errorCode)? onCallError;

  static Function(String userId, int reason)? onRemoteUserLeave;

  static Function(RCCallUserProfile user, bool enable)? onRemoteUserDidChangeCameraState;

  static Function(RCCallUserProfile user, RCCallMediaType mediaType)? onRemoteUserDidChangeMediaType;

  static Function(RCCallUserProfile user, RCCallNetworkQuality quality)? onNetworkQuality;

  static Function(RCCallUserProfile user, int volume)? onAudioVolume;

  static Function(RCCallCamera camera)? onSwitchCamera;
}
