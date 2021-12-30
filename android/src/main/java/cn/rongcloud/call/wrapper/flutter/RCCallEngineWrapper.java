package cn.rongcloud.call.wrapper.flutter;

import android.annotation.SuppressLint;

import androidx.annotation.NonNull;

import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.util.HashMap;

import cn.rongcloud.call.wrapper.RCCallIWEngine;
import cn.rongcloud.call.wrapper.config.RCCallIWAudioConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWBeautyFilter;
import cn.rongcloud.call.wrapper.config.RCCallIWBeautyOption;
import cn.rongcloud.call.wrapper.config.RCCallIWCallDisconnectedReason;
import cn.rongcloud.call.wrapper.config.RCCallIWCamera;
import cn.rongcloud.call.wrapper.config.RCCallIWEngineConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWMediaType;
import cn.rongcloud.call.wrapper.config.RCCallIWNetworkQuality;
import cn.rongcloud.call.wrapper.config.RCCallIWPushConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWVideoConfig;
import cn.rongcloud.call.wrapper.listener.RCCallIWEngineListener;
import cn.rongcloud.call.wrapper.listener.RCCallIWOnWritableVideoFrameListener;
import cn.rongcloud.call.wrapper.model.RCCallIWCallSession;
import cn.rongcloud.call.wrapper.model.RCCallIWUserProfile;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.Result;


public final class RCCallEngineWrapper implements MethodChannel.MethodCallHandler {

    public static RCCallEngineWrapper getInstance() {
        return SingletonHolder.instance;
    }

    private RCCallEngineWrapper() {
    }

    void init(BinaryMessenger messenger) {
        channel = new MethodChannel(messenger, "cn.rongcloud.call.flutter/engine");
        channel.setMethodCallHandler(this);
    }

    void unInit() {
        channel.setMethodCallHandler(null);
    }

    public int setLocalVideoProcessedListener(RCCallIWOnWritableVideoFrameListener listener) {
        int code = -1;
        if (engine != null) {
            engine.setLocalVideoProcessedListener(listener);
            code = 0;
        }
        return code;
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        String method = call.method;
        switch (method) {
            case "create":
                create(result);
                break;
            case RCCall_SetEngineConfig:
                setEngineConfig(call, result);
                break;
            case RCCall_SetPushConfig:
                setPushConfig(call, result);
                break;
            case RCCall_StartCall:
                startCall(call, result);
                break;
            case RCCall_SetAudioConfig:
                setAudioConfig(call, result);
                break;
            case RCCall_SetVideoConfig:
                setVideoConfig(call, result);
                break;
            case RCCall_SetBeautyOption:
                setBeautyOption(call, result);
                break;
            case RCCall_GetBeautyOption:
                getBeautyOption(result);
                break;
            case RCCall_SetBeautyFilter:
                setBeautyFilter(call, result);
                break;
            case RCCall_GetBeautyFilter:
                getBeautyFilter(result);
                break;
            case RCCall_ResetBeauty:
                resetBeauty(result);
                break;
            case RCCall_GetCurrentCallSession:
                getCurrentCallSession(result);
                break;
            case RCCall_Accept:
                accept(result);
                break;
            case RCCall_Hangup:
                hangup(result);
                break;
            case RCCall_EnableMicrophone:
                enableMicrophone(call, result);
                break;
            case RCCall_IsEnableMicrophone:
                isEnableMicrophone(result);
                break;
            case RCCall_EnableSpeaker:
                enableSpeaker(call, result);
                break;
            case RCCall_IsEnableSpeaker:
                isEnableSpeaker(result);
                break;
            case RCCall_EnableCamera:
                enableCamera(call, result);
                break;
            case RCCall_IsEnableCamera:
                isEnableCamera(result);
                break;
            case RCCall_CurrentCamera:
                currentCamera(result);
                break;
            case RCCall_SwitchCamera:
                switchCamera(result);
                break;
            case RCCall_SetVideoView:
                setVideoView(call, result);
                break;
            case RCCall_ChangeMediaType:
                changeMediaType(call, result);
                break;
            default:
                result.notImplemented();
                break;
        }
    }

    private void create(@NonNull Result result) {
        if (engine == null) {
            engine = RCCallIWEngine.getInstance();
            engine.setEngineListener(new ListenerImpl());
        }
        MainThreadPoster.success(result);
    }

    private void setEngineConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            HashMap<String, Object> arguments = call.arguments();
            RCCallIWEngineConfig config = ArgumentAdapter.toRCCallIWEngineConfig(arguments);
            engine.setEngineConfig(config);
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void setPushConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            RCCallIWPushConfig push = ArgumentAdapter.toRCCallIWPushConfig(call.argument("push"));
            RCCallIWPushConfig hangupPush = ArgumentAdapter.toRCCallIWPushConfig(call.argument("hangupPush"));
            engine.setPushConfig(push, hangupPush);
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void startCall(@NonNull MethodCall call, @NonNull Result result) {
        if (engine != null) {
            String targetId = call.argument("targetId");
            Object typeIndex = call.argument("mediaType");
            Object extra = call.argument("extra");
            RCCallIWMediaType mediaType = ArgumentAdapter.toRCCallIWMediaType((Integer) typeIndex);
            RCCallIWCallSession session = null;
            if (extra != null) {
                session = engine.startCall(targetId, mediaType, (String) extra);
            } else {
                session = engine.startCall(targetId, mediaType);
            }
            HashMap<String, Object> obj = ArgumentAdapter.fromRCCallIWCallSession(session);
            MainThreadPoster.success(result, obj);
            return;
        }
        MainThreadPoster.success(result);
    }

    private void setAudioConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            HashMap<String, Object> arguments = call.arguments();
            RCCallIWAudioConfig config = ArgumentAdapter.toRCCallIWAudioConfig(arguments);
            engine.setAudioConfig(config);
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void setVideoConfig(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            HashMap<String, Object> arguments = call.arguments();
            RCCallIWVideoConfig config = ArgumentAdapter.toRCCallIWVideoConfig(arguments);
            engine.setVideoConfig(config);
        }
        MainThreadPoster.success(result, code);
    }

    private void setBeautyOption(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("enabled");
            if (arg != null) {
                boolean enabled = (boolean) arg;
                RCCallIWBeautyOption option = ArgumentAdapter.toRCCallIWBeautyOption(call.argument("option"));
                engine.setBeautyOption(enabled, option);
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void getBeautyOption(@NonNull Result result) {
        if (engine != null) {
            RCCallIWBeautyOption option = engine.getCurrentBeautyOption();
            HashMap<String, Object> arg = ArgumentAdapter.fromRCCallIWBeautyOption(option);
            MainThreadPoster.success(result, arg);
            return;
        }
        MainThreadPoster.success(result);
    }

    private void setBeautyFilter(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("filter");
            if (arg != null) {
                RCCallIWBeautyFilter filter = ArgumentAdapter.toRCCallIWBeautyFilter((int) arg);
                engine.setBeautyFilter(filter);
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void getBeautyFilter(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            RCCallIWBeautyFilter filter = engine.getCurrentBeautyFilter();
            code = filter.ordinal();
        }
        MainThreadPoster.success(result, code);
    }

    private void resetBeauty(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            engine.resetBeauty();
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void getCurrentCallSession(@NonNull Result result) {
        if (engine != null) {
            RCCallIWCallSession session = engine.getCurrentCallSession();
            HashMap<String, Object> arguments = ArgumentAdapter.fromRCCallIWCallSession(session);
            MainThreadPoster.success(result, arguments);
            return;
        }
        MainThreadPoster.success(result);
    }

    private void accept(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            engine.accept();
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void hangup(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            engine.hangup();
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void enableMicrophone(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("enabled");
            if (arg != null) {
                boolean enabled = (boolean) arg;
                engine.enableMicrophone(enabled);
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void isEnableMicrophone(@NonNull Result result) {
        if (engine != null) {
            boolean isEnabled = engine.isEnableMicrophone();
            MainThreadPoster.success(result, isEnabled);
            return;
        }
        MainThreadPoster.success(result, false);
    }

    private void enableSpeaker(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("enabled");
            if (arg != null) {
                boolean enabled = (boolean) arg;
                engine.enableSpeaker(enabled);
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void isEnableSpeaker(@NonNull Result result) {
        if (engine != null) {
            boolean isEnabled = engine.isEnableSpeaker();
            MainThreadPoster.success(result, isEnabled);
            return;
        }
        MainThreadPoster.success(result, false);
    }

    private void enableCamera(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("enabled");
            if (arg != null) {
                boolean enabled = (boolean) arg;
                Object arg2 = call.argument("camera");
                if (arg2 != null) {
                    RCCallIWCamera camera = ArgumentAdapter.toRCCallIWCamera((int) arg2);
                    engine.enableCamera(enabled, camera);
                } else {
                    engine.enableCamera(enabled);
                }
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private void isEnableCamera(@NonNull Result result) {
        if (engine != null) {
            boolean isEnabled = engine.isEnableCamera();
            MainThreadPoster.success(result, isEnabled);
            return;
        }
        MainThreadPoster.success(result, false);
    }

    private void currentCamera(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            RCCallIWCamera camera = engine.currentCamera();
            code = camera.ordinal();
        }
        MainThreadPoster.success(result, code);
    }

    private void switchCamera(@NonNull Result result) {
        int code = -1;
        if (engine != null) {
            engine.switchCamera();
            code = 0;
        }
        MainThreadPoster.success(result, code);
    }

    private void setVideoView(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            String userId = call.argument("userId");
            Object arg = call.argument("view");
            if (arg != null) {
                Integer view = (Integer) arg;
                RCCallViewWrapper.RCCallView origin = RCCallViewWrapper.getInstance().getView(view);
                try {
                    if (origin != null) {
                        SET_VIDEO_VIEW_METHOD.invoke(engine, userId, origin.view);
                    } else {
                        SET_VIDEO_VIEW_METHOD.invoke(engine, userId, null);
                    }
                    code = 0;
                } catch (IllegalAccessException | InvocationTargetException e) {
                    e.printStackTrace();
                }
            }
        }

        MainThreadPoster.success(result, code);
    }

    private void changeMediaType(@NonNull MethodCall call, @NonNull Result result) {
        int code = -1;
        if (engine != null) {
            Object arg = call.argument("mediaType");
            if (arg != null) {
                RCCallIWMediaType type = ArgumentAdapter.toRCCallIWMediaType((int) arg);
                engine.changeMediaType(type);
                code = 0;
            }
        }
        MainThreadPoster.success(result, code);
    }

    private static class SingletonHolder {
        @SuppressLint("StaticFieldLeak")
        private static final RCCallEngineWrapper instance = new RCCallEngineWrapper();
    }

    private class ListenerImpl extends RCCallIWEngineListener {

        @Override
        public void onCallReceived(RCCallIWCallSession rcCallIWCallSession) {
            final HashMap<String, Object> arguments = ArgumentAdapter.fromRCCallIWCallSession(rcCallIWCallSession);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:didReceiveCall", arguments));
        }

        @Override
        public void onCallConnected() {
            MainThreadPoster.post(() -> channel.invokeMethod("engine:callDidConnect", null));
        }

        @Override
        public void onCallDisconnected(RCCallIWCallDisconnectedReason rcCallIWCallDisconnectedReason) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("reason", rcCallIWCallDisconnectedReason.getValue() - 1);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:callDidDisconnect", arguments));
        }

        @Override
        public void onRemoteUserJoined(RCCallIWUserProfile rcCallIWUserProfile) {
            final HashMap<String, Object> arguments = ArgumentAdapter.fromRCCallIWUserProfile(rcCallIWUserProfile);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidJoin", arguments));
        }

        @Override
        public void onRemoteUserLeft(String userId, RCCallIWCallDisconnectedReason reason) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("id", userId);
            arguments.put("reason", reason.ordinal());
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidLeave", arguments));
        }

        @Override
        public void onCallMissed(RCCallIWCallSession session) {
            // 空，不处理
        }

        @Override
        public void onEnableCamera(RCCallIWCamera camera, boolean enable) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("camera", camera.ordinal());
            arguments.put("enabled", enable);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:didEnableCamera", arguments));
        }

        @Override
        public void onSwitchCamera(RCCallIWCamera camera) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("camera", camera.ordinal());
            MainThreadPoster.post(() -> channel.invokeMethod("engine:didSwitchCamera", arguments));
        }

        @Override
        public void onError(int code) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("errorCode", code);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:callDidError", arguments));
        }

        @Override
        public void onCallOutgoing() {
            MainThreadPoster.post(() -> channel.invokeMethod("engine:callDidMake", null));
        }

        @Override
        public void onRemoteUserRinging(String userId) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("userId", userId);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidRing", arguments));
        }

        @Override
        public void onRemoteUserInvited(String userId, RCCallIWMediaType mediaType) {
            final HashMap<String, Object> arguments = new HashMap<>();
            arguments.put("userId", userId);
            arguments.put("mediaType", mediaType.ordinal());
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidInvite", arguments));
        }

        @Override
        public void onRemoteUserMediaTypeChanged(RCCallIWUserProfile user, RCCallIWMediaType mediaType) {
            final HashMap<String, Object> arguments = new HashMap<>();
            HashMap<String, Object> userProfile = ArgumentAdapter.fromRCCallIWUserProfile(user);
            arguments.put("user", userProfile);
            arguments.put("mediaType", mediaType.ordinal());
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidChangeMediaType", arguments));
        }

        @Override
        public void onRemoteUserMicrophoneStateChanged(RCCallIWUserProfile user, boolean enable) {
            final HashMap<String, Object> arguments = new HashMap<>();
            HashMap<String, Object> userProfile = ArgumentAdapter.fromRCCallIWUserProfile(user);
            arguments.put("user", userProfile);
            arguments.put("enabled", enable);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidChangeMicrophoneState", arguments));
        }

        @Override
        public void onRemoteUserCameraStateChanged(RCCallIWUserProfile user, boolean enable) {
            final HashMap<String, Object> arguments = new HashMap<>();
            HashMap<String, Object> userProfile = ArgumentAdapter.fromRCCallIWUserProfile(user);
            arguments.put("user", userProfile);
            arguments.put("enabled", enable);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:remoteUserDidChangeCameraState", arguments));
        }

        @Override
        public void onNetworkQuality(RCCallIWUserProfile user, RCCallIWNetworkQuality quality) {
            final HashMap<String, Object> arguments = new HashMap<>();
            HashMap<String, Object> userProfile = ArgumentAdapter.fromRCCallIWUserProfile(user);
            arguments.put("user", userProfile);
            arguments.put("quality", quality.ordinal());
            MainThreadPoster.post(() -> channel.invokeMethod("engine:networkQuality", arguments));
        }

        @Override
        public void onAudioVolume(RCCallIWUserProfile user, int volume) {
            final HashMap<String, Object> arguments = new HashMap<>();
            HashMap<String, Object> userProfile = ArgumentAdapter.fromRCCallIWUserProfile(user);
            arguments.put("user", userProfile);
            arguments.put("volume", volume);
            MainThreadPoster.post(() -> channel.invokeMethod("engine:audioVolume", arguments));
        }
    }

    private MethodChannel channel;
    private RCCallIWEngine engine = null;

    private static Method SET_VIDEO_VIEW_METHOD;

    static {
        try {
            Class<?> clazz = Class.forName("cn.rongcloud.call.wrapper.RCCallIWEngine");
            Field enableMultiPlatform = clazz.getDeclaredField("enableMultiPlatform");
            enableMultiPlatform.setAccessible(true);
            enableMultiPlatform.setBoolean(null, true);
            enableMultiPlatform.setAccessible(false);

            Class<?> viewClazz = Class.forName("cn.rongcloud.call.wrapper.platform.flutter.RCCallIWFlutterView");
            SET_VIDEO_VIEW_METHOD = clazz.getDeclaredMethod("setVideoView", String.class, viewClazz);
            SET_VIDEO_VIEW_METHOD.setAccessible(true);
        } catch (ClassNotFoundException | NoSuchMethodException | NoSuchFieldException | IllegalAccessException e) {
            e.printStackTrace();
        }
    }

    static final String RCCall_SetEngineConfig = "setEngineConfig";
    static final String RCCall_SetPushConfig = "setPushConfig";
    static final String RCCall_SetAudioConfig = "setAudioConfig";
    static final String RCCall_SetVideoConfig = "setVideoConfig";
    static final String RCCall_SetBeautyOption = "setBeautyOption";
    static final String RCCall_GetBeautyOption = "getBeautyOption";
    static final String RCCall_SetBeautyFilter = "setBeautyFilter";
    static final String RCCall_GetBeautyFilter = "getBeautyFilter";
    static final String RCCall_ResetBeauty = "resetBeauty";
    static final String RCCall_StartCall = "startCall";
    static final String RCCall_GetCurrentCallSession = "getCurrentCallSession";
    static final String RCCall_Accept = "accept";
    static final String RCCall_Hangup = "hangup";
    static final String RCCall_EnableMicrophone = "enableMicrophone";
    static final String RCCall_IsEnableMicrophone = "isEnableMicrophone";
    static final String RCCall_EnableSpeaker = "enableSpeaker";
    static final String RCCall_IsEnableSpeaker = "isEnableSpeaker";
    static final String RCCall_EnableCamera = "enableCamera";
    static final String RCCall_IsEnableCamera = "isEnableCamera";
    static final String RCCall_CurrentCamera = "currentCamera";
    static final String RCCall_SwitchCamera = "switchCamera";
    static final String RCCall_SetVideoView = "setVideoView";
    static final String RCCall_ChangeMediaType = "changeMediaType";

}
