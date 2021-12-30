package cn.rongcloud.call.wrapper.flutter;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

import cn.rongcloud.call.wrapper.config.RCCallIWAndroidPushConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWAudioCodecType;
import cn.rongcloud.call.wrapper.config.RCCallIWAudioConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWBeautyFilter;
import cn.rongcloud.call.wrapper.config.RCCallIWBeautyOption;
import cn.rongcloud.call.wrapper.config.RCCallIWCamera;
import cn.rongcloud.call.wrapper.config.RCCallIWCameraOrientation;
import cn.rongcloud.call.wrapper.config.RCCallIWEngineConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWEngineConfig.Builder;
import cn.rongcloud.call.wrapper.config.RCCallIWIOSPushConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWImportanceHW;
import cn.rongcloud.call.wrapper.config.RCCallIWMediaType;
import cn.rongcloud.call.wrapper.config.RCCallIWPushConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWVideoBitrateMode;
import cn.rongcloud.call.wrapper.config.RCCallIWVideoConfig;
import cn.rongcloud.call.wrapper.config.RCCallIWVideoProfile;
import cn.rongcloud.call.wrapper.model.RCCallIWCallSession;
import cn.rongcloud.call.wrapper.model.RCCallIWUserProfile;


final class ArgumentAdapter {

    public static HashMap<String, Object> fromRCCallIWUserProfile(RCCallIWUserProfile rcCallIWUserProfile) {
        HashMap<String, Object> arguments = new HashMap<>();
        if (rcCallIWUserProfile == null) {
            return arguments;
        }
        arguments.put("userType", rcCallIWUserProfile.getUserType().ordinal());
        arguments.put("userId", rcCallIWUserProfile.getUserId());
        arguments.put("mediaType", rcCallIWUserProfile.getMediaType().ordinal());
        arguments.put("mediaId", rcCallIWUserProfile.getMediaId());
        arguments.put("enableCamera", rcCallIWUserProfile.isEnableCamera());
        arguments.put("enableMicrophone", rcCallIWUserProfile.isEnableMicrophone());
        return arguments;
    }

    public static HashMap<String, Object> fromRCCallIWCallSession(RCCallIWCallSession rcCallIWCallSession) {
        if (rcCallIWCallSession == null)
            return null;
        HashMap<String, Object> arguments = new HashMap<>();
        arguments.put("callType", rcCallIWCallSession.getCallType().ordinal());
        arguments.put("mediaType", rcCallIWCallSession.getMediaType().ordinal());
        arguments.put("callId", rcCallIWCallSession.getCallId());
        arguments.put("targetId", rcCallIWCallSession.getTargetId());
        arguments.put("sessionId", rcCallIWCallSession.getSessionId());
        arguments.put("extra", rcCallIWCallSession.getExtra());
        arguments.put("startTime", rcCallIWCallSession.getStartTime());
        arguments.put("connectedTime", rcCallIWCallSession.getConnectedTime());
        arguments.put("endTime", rcCallIWCallSession.getEndTime());
        arguments.put("caller", fromRCCallIWUserProfile(rcCallIWCallSession.getCaller()));
        arguments.put("inviter", fromRCCallIWUserProfile(rcCallIWCallSession.getInviter()));
        arguments.put("mine", fromRCCallIWUserProfile(rcCallIWCallSession.getMine()));
        arguments.put("users", fromUserProfileList(rcCallIWCallSession.getUsers()));
        return arguments;
    }

    private static List<HashMap<String, Object>> fromUserProfileList(List<RCCallIWUserProfile> users) {
        List<HashMap<String, Object>> res = new ArrayList<>(users.size());
        if (users.isEmpty())
            return res;
        for (RCCallIWUserProfile user : users) {
            res.add(fromRCCallIWUserProfile(user));
        }
        return res;
    }

    public static HashMap<String, Object> fromRCCallIWBeautyOption(RCCallIWBeautyOption option) {
        HashMap<String, Object> arguments = new HashMap<>();
        if (option == null) {
            return arguments;
        }
        arguments.put("whitenessLevel", option.getWhitenessLevel());
        arguments.put("smoothLevel", option.getSmoothLevel());
        arguments.put("ruddyLevel", option.getRuddyLevel());
        arguments.put("brightLevel", option.getBrightLevel());
        return arguments;
    }

    public static RCCallIWEngineConfig toRCCallIWEngineConfig(HashMap<String, Object> config) {
        if (config == null)
            return null;
        Builder builder = Builder.create();
        Object enableAutoReconnect = config.get("enableAutoReconnect");
        if (enableAutoReconnect != null) {
            builder.withEnableAutoReconnect((Boolean) enableAutoReconnect);
        }
        Object statusReportInterval = config.get("statusReportInterval");
        if (statusReportInterval != null) {
            builder.withStatusReportInterval((Integer) statusReportInterval);
        }
        return builder.build();
    }

    public static RCCallIWIOSPushConfig toRCCallIWIOSPushConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }

        RCCallIWIOSPushConfig.Builder builder = RCCallIWIOSPushConfig.Builder.create();
        if (map.containsKey("threadId")) {
            builder.withThreadId((String) map.get("threadId"));
        }
        if (map.containsKey("apnsCollapseId")) {
            builder.withApnsCollapseId((String) map.get("apnsCollapseId"));
        }
        if (map.containsKey("category")) {
            builder.withCategory((String) map.get("category"));
        }
        if (map.containsKey("richMediaUri")) {
            builder.withRichMediaUri((String) map.get("richMediaUri"));
        }
        return builder.build();
    }

    public static RCCallIWAndroidPushConfig toRCCallIWAndroidPushConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }

        RCCallIWAndroidPushConfig.Builder builder = RCCallIWAndroidPushConfig.Builder.create();
        Object notificationId = map.get("notificationId");
        if (notificationId != null) {
            builder.withNotificationId((String) notificationId);
        }
        Object channelIdMi = map.get("channelIdMi");
        if (channelIdMi != null) {
            builder.withChannelIdMi((String) channelIdMi);
        }
        Object channelIdHW = map.get("channelIdHW");
        if (channelIdHW != null) {
            builder.withChannelIdHW((String) channelIdHW);
        }
        Object channelIdOPPO = map.get("channelIdOPPO");
        if (channelIdOPPO != null) {
            builder.withChannelIdOPPO((String) channelIdOPPO);
        }
        Object typeVivo = map.get("typeVivo");
        if (typeVivo != null) {
            builder.withTypeVivo("" + typeVivo);
        }
        Object collapseKeyFCM = map.get("collapseKeyFCM");
        if (collapseKeyFCM != null) {
            builder.withCollapseKeyFCM((String) collapseKeyFCM);
        }
        Object imageUrlFCM = map.get("imageUrlFCM");
        if (imageUrlFCM != null) {
            builder.withImageUrlFCM((String) imageUrlFCM);
        }
        Object importanceHW = map.get("importanceHW");
        if (importanceHW != null) {
            builder.withImportanceHW(toRCCallIWImportanceHW((Integer) importanceHW));
        }
        return builder.build();
    }

    public static RCCallIWImportanceHW toRCCallIWImportanceHW(int index) {
        return RCCallIWImportanceHW.values()[index];
    }

    @SuppressWarnings("unchecked")
    public static RCCallIWPushConfig toRCCallIWPushConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }

        RCCallIWPushConfig.Builder builder = RCCallIWPushConfig.Builder.create();

        Object templateId = map.get("templateId");
        if (templateId != null) {
            builder.withTemplateId((String) templateId);
        }
        Object title = map.get("title");
        if (title != null) {
            builder.withTitle((String) title);
        }
        Object content = map.get("content");
        if (content != null) {
            builder.withContent((String) content);
        }
        Object data = map.get("data");
        if (data != null) {
            builder.withData((String) data);
        }
        Object disableTitle = map.get("disableTitle");
        if (disableTitle != null) {
            builder.withDisableTitle((Boolean) disableTitle);
        }
        Object forceShowDetailContent = map.get("forceShowDetailContent");
        if (forceShowDetailContent != null) {
            builder.withForceShowDetailContent((Boolean) forceShowDetailContent);
        }
        Object iOSConfig = map.get("iOSConfig");
        if (iOSConfig != null) {
            builder.withIOSConfig(toRCCallIWIOSPushConfig((HashMap<String, Object>) iOSConfig));
        }
        Object androidConfig = map.get("androidConfig");
        if (androidConfig != null) {
            builder.withAndroidConfig(toRCCallIWAndroidPushConfig((HashMap<String, Object>) androidConfig));
        }
        return builder.build();
    }

    public static RCCallIWAudioConfig toRCCallIWAudioConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }

        RCCallIWAudioConfig.Builder builder = RCCallIWAudioConfig.Builder.create();
        Object enableMicrophone = map.get("enableMicrophone");
        if (enableMicrophone != null) {
            builder.withEnableMicrophone((Boolean) enableMicrophone);
        }
        Object enableStereo = map.get("enableStereo");
        if (enableStereo != null) {
            builder.withEnableStereo((Boolean) enableStereo);
        }
        Object audioSource = map.get("audioSource");
        if (audioSource != null) {
            builder.withAudioSource((Integer) audioSource);
        }
        Object audioBitrate = map.get("audioBitrate");
        if (audioBitrate != null) {
            builder.withAudioBitrate((Integer) audioBitrate);
        }
        Object audioSampleRate = map.get("audioSampleRate");
        if (audioSampleRate != null) {
            builder.withAudioSampleRate((Integer) audioSampleRate);
        }
        Object type = map.get("type");
        if (type != null) {
            builder.withType(toRCCallIWAudioCodecType((Integer) type));
        }
        return builder.build();

    }

    public static RCCallIWAudioCodecType toRCCallIWAudioCodecType(int index) {
        return RCCallIWAudioCodecType.values()[index];
    }

    public static RCCallIWVideoConfig toRCCallIWVideoConfig(HashMap<String, Object> map) {
        if (map == null) {
            return null;
        }

        RCCallIWVideoConfig.Builder builder = RCCallIWVideoConfig.Builder.create();
        Object enableHardwareDecoder = map.get("enableHardwareDecoder");
        if (enableHardwareDecoder != null) {
            builder.withEnableHardwareDecoder((Boolean) enableHardwareDecoder);
        }
        Object hardwareDecoderColor = map.get("hardwareDecoderColor");
        if (hardwareDecoderColor != null) {
            builder.withHardwareDecoderColor((Integer) hardwareDecoderColor);
        }
        Object enableHardwareEncoder = map.get("enableHardwareEncoder");
        if (enableHardwareEncoder != null) {
            builder.withEnableHardwareEncoder((Boolean) enableHardwareEncoder);
        }
        Object enableHardwareEncoderHighProfile = map.get("enableHardwareEncoderHighProfile");
        if (enableHardwareEncoderHighProfile != null) {
            builder.withEnableHardwareEncoderHighProfile((Boolean) enableHardwareEncoderHighProfile);
        }
        Object enableEncoderTexture = map.get("enableEncoderTexture");
        if (enableEncoderTexture != null) {
            builder.withEnableEncoderTexture((Boolean) enableEncoderTexture);
        }
        Object hardWareEncoderColor = map.get("hardWareEncoderColor");
        if (hardWareEncoderColor != null) {
            builder.withHardWareEncoderColor((Integer) hardWareEncoderColor);
        }
        Object hardWareEncoderFrameRate = map.get("hardWareEncoderFrameRate");
        if (hardWareEncoderFrameRate != null) {
            builder.withHardWareEncoderFrameRate((Integer) hardWareEncoderFrameRate);
        }
        Object hardwareEncoderBitrateMode = map.get("hardwareEncoderBitrateMode");
        if (hardwareEncoderBitrateMode != null) {
            builder.withHardwareEncoderBitrateMode(toRCCallIWVideoBitrateMode((Integer) hardwareEncoderBitrateMode));
        }
        Object profile = map.get("profile");
        if (profile != null) {
            builder.withProfile(toRCCallIWVideoProfile((Integer) profile));
        }
        Object defaultCamera = map.get("defaultCamera");
        if (defaultCamera != null) {
            builder.withDefaultCamera(toRCCallIWCamera((Integer) defaultCamera));
        }
        Object cameraOrientation = map.get("cameraOrientation");
        if (cameraOrientation != null) {
            builder.withCameraOrientation(toRCCallIWCameraOrientation((Integer) cameraOrientation));
        }
        builder.withPreviewMirror(false);
        return builder.build();
    }

    public static RCCallIWCameraOrientation toRCCallIWCameraOrientation(int index) {
        return RCCallIWCameraOrientation.values()[index];
    }

    public static RCCallIWCamera toRCCallIWCamera(int index) {
        return RCCallIWCamera.values()[index];
    }

    public static RCCallIWVideoProfile toRCCallIWVideoProfile(int index) {
        return RCCallIWVideoProfile.values()[index];
    }

    public static RCCallIWVideoBitrateMode toRCCallIWVideoBitrateMode(int index) {
        return RCCallIWVideoBitrateMode.values()[index];
    }

    public static RCCallIWMediaType toRCCallIWMediaType(int index) {
        return RCCallIWMediaType.values()[index];
    }

    public static RCCallIWBeautyOption toRCCallIWBeautyOption(HashMap<String, Object> option) {
        if (option == null) {
            return null;
        }
        RCCallIWBeautyOption beautyOption = new RCCallIWBeautyOption();
        Object whitenessLevel = option.get("whitenessLevel");
        if (whitenessLevel != null) {
            beautyOption.setWhitenessLevel((Integer) whitenessLevel);
        }
        Object smoothLevel = option.get("smoothLevel");
        if (smoothLevel != null) {
            beautyOption.setSmoothLevel((Integer) smoothLevel);
        }
        Object ruddyLevel = option.get("ruddyLevel");
        if (ruddyLevel != null) {
            beautyOption.setRuddyLevel((Integer) ruddyLevel);
        }
        Object brightLevel = option.get("brightLevel");
        if (brightLevel != null) {
            beautyOption.setBrightLevel((Integer) brightLevel);
        }
        return beautyOption;
    }

    public static RCCallIWBeautyFilter toRCCallIWBeautyFilter(int filter) {
        return RCCallIWBeautyFilter.values()[filter];
    }
}
