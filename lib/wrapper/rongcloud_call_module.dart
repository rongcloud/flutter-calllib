import 'rongcloud_call_constants.dart';

class RCCallIOSPushConfig {
  RCCallIOSPushConfig.create({
    required this.threadId,
    required this.category,
    required this.apnsCollapseId,
    required this.richMediaUri,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'threadId': threadId,
      'category': category,
      'apnsCollapseId': apnsCollapseId,
      'richMediaUri': richMediaUri,
    };
    return json;
  }

  /// [ZH]
  /// ---
  /// iOS 平台通知栏分组 ID
  /// 相同的 thread-id 推送分为一组
  /// iOS10 开始支持
  /// ---
  /// [EN]
  /// ---
  /// iOS notification grouping identifier
  /// Notifications with the same thread-id are grouped
  /// Supported since iOS 10
  /// ---
  final String threadId;

  /// [ZH]
  /// ---
  /// iOS 标识推送的类型
  /// 如果不设置后台默认取消息类型字符串，如 RC:TxtMsg
  /// ---
  /// [EN]
  /// ---
  /// iOS category to identify push type
  /// Defaults to the message type string if not set (e.g., RC:TxtMsg)
  /// ---
  final String category;

  /// [ZH]
  /// ---
  /// iOS 平台通知覆盖 ID
  /// apnsCollapseId 相同时，新收到的通知会覆盖老的通知，最大 64 字节
  /// iOS10 开始支持
  /// ---
  /// [EN]
  /// ---
  /// iOS notification collapse identifier
  /// A new notification with the same apnsCollapseId overrides the old one (max 64 bytes)
  /// Supported since iOS 10
  /// ---
  final String apnsCollapseId;

  /// [ZH]
  /// ---
  /// iOS 富文本推送内容
  /// ---
  /// [EN]
  /// ---
  /// iOS rich media push content URI
  /// ---
  final String richMediaUri;
}

class RCCallAndroidPushConfig {
  RCCallAndroidPushConfig.create({
    this.notificationId,
    this.channelIdForXiaoMi,
    this.channelIdForHuaWei,
    this.importanceForHuaWei,
    this.channelIdForOppo,
    this.vivoPushType,
    this.collapseKeyForFCM,
    this.imageUrlForFCM,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'notificationId': notificationId,
      'channelIdMi': channelIdForXiaoMi,
      'channelIdHW': channelIdForHuaWei,
      'importanceHW': importanceForHuaWei?.index,
      'channelIdOPPO': channelIdForOppo,
      'typeVivo': vivoPushType?.index,
      'collapseKeyFCM': collapseKeyForFCM,
      'imageUrlFCM': imageUrlForFCM,
    };
    return json;
  }

  /// [ZH]
  /// ---
  /// Android 平台 Push 唯一标识
  /// 目前支持小米、华为推送平台，默认开发者不需要进行设置。
  /// 当消息产生推送时，消息的 messageUId 作为 notificationId 使用。
  /// ---
  /// [EN]
  /// ---
  /// Unique identifier for Android push
  /// Currently supports Xiaomi and Huawei push; usually no need to set
  /// When a push is generated, messageUId is used as notificationId
  /// ---
  String? notificationId;

  /// [ZH]
  /// ---
  /// 小米的渠道 ID
  /// 该条消息针对小米使用的推送渠道，如开发者集成了小米推送，需要指定 channelId 时，可向 Android 端
  /// 研发人员获取，channelId 由开发者自行创建。
  /// ---
  /// [EN]
  /// ---
  /// Xiaomi channel ID
  /// If Xiaomi Push is integrated and a specific channelId is needed, obtain it from Android team
  /// The channel is created by the developer
  /// ---
  String? channelIdForXiaoMi;

  /// [ZH]
  /// ---
  /// 华为的渠道 ID
  /// 该条消息针对华为使用的推送渠道，如开发者集成了华为推送，需要指定 channelId 时，可向 Android 端
  /// 研发人员获取，channelId 由开发者自行创建。
  /// ---
  /// [EN]
  /// ---
  /// Huawei channel ID
  /// If Huawei Push is integrated and a specific channelId is needed, obtain it from Android team
  /// The channel is created by the developer
  /// ---
  String? channelIdForHuaWei;

  /// [ZH]
  /// ---
  /// 华为推送紧急程度
  /// ---
  /// [EN]
  /// ---
  /// Huawei push importance level
  /// ---
  RCCallHuaWeiPushImportance? importanceForHuaWei;

  /// [ZH]
  /// ---
  /// OPPO 的渠道 ID
  /// 该条消息针对 OPPO 使用的推送渠道，如开发者集成了 OPPO 推送，需要指定 channelId 时，可向 Android 端
  /// 研发人员获取，channelId 由开发者自行创建。
  /// ---
  /// [EN]
  /// ---
  /// OPPO channel ID
  /// If OPPO Push is integrated and a specific channelId is needed, obtain it from Android team
  /// The channel is created by the developer
  /// ---
  String? channelIdForOppo;

  /// [ZH]
  /// ---
  /// VIVO 推送通道类型
  /// 开发者集成了 VIVO 推送，需要指定推送类型时，可进行设置。
  /// ---
  /// [EN]
  /// ---
  /// VIVO push channel type
  /// Set this when VIVO Push is integrated and a specific type is required
  /// ---
  RCCallVivoPushType? vivoPushType;

  /// [ZH]
  /// ---
  /// FCM 通知类型推送时所使用的分组 id
  /// ---
  /// [EN]
  /// ---
  /// Group id used for FCM notification-type push
  /// ---
  String? collapseKeyForFCM;

  /// [ZH]
  /// ---
  /// FCM 通知类型的推送所使用的通知图片 url
  /// ---
  /// [EN]
  /// ---
  /// Notification image url used for FCM notification-type push
  /// ---
  String? imageUrlForFCM;
}

class RCCallPushConfig {
  RCCallPushConfig.create({
    this.templateId,
    this.title,
    this.content,
    this.data,
    this.disableTitle = false,
    this.forceShowDetailContent = false,
    this.iOSConfig,
    this.androidConfig,
  });

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'disableTitle': disableTitle,
      'title': title,
      'content': content,
      'data': data,
      'forceShowDetailContent': forceShowDetailContent,
      'templateId': templateId,
    };

    if (iOSConfig != null) {
      json['IOSConfig'] = iOSConfig!.toJson();
    }
    if (androidConfig != null) {
      json['androidConfig'] = androidConfig!.toJson();
    }

    return json;
  }

  /// [ZH]
  /// ---
  /// 是否屏蔽通知标题
  ///
  /// * true:  不显示通知标题
  /// * false: 显示通知标题
  ///
  /// 默认情况下融云单聊消息通知标题为用户名、群聊消息为群名称，设置后不会再显示通知标题。
  /// 此属性只针目标用户为 iOS 平台时有效，Android 第三方推送平台的通知标题为必填项，所以暂不支持。
  /// ---
  /// [EN]
  /// ---
  /// Whether to hide the notification title
  ///
  /// * true:  Hide title
  /// * false: Show title
  ///
  /// By default, single chat shows sender name; group chat shows group name
  /// Only applies to iOS. Android vendor push requires a title, so not supported
  /// ---
  bool disableTitle;

  /// [ZH]
  /// ---
  /// 推送标题
  ///
  /// 如果没有设置，会使用下面的默认标题显示规则
  ///
  /// 默认标题显示规则：
  /// * 内置消息：单聊通知标题显示为发送者名称，群聊通知标题显示为群名称。
  /// * 自定义消息：默认不显示标题。
  /// ---
  /// [EN]
  /// ---
  /// Push title
  ///
  /// If not set, the default rules apply:
  /// * Built-in messages: single chat uses sender name; group chat uses group name
  /// * Custom messages: no title by default
  /// ---
  String? title;

  /// [ZH]
  /// ---
  /// 推送内容
  ///
  /// 优先使用 MessagePushConfig 的 pushContent，如果没有，则使用 sendMessage 或者 sendMediaMessage 的 pushContent。
  /// ---
  /// [EN]
  /// ---
  /// Push content
  ///
  /// Prefer MessagePushConfig.pushContent; otherwise use pushContent passed to sendMessage/sendMediaMessage
  /// ---
  String? content;

  /// [ZH]
  /// ---
  /// 远程推送附加信息
  /// 优先使用 MessagePushConfig 的 pushData，如果没有，则使用 sendMessage 或者 sendMediaMessage 的 pushData。
  /// ---
  /// [EN]
  /// ---
  /// Extra data for remote push
  /// Prefer MessagePushConfig.pushData; otherwise use pushData passed to sendMessage/sendMediaMessage
  /// ---
  String? data;

  /// [ZH]
  /// ---
  /// 是否强制显示通知详情
  /// 当目标用户通过 RCPushProfile 中的 updateShowPushContentStatus 设置推送不显示消息详情时，可通过此参数，强制设置该条消息显示推送详情。
  /// ---
  /// [EN]
  /// ---
  /// Whether to force showing message details in notifications
  /// Overrides the user's setting from RCPushProfile.updateShowPushContentStatus
  /// ---
  bool forceShowDetailContent;

  /// [ZH]
  /// ---
  /// 推送模板 ID
  ///
  /// 设置后根据目标用户通过 SDK RCPushProfile 中的 setPushLanguageCode 设置的语言环境，匹配模板中设置的语言内容进行推送，未匹配成功时使用默认内容进行推送，模板内容在“开发者后台-自定义推送文案”中进行设置。
  /// 注：RCMessagePushConfig 中的 Title 和 PushContent 优先级高于模板 ID（templateId）中对应的标题和推送内容。
  /// ---
  /// [EN]
  /// ---
  /// Push template ID
  ///
  /// Based on recipient's RCPushProfile.setPushLanguageCode, pick template language; fallback to default if unmatched
  /// Configure templates in Developer Console > Custom Push Text
  /// Note: RCMessagePushConfig Title and PushContent override templateId content
  /// ---
  String? templateId;

  /// [ZH]
  /// ---
  /// iOS 平台相关配置
  /// ---
  /// [EN]
  /// ---
  /// iOS-specific configuration
  /// ---
  RCCallIOSPushConfig? iOSConfig;

  /// [ZH]
  /// ---
  /// Android 平台相关配置
  /// ---
  /// [EN]
  /// ---
  /// Android-specific configuration
  /// ---
  RCCallAndroidPushConfig? androidConfig;
}

/// [ZH]
/// ---
/// android 平台独有配置项
/// ---
/// [EN]
/// ---
/// Android-only configuration
/// ---
class RCCallAudioConfig {
  RCCallAudioConfig.create({
    this.enableMicrophone = true,
    this.enableStereo = true,
    this.audioSource = 7,
    this.audioBitrate = 32,
    this.audioSampleRate = 48000,
    this.type = RCCallAudioCodecType.opus,
  });

  RCCallAudioConfig.fromJson(Map<dynamic, dynamic> json)
    : enableMicrophone = json['enableMicrophone'],
      enableStereo = json['enableStereo'],
      audioSource = json['audioSource'],
      audioBitrate = json['audioBitrate'],
      audioSampleRate = json['audioSampleRate'],
      type = RCCallAudioCodecType.values[json['type']];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'enableMicrophone': enableMicrophone,
      'enableStereo': enableStereo,
      'audioSource': audioSource,
      'audioBitrate': audioBitrate,
      'audioSampleRate': audioSampleRate,
      'type': type.index,
    };
    return json;
  }

  bool enableMicrophone;
  bool enableStereo;
  int audioSource;
  int audioBitrate;
  int audioSampleRate;
  RCCallAudioCodecType type;
}

class RCCallVideoConfig {
  RCCallVideoConfig.create({
    this.profile = RCCallVideoProfile.profile_480_640_high,
    this.defaultCamera = RCCallCamera.front,
    this.cameraOrientation = RCCallCameraOrientation.portrait,
    this.enableHardwareDecoder = true,
    this.hardwareDecoderColor = -1,
    this.enableHardwareEncoder = true,
    this.enableHardwareEncoderHighProfile = true,
    this.enableEncoderTexture = true,
    this.hardWareEncoderColor = -1,
    this.hardWareEncoderFrameRate = 30,
    this.hardwareEncoderBitrateMode = RCCallVideoBitrateMode.cbr,
    this.previewMirror = true,
  });

  RCCallVideoConfig.fromJson(Map<dynamic, dynamic> json)
    : enableHardwareDecoder = json['enableHardwareDecoder'],
      hardwareDecoderColor = json['hardwareDecoderColor'],
      enableHardwareEncoder = json['enableHardwareEncoder'],
      enableHardwareEncoderHighProfile =
          json['enableHardwareEncoderHighProfile'],
      enableEncoderTexture = json['enableEncoderTexture'],
      hardWareEncoderColor = json['hardWareEncoderColor'],
      hardWareEncoderFrameRate = json['hardWareEncoderFrameRate'],
      hardwareEncoderBitrateMode =
          RCCallVideoBitrateMode.values[json['hardwareEncoderBitrateMode']],
      previewMirror = json['previewMirror'],
      profile = RCCallVideoProfile.values[json['profile']],
      defaultCamera = RCCallCamera.values[json['defaultCamera']],
      cameraOrientation =
          RCCallCameraOrientation.values[json['cameraOrientation']];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'profile': profile.index,
      'defaultCamera': defaultCamera.index,
      'cameraOrientation': cameraOrientation.index,
      'enableHardwareDecoder': enableHardwareDecoder,
      'hardwareDecoderColor': hardwareDecoderColor,
      'enableHardwareEncoder': enableHardwareEncoder,
      'enableHardwareEncoderHighProfile': enableHardwareEncoderHighProfile,
      'enableEncoderTexture': enableEncoderTexture,
      'previewMirror': previewMirror,
      'hardWareEncoderColor': hardWareEncoderColor,
      'hardWareEncoderFrameRate': hardWareEncoderFrameRate,
      'hardwareEncoderBitrateMode': hardwareEncoderBitrateMode.index,
    };
    return json;
  }

  /// [ZH]
  /// ---
  /// 视频配置
  ///
  /// 默认值 profile_480_640
  /// ---
  /// [EN]
  /// ---
  /// Video configuration
  ///
  /// Default: profile_480_640
  /// ---
  RCCallVideoProfile profile;

  /// [ZH]
  /// ---
  /// 摄像头
  ///
  ///  默认值 front
  /// ---
  /// [EN]
  /// ---
  /// Camera
  ///
  /// Default: front
  /// ---
  RCCallCamera defaultCamera;

  /// [ZH]
  /// ---
  /// 相机方向
  ///
  /// 默认值 portrait
  /// ---
  /// [EN]
  /// ---
  /// Camera orientation
  ///
  /// Default: portrait
  /// ---
  RCCallCameraOrientation cameraOrientation;

  /// [ZH]
  /// ---
  /// 以下为 android 平台独有配置项
  /// ---
  /// [EN]
  /// ---
  /// Android-only fields below
  /// ---
  bool enableHardwareDecoder;
  int hardwareDecoderColor;
  bool enableHardwareEncoder;
  bool enableHardwareEncoderHighProfile;
  bool enableEncoderTexture;
  int hardWareEncoderColor;
  int hardWareEncoderFrameRate;
  RCCallVideoBitrateMode hardwareEncoderBitrateMode;
  bool previewMirror;
}

class RCCallBeautyOption {
  RCCallBeautyOption.create({
    this.whitenessLevel = 0,
    this.smoothLevel = 0,
    this.ruddyLevel = 0,
    this.brightLevel = 0,
  });

  RCCallBeautyOption.fromJson(Map<dynamic, dynamic> json)
    : whitenessLevel = json['whitenessLevel'],
      smoothLevel = json['smoothLevel'],
      ruddyLevel = json['ruddyLevel'],
      brightLevel = json['brightLevel'];

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'whitenessLevel': whitenessLevel,
      'smoothLevel': smoothLevel,
      'ruddyLevel': ruddyLevel,
      'brightLevel': brightLevel,
    };
    return json;
  }

  /// [ZH]
  /// ---
  /// 美白
  ///
  /// 取值范围 [0 ~ 9] 0是正常值
  /// ---
  /// [EN]
  /// ---
  /// Whiteness
  ///
  /// Range [0 ~ 9], 0 is neutral
  /// ---
  int whitenessLevel;

  /// [ZH]
  /// ---
  /// 磨皮
  ///
  /// 取值范围 [0 ~ 9] 0是正常值
  /// ---
  /// [EN]
  /// ---
  /// Smoothing
  ///
  /// Range [0 ~ 9], 0 is neutral
  /// ---
  int smoothLevel;

  /// [ZH]
  /// ---
  /// 红润
  ///
  /// 取值范围 [0 ~ 9] 0是正常值
  /// ---
  /// [EN]
  /// ---
  /// Rosiness
  ///
  /// Range [0 ~ 9], 0 is neutral
  /// ---
  int ruddyLevel;

  /// [ZH]
  /// ---
  /// 亮度
  ///
  /// 取值范围 [0 ~ 9] 5是正常值
  /// ---
  /// [EN]
  /// ---
  /// Brightness
  ///
  /// Range [0 ~ 9], 5 is neutral
  /// ---
  int brightLevel;
}

class RCCallUserProfile {
  RCCallUserProfile.fromJson(Map<dynamic, dynamic> json)
    : userType = RCCallUserType.values[json['userType']],
      mediaType = RCCallMediaType.values[json['mediaType']],
      userId = json['userId'],
      mediaId = json['mediaId'],
      enableCamera = json['enableCamera'],
      enableMicrophone = json['enableMicrophone'];

  /// [ZH]
  /// ---
  /// 用户身份类型
  /// ---
  /// [EN]
  /// ---
  /// User role type
  /// ---
  RCCallUserType userType;

  /// [ZH]
  /// ---
  /// 通话媒体类型
  /// ---
  /// [EN]
  /// ---
  /// Call media type
  /// ---
  RCCallMediaType mediaType;

  /// [ZH]
  /// ---
  /// 用户id
  /// ---
  /// [EN]
  /// ---
  /// User ID
  /// ---
  String userId;

  /// [ZH]
  /// ---
  /// 用户的通话媒体连接 ID
  /// ---
  /// [EN]
  /// ---
  /// User's media connection ID
  /// ---
  String? mediaId;

  /// [ZH]
  /// ---
  /// 用户是否开启摄像头
  /// ---
  /// [EN]
  /// ---
  /// Whether the user enabled camera
  /// ---
  bool enableCamera;

  /// [ZH]
  /// ---
  /// 用户是否开启麦克风
  /// ---
  /// [EN]
  /// ---
  /// Whether the user enabled microphone
  /// ---
  bool enableMicrophone;
}
