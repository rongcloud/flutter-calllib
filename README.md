# 融云 Flutter CallLib 

CallLib 是在 RTCLib 基础上，额外封装了一套音视频呼叫功能 SDK，包含了单人视频呼叫的各种场景和功能，通过集成它，您可以自由的实现音视频呼叫场景的各种玩法。

## 准备工作
1. 如果您还没有融云开发者账号，在[融云控制台](https://console.rongcloud.cn/)注册一个。
2. 在控制台，通过**应用配置**>**基本信息**>**App Key**，获取您的 App Key。
3. 在控制台，通过**应用配置**>**音视频服务**>**实时音视频**，开通音视频服务。

## 基本集成步骤

1. [导入 SDK**](https://docs.rongcloud.cn/flutter-calllib/import)

2. **权限配置**
   - Android: 在 `AndroidManifest.xml` 中添加摄像头、麦克风与网络权限。
   - iOS: 在 `Info.plist` 中添加摄像头和麦克风权限。

3. **初始化与连接**
   ```dart
   // 初始化 IM SDK
   RCIMIWEngineOptions options = RCIMIWEngineOptions.create();
   RCIMIWEngine imEngine = await RCIMIWEngine.create(appKey, options);
   
   // 连接 IM 服务
   await engine?.connect(token, timeout, callback: callback);
   ```

4. **发起通话**
   ```dart
   String targetId = 'UserB';
   RCCallMediaType mediaType = RCCallMediaType.audio_video;
   engine?.startCall(targetId, mediaType);
   ```

5. **接听通话**
   ```dart
   engine?.onReceiveCall = (RCCallSession session) {
       engine?.accept();
   };
   ```

## 完整开发指南

详细的集成步骤、API 使用说明、功能配置等内容，请参考 [融云 CallLib Flutter 完整开发文档](https://docs.rongcloud.cn/flutter-calllib/integration)。

文档包含以下完整内容：
-  详细的权限配置说明
-  完整的初始化流程
-  通话事件处理
-  视频管理（摄像头控制、美颜设置等）
-  音频管理（麦克风、扬声器控制等）
-  离线推送通知配置
-  完整的 API 参考
-  错误码说明


## 支持

如有任何问题，请通过以下方式获取帮助：
- 查阅[官方完整文档](https://docs.rongcloud.cn/flutter-calllib/integration)。
- 在 [GitHub Issues](https://github.com/rongcloud/flutter-calllib/issues) 提交问题。
- [提交工单](https://console.rongcloud.cn/agile/formwork/ticket/create)，联系融云技术支持。

---

# Introducing RC CallLib for Flutter

CallLib is an SDK with additional audio and video calling features encapsulated based on RTCLib. It covers various scenarios and functions of one-to-one video calls. By integrating it, you can freely implement various features for audio and video calling scenarios.

## Prerequisites
- Register a RC developer account and create an application
- Obtain the App Key for your application
- Activate the audio and video calling service

## Basic Integration Steps

1. [**Import SDK**](https://docs.rongcloud.io/flutter-calllib/import)

2. **Configure Permissions**
   - Android: Add camera, microphone, and network permissions in `AndroidManifest.xml`.
   - iOS: Add camera and microphone permissions in `Info.plist`.

3. **Initialize and Connect**
   ```dart
   // Initialize IM SDK
   RCIMIWEngineOptions options = RCIMIWEngineOptions.create();
   RCIMIWEngine imEngine = await RCIMIWEngine.create(appKey, options);
   
   // Connect to IM service
   await engine?.connect(token, timeout, callback: callback);
   ```

4. **Initiate Call**
   ```dart
   String targetId = 'UserB';
   RCCallMediaType mediaType = RCCallMediaType.audio_video;
   engine?.startCall(targetId, mediaType);
   ```

5. **Answer Call**
   ```dart
   engine?.onReceiveCall = (RCCallSession session) {
       engine?.accept();
   };
   ```

## Complete Development Guide

For detailed integration steps, API usage instructions, feature configurations, and more, please refer to [RC CallLib Flutter Complete Development Documentation](https://docs.rongcloud.io/flutter-calllib/integration).

The documentation includes comprehensive content on:
- Detailed permission configuration instructions
- Complete initialization process
- Call event handling
- Video management (camera control, beauty filters, etc.)
- Audio management (microphone, speaker control, etc.)
- Offline push notification configuration
- Complete API reference
- Error code explanations

## Support

For any questions, please get help through:
- Consult the [Official Complete Documentation](https://docs.rongcloud.cn/flutter-calllib/integration).
- [Submit a ticket](https://console.rongcloud.io/agile/formwork/ticket/create) to contact RC technical support.