# 融云CallLib Flutter 插件

<!-- 快速实现音视频通话 CallLib -->

CallLib 是在 RTCLib 基础上，额外封装了一套音视频呼叫功能 SDK，包含了单人视频呼叫的各种场景和功能，通过集成它，您可以自由的实现音视频呼叫场景的各种玩法。

### 步骤 1：服务开通

您在融云创建的应用默认不会启用音视频服务。在使用融云提供的任何音视频服务前，您需要前往开发者后台，为应用开通音视频服务。

### 步骤 2：SDK 导入

您需要导入融云音视频通话能力库 CallLib。

具体步骤请参阅 <a href="#id_import">导入 CallLib SDK</a>。 

### 步骤 3：权限配置

* Android 请在 `AndroidManifest.xml` 文件中添加摄像头、麦克风与网络的申请权限：

    ```xml
    <!-- 音视频需要网络权限 和 监听网络状态权限 -->
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
    <uses-permission android:name="android.permission.ACCESS_WIFI_STATE" />
    <!-- 摄像头采集需要 -->
    <uses-permission android:name="android.permission.CAMERA" />
    <!-- 音频采集需要 -->
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    ```

* iOS 请在 `Info.plist` 文件中添加摄像头和麦克风的申请权限：

    ```xml
	<key>NSCameraUsageDescription</key>
	<string>摄像头权限使用描述</string>
	<key>NSMicrophoneUsageDescription</key>
	<string>麦克风权限使用描述</string>
    ```

### 步骤 4：初始化

音视频 SDK 是基于即时通信 SDK 作为信令通道的，所以要先初始化 IM SDK。如果不换 AppKey，在整个应用生命周期中，初始化一次即可。

```dart
RongIMClient.init('从开发者后台申请的 AppKey');
```

### 步骤 5：连接 IM 服务

音视频用户之间的信令传输依赖于融云的即时通信（IM）服务，因此需要先调用 `connect` 与 IM 服务建立好 TCP 长连接。建议在功能模块的加载位置处调用，之后再进行音视频呼叫业务。当模块退出后调用 `disconnect` 或 `logout` 断开该连接。

```dart
RongIMClient.connect('从您服务器端获取的 Token', (code, id) {
  if (code == RCErrorCode.Success) {
    // 连接成功
  } else {
    // 连接失败
  }
});
```

> * 如调用此接口时，遇到网络不好导致连接失败，SDK 会自动启动重连机制进行最多 10 次重连，重连时间间隔分别为 1, 2, 4, 8, 16, 32, 64, 128, 256, 512 秒。在这之后如果仍没有连接成功，还会在检测到设备网络状态变化，比如网络恢复或切换网络时再次尝试重连。
> * 如 App 在被杀死后，接收到了推送通知，点击通知拉起应用时，需要再次调用 connect 方法进行连接。

### 步骤 6：通话事件处理{#event}

* 开发者可通过设置 `RCCallEngine` 中的 `onReceiveCall` 方法来监听通话呼入。

    ```dart
    engine?.onReceiveCall = (RCCallSession session) {
        /// session 通话实体
    };
    ```

* 开发者可通过设置 `RCCallEngine` 中的 `onCallDidMake` 、 `onConnect` 以及 `onDisconnect` 方法来监听通话状态的变化。

    ```dart
    /// 通话拨出监听
    engine?.onCallDidMake = () {
    };

    /// 通话建立监听
    engine?.onConnect = () {
    };

    /// 通话断开监听
    engine?.onDisconnect = (RCCallDisconnectReason reason) {
        /// reason 断开原因
    };
    ```

### 步骤 7：发起呼叫{#call}

连接 IM 服务成功后，可调用 `RCCallEngine` 中的 `startCall` 来方法发起通话。

* 单人通话代码示例：

    ```dart
    /// 被叫用户 Id
    String targetId = 'UserB';
    /// 通话媒体类型
    RCCallMediaType mediaType = RCCallMediaType.audio_video;
    engine?.startCall(targetId, mediaType);
    ```

### 步骤 8：呼叫接听{#answer}

在收到 onReceiveCall(RCCallSession session) 回调之后，调用如下方法接听通话。

```dart
engine?.accept();
```

### 步骤 9：离线推送通知{#push}

集成离线推送后，即使 App 已经被系统回收，也可以收到呼叫的推送通知。详细请参考 Android 、 iOS 远程推送集成文档。


## 导入 SDK<span id='id_import' />

Flutter Call Wrapper Plugin 本质上是对 CallLib 的包装。

1. 在项目工程目录下运行如下命令：

``` 
$ flutter pub add rongcloud_call_wrapper_plugin
```

执行命令后将在项目配置文件 pubspec.yaml 中增加以下代码：

```
dependencies:
  rongcloud_call_wrapper_plugin: 5.24.3
```

2. 在代码中导入 Call Lib ：

``` dart
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';
```


## 通话管理
### 主叫方
#### 发起呼叫

调用 `RCCallEngine.startCall` 方法发起单人或多人音视频通话，该方法默认打开前置摄像头。

* 参数说明：

    | 参数 | 类型 | 必填 | 说明 |
    | :--- | :--- | :--- | :--- |
    | targetId | String  | 是 | 目标 UserId |
    | mediaType | RCCallMediaType | 是 | 发起的通话媒体类型  |
    | extra | String | 否 | 附加信息，透传至对端，对端通过 `RCCallSession.extra` 获取  |

* 示例代码：

    ```dart
    /// 被叫用户 Id
    String targetId = 'UserB';
    /// 通话媒体类型
    RCCallMediaType mediaType = RCCallMediaType.audio_video;
    /// 扩展信息
    String extra = '';
    engine?.startCall(targetId, mediaType, extra);
    ```

#### 指定摄像头发起呼叫

发起单人音视频通话需要打开指定摄像头，请参考以下代码。

* 示例代码：

    ```dart
    RCCallVideoConfig videoConfig = RCCallVideoConfig.create(
      /// 指定开启后置摄像头
      defaultCamera: RCCallCamera.back, 
    );
    /// 配置视频参数
    engine?.setVideoConfig(videoConfig); 
    /// 被叫用户 Id
    String targetId = 'UserB';
    /// 通话媒体类型
    RCCallMediaType mediaType = RCCallMediaType.audio_video;
    /// 扩展信息
    String extra = '';
    engine?.startCall(targetId, mediaType, extra);
    ```

#### 挂断通话

调用 `RCCallEngine.hangup` 方法挂断通话，拒绝和挂断为同一个方法调用，SDK 内部会自动告知对方挂断、拒绝原因。

* 示例代码：

    ```dart
    engine?.hangup();
    ```


### 被叫方
#### 接听通话

##### 默认接听

当收到来自 `onReceiveCall` 的远端通话请求时，可使用 `RCCallEngine` 的 `accept` 方法来接听。

* 示例代码：

    ```dart
    engine?.onReceiveCall = (RCCallSession session) {
        engine?.accept();
    };
    ```

##### 指定摄像头接听

来电监听中接收到来电请求后，调用以下代码接听通话，可以打开指定摄像头。

* 示例代码：

    ```dart
    engine?.onReceiveCall = (RCCallSession session) {
        RCCallVideoConfig videoConfig = RCCallVideoConfig.create(
        /// 指定开启后置摄像头
        defaultCamera: RCCallCamera.back, 
        );
        /// 配置视频参数
        engine?.setVideoConfig(videoConfig); 
        engine?.accept();
    };
    ```

#### 拒绝/挂断通话

调用 `RCCallEngine.hangup` 方法挂断通话，拒绝和挂断为同一个方法调用，SDK 内部会自动告知对方挂断、拒绝原因。

* 示例代码：

    ```dart
    engine?.hangup();
    ```



## 通话监听

融云 CallLib 库提供了以下回调方法用于处理呼叫相关的业务逻辑上报。

#### 来电监听

* 示例代码：

    ```dart
    /// 设置来电回调
    engine?.onReceiveCall = (RCCallSession session) {
        /// session 通话实体
    };
    ```

#### 通话拨出监听

* 示例代码：

    ```dart
    /// 设置通话拨出监听
    engine?.onCallDidMake = () {
    };
    ```

#### 通话建立监听

* 示例代码：

    ```dart
    /// 设置通话建立监听
    engine?.onConnect = () {
    };
    ```

#### 通话断开监听

* 示例代码：

    ```dart
    /// 设置通话断开监听
    engine?.onDisconnect = (RCCallDisconnectReason reason) {
        /// reason 断开原因
    };
    ```

#### 通话异常监听

* 示例代码：

    ```dart
    /// 设置通话异常监听
    engine?.onCallError = (int errorCode) {
        /// errorCode 异常错误码
    };
    ```

#### 摄像头操作监听

* 示例代码：

    ```dart
    /// 设置摄像头操作监听
    engine?.onEnableCamera = (RCCallCamera camera, bool enable) {
        /// camera 当前摄像头
        /// enable 开启状态
    };
    ```

#### 切换摄像头监听

* 示例代码：

    ```dart
    /// 设置切换摄像头监听
    engine?.onSwitchCamera = (RCCallCamera camera) {
        /// camera 当前摄像头
    };
    ```

#### 被叫端正在振铃监听

* 示例代码：

    ```dart
    /// 设置被叫端正在振铃监听
    engine?.onRemoteUserDidRing = (String userId) {
        /// userId 正在振铃的用户 ID
    };
    ```

#### 用户操作麦克风监听

* 示例代码：

    ```dart
    /// 设置用户操作麦克风监听
    engine?.onRemoteUserDidChangeMicrophoneState = (RCCallUserProfile user, bool enable) {
        /// user 操作麦克风的用户
        /// enable 麦克风开启状态
    };
    ```

#### 用户操作摄像头监听

* 示例代码：

    ```dart
    /// 设置用户操作摄像头监听
    engine?.onRemoteUserDidChangeCameraState = (RCCallUserProfile user, bool enable) {
        /// user 操作摄像头的用户
        /// enable 摄像头开启状态
    };
    ```

#### 视频转音频监听

* 示例代码：

    ```dart
    /// 设置视频转音频监听
    engine?.onRemoteUserDidChangeMediaType = (RCCallUserProfile user, RCCallMediaType mediaType) {
        /// user 触发媒体类型转换的用户
        /// mediaType 转换后的媒体类型
    };
    ```

#### 通话网络质量监听

* 示例代码：

    ```dart
    /// 设置通话网络质量监听
    engine?.onNetworkQuality = (RCCallUserProfile user, RCCallNetworkQuality quality) {
        /// user 用户信息
        /// quality 网络质量
    };
    ```

#### 通话音量监听

* 示例代码：

    ```dart
    /// 设置通话音量监听
    engine?.onAudioVolume = (RCCallUserProfile user, int volume) {
        /// user 用户信息
        /// volume 当前音量
    };
    ```

### 通话挂断原因

| 枚举值|平台 | 说明 |
|:---|:---|:---|
| cancel |Android/iOS | 己方取消已发出的通话请求 |
| reject |Android/iOS | 己方拒绝收到的通话请求 |
| hangup |Android/iOS |己方挂断 |
| busy_line |Android/iOS |己方忙碌 |
| no_response |Android/iOS |己方未接听 |
| engine_unsupported |Android/iOS |己方不支持当前引擎 |
| network_error |Android/iOS |己方网络出错 |
| resource_error |iOS | 己方获取媒体资源失败 |
| publish_error |iOS | 己方发布资源失败 |
| subscribe_error |iOS | 己方订阅资源失败 |
| remote_cancel |Android/iOS | 对方取消已发出的通话请求 |
| remote_reject |Android/iOS | 对方拒绝收到的通话请求 |
| remote_hangup |Android/iOS | 通话过程对方挂断 |
| remote_busy_line |Android/iOS | 对方忙碌 |
| remote_no_response |Android/iOS | 对方未接听 |
| remote_engine_unsupported |Android/iOS | 对方不支持当前引擎 |
| remote_network_error |Android/iOS | 对方网络错误 |
| remote_resource_error |iOS | 对方获取媒体资源失败 |
| remote_publish_error |iOS | 对方发布资源失败 |
| remote_subscribe_error |iOS | 对方订阅资源失败 |
| kicked_by_other_call |iOS | 己方其他端已加入新通话 |
| in_other_call |iOS | 己方其他端已在通话中 |
| kicked_by_server |Android/iOS | 己方已被禁止通话 |
| remote_kicked_by_other_call |iOS | 对方其他端已加入新通话 |
| remote_in_other_call |iOS | 对方其他端已在通话中 |
| remote_kicked_by_server |iOS |对方已被禁止通话 |
| accept_by_other_client |iOS | 己方其他端已接听 |
| hangup_by_other_client |iOS | 己方其他端已挂断 |
| add_to_black_list |Android/iOS | 己方被对方加入黑名单 |
| media_server_closed |Android/iOS | 音视频服务已关闭 |
| degrade |iOS |  己方被降级为观察者 |
| init_video_error |Android | 己方摄像头初始化错误，可能是没有打开使用摄像头权限 |
| other_device_had_accepted |Android| 其他端已经接听 |
| service_disconnected |Android |im ipc服务已断开 |

### 通话错误原因

| 状态码  | 平台|说明 |
|:---|:---|:---|
| 0 | Android/iOS|成功 |
| 1 |  Android   | 开通的音视频服务没有及时生效或音视频服务已关闭|
| 2 | iOS | 网络不可用 |
| 3 | iOS | 已经处于通话中了 |
| 4 | iOS | 无效操作 |
| 5 | iOS | 参数错误 |
| 6 | iOS | 网络不稳定 |
| 7 | iOS | 媒体服务请求失败 |
| 8 | iOS | 媒体服务初始化失败 |
| 9 | iOS |  媒体服务未初始化 |
| 10 | iOS |  媒体服务请求超时 |
| 11 | iOS | 未知的媒体服务错误 |
| 12 | iOS |  已被禁止通话 |
| 13 | iOS | 音视频服务已关闭 |
| 14 | iOS | 音视频发布资源失败 |
| 15 | iOS | 音视频订阅资源失败 |
| 16 | iOS | 其他端已在通话中错误 |


## 视频管理


### 视频参数设置

在发起通话和接听通话前，调用 `setVideoConfig` 设置音视频通话采用的分辨率、帧率以及码率。默认值为 profile_480_640_high，前置摄像头。

* 示例代码：

    ```dart
    RCCallVideoConfig videoConfig = RCCallVideoConfig.create(
      /// 设置视频分辨率为 1080p，帧率 30 fps，码率 800 ~ 8000 kbps
      profile: RCCallVideoProfile.profile_1080_1920_high,
    );
    engine?.setVideoConfig(videoConfig);
    ```

### 摄像头设置

#### 配置默认开启的摄像头

在发起通话和接听通话前，调用 `setVideoConfig` 设置默认开启的摄像头，默认配置为 RCCallCamera.front。

* 示例代码：

    ```dart
    RCCallVideoConfig videoConfig = RCCallVideoConfig.create(
      /// 指定开启后置摄像头
      defaultCamera: RCCallCamera.back, 
    );
    /// 配置视频参数
    engine?.setVideoConfig(videoConfig); 
    ```

#### 开关摄像头

在通话建立（RCCallEngine.onConnect）之后操作摄像头，对端会收到 `RCCallEngine.onRemoteUserDidChangeCameraState` 通知。

* 示例代码：

    ```dart
    /// 关闭摄像头
    engine?.enableCamera(false);
    ```

#### 切换前后置摄像头

在通话建立（RCCallEngine.onConnect）之后，调用 `switchCamera()` 方法切换前后置摄像头，该方法适用于通过 SDK 打开默认摄像头的场景，配合 `RCCallEngine.startCall` 使用，`startCall` 方法默认打开前置摄像头。

* 示例代码：

    ```dart
    engine?.switchCamera();
    ```


### 视频转音频

当用户希望从视频通话转为音频时，可以调用 `RCCallEngine` 的 `changeMediaType` 方法。目前仅支持视频单向往音频转换，即参数只能为 `RCCallMediaType.audio`。

* 示例代码：

    ```dart
    engine?.changeMediaType(RCCallMediaType.audio);
    ```


### 美颜处理

在 Flutter CallLib 中封装了融云提供的美颜插件，可以通过以下接口实现美颜功能。
美颜参数设置分为基础值设置和滤镜设置。

#### 美颜基础参数

基础参数目前包括：美白、磨皮、亮度、红润四个参数，取值范围为 [0-9]，0 代表无效果，9 代表最大效果。代码示例如下：

```dart
RCCallBeautyOption option = RCCallBeautyOption.create(
  /// 设置美白参数
  whitenessLevel: whiteness,
  /// 设置磨皮参数
  smoothLevel: smooth,
  /// 设置红润参数
  ruddyLevel: ruddy,
  /// 设置亮度参数
  brightLevel: bright,
);
/// 设置美颜参数和美颜开关 true 是使用美颜，false 不使用美颜
engine?.setBeautyOption(option, true);
```

#### 美颜滤镜设置

滤镜目前包括：唯美、清新、浪漫三种风格，代码示例如下：

```dart
/// 不使用美颜滤镜
engine?.setBeautyFilter(RCCallBeautyFilter.none);
/// 唯美滤镜
engine?.setBeautyFilter(RCCallBeautyFilter.esthetic);
/// 清新滤镜
engine?.setBeautyFilter(RCCallBeautyFilter.fresh);
/// 浪漫滤镜
engine?.setBeautyFilter(RCCallBeautyFilter.romantic);
```


## 音频管理

### 麦克风设置
#### 打开/关闭麦克风

当通话中希望关闭麦克风，可调用 `RCCallEngine` 的 `enableMicrophone` 接口，传入 `false` 达到本地静音效果；当需要再次打开时，传入 `true` 即可。默认值为 `true`，即麦克风打开状态。

```dart
engine?.enableMicrophone(true);
```

### 扬声器设置
#### 听筒/扬声器切换

当通话中希望切换声音播放是由扬声器还是听筒输出时，可调用 `RCCallEngine` 的 `enableSpeaker` 来设置。传入 `true` 代表使用扬声器播放；`false` 代表使用听筒播放。默认是 `false` 即使用听筒播放。

* 示例代码：

    ```dart
    engine?.enableSpeaker(false);
    ```

注：此接口在收到 `RCCallEngine.onConnect()` 回调之后调用才有效。


## 文档

- GitHub：[融云 CallLib Flutter 参考文档](https://github.com/rongcloud/flutter-calllib/tree/master/doc)

## 支持

源码地址 [GitHub](https://github.com/rongcloud/flutter-calllib)，任何问题可以通过 GitHub Issues 提问。
