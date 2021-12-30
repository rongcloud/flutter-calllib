import 'rongcloud_call_constants.dart';
import 'rongcloud_call_engine.dart';
import 'rongcloud_call_module.dart';

typedef OnReceiveCall = Function(RCCallSession session);
typedef OnConnect = Function();
typedef OnDisconnect = Function(RCCallDisconnectReason reason);

typedef OnEnableCamera = Function(RCCallCamera camera, bool enable);
typedef OnSwitchCamera = Function(RCCallCamera camera);
typedef OnCallError = Function(int errorCode);
typedef OnCallDidMake = Function();
typedef OnRemoteUserDidRing = Function(String userId);
typedef OnRemoteUserDidChangeMediaType = Function(RCCallUserProfile user, RCCallMediaType mediaType);
typedef OnRemoteUserDidChangeMicrophoneState = Function(RCCallUserProfile user, bool enable);
typedef OnRemoteUserDidChangeCameraState = Function(RCCallUserProfile user, bool enable);
// typedef OnRemoteUserJoin = Function(RCCallUserProfile userProfile);
// typedef OnRemoteUserLeave = Function(String userId, int reason);
// typedef OnRemoteUserDidInvite = Function(String userId, RCCallMediaType mediaType);

typedef OnNetworkQuality = Function(RCCallUserProfile user, RCCallNetworkQuality quality);
typedef OnAudioVolume = Function(RCCallUserProfile user, int volume);

abstract class CallEngine {
  OnReceiveCall? onReceiveCall;
  OnConnect? onConnect;
  OnDisconnect? onDisconnect;

  OnEnableCamera? onEnableCamera;
  OnSwitchCamera? onSwitchCamera;
  OnCallError? onCallError;
  OnCallDidMake? onCallDidMake;

  OnRemoteUserDidRing? onRemoteUserDidRing;
  OnRemoteUserDidChangeMediaType? onRemoteUserDidChangeMediaType;
  OnRemoteUserDidChangeMicrophoneState? onRemoteUserDidChangeMicrophoneState;
  OnRemoteUserDidChangeCameraState? onRemoteUserDidChangeCameraState;

  // OnRemoteUserJoin? onRemoteUserJoin;
  // OnRemoteUserLeave? onRemoteUserLeave;
  // OnRemoteUserDidInvite? onRemoteUserDidInvite;

  OnNetworkQuality? onNetworkQuality;
  OnAudioVolume? onAudioVolume;
}
