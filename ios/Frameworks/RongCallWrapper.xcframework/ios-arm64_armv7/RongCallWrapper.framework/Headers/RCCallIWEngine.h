//
//  RCCallIWEngine.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <UIKit/UIKit.h>
#import <RongCallWrapper/RCCallIWDefine.h>

@class RCCallIWEngineConfig;
@class RCCallIWPushConfig;
@class RCCallIWAudioConfig;
@class RCCallIWVideoConfig;
@class RCCallIWCallSession;
@class RCCallIWUserProfile;
@class RCCallIWBeautyOption;

@protocol RCCallIWEngineDelegate;
@protocol RCCallIWSampleBufferVideoFrameDelegate;

NS_ASSUME_NONNULL_BEGIN

@interface RCCallIWEngine : NSObject

/*!
 获取引擎实例
 
 @return 引擎实例
 */
+ (RCCallIWEngine *)sharedInstance;

/*!
 配置引擎
 
 @param config 引擎配置
 */
- (void)setEngineConfig:(nullable RCCallIWEngineConfig *)config;

/*!
 配置推送
 
 @param callPushConfig   呼叫推送配置
 @param hangupPushConfig 挂断推送配置
 */
- (void)setPushConfig:(nullable RCCallIWPushConfig *)callPushConfig
     hangupPushConfig:(nullable RCCallIWPushConfig *)hangupPushConfig;

/*!
 配置推送
 
 @param callPushConfig     呼叫推送配置
 @param hangupPushConfig   挂断推送配置
 @param enableApplePushKit 设置是否使用苹果 PushKit 推送， YES 使用, NO 不使用
 @discussion
 是否打开苹果 PushKit 推送, 该推送可以直接激活 App, 注: iOS 13 以后 PushKit 必须结合苹果 CallKit.framework 进行使用, 否则无法正常处理 VoIP 相关推送逻辑,
 如果设置为 NO 则使用普通 APNS 消息推送来处理音视频信令逻辑, 默认关闭. 打开之后 App 默认需要自行处理 VoIP 推送唤起 CallKit.framework 的逻辑.
 */
- (void)setPushConfig:(nullable RCCallIWPushConfig *)callPushConfig
     hangupPushConfig:(nullable RCCallIWPushConfig *)hangupPushConfig
   enableApplePushKit:(BOOL)enableApplePushKit;

/*!
 配置音频
 
 @param config 音频配置
 */
- (void)setAudioConfig:(nullable RCCallIWAudioConfig *)config;

/*!
 配置视频
 
 @param config 视频配置
 */
- (void)setVideoConfig:(nullable RCCallIWVideoConfig *)config;

/*!
 设置美颜参数
 
 @param enable YES/NO 是否开启美颜 默认关闭
 @param option 美颜配置参数
 */
- (void)setBeautyOption:(BOOL)enable option:(nullable RCCallIWBeautyOption *)option;

/*!
 获取当前美颜参数

 @return RCCallIWBeautyOption 当前美颜参数对象
 */
- (RCCallIWBeautyOption *)getCurrentBeautyOption;

/*!
 配置视频滤镜
 
 @param filter 滤镜类型
 */
- (void)setBeautyFilter: (RCCallIWBeautyFilter)filter;

/*!
 获取当前滤镜参数

 @return RCCallIWBeautyFilter 当前滤镜类型
 */
- (RCCallIWBeautyFilter)getCurrentBeautyFilter;

/*!
 重置美颜的滤镜参数
 因为 RCRTCBeautyEngine 类是单例对象，所以会保留开发者设置的美颜参数或滤镜类型，
 在需要重置美颜的时候（例如重复进入房间时）需要调用 reset 方法重置所有美颜参数和滤镜。
 */
- (void)resetBeauty;

/*!
 配置监听
 
 @param delegate 监听代理
 */
- (void)setEngineDelegate:(nullable NSObject<RCCallIWEngineDelegate> *)delegate;

/*!
 拨打电话-单聊
 
 @param userId 被叫端UserId
 @param type   发起的通话媒体类型
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前Call Session
 */
- (RCCallIWCallSession *)startCall:(NSString *)userId
                              type:(RCCallIWMediaType)type;

/*!
 拨打电话-单聊
 
 @param userId 被叫端UserId
 @param type   发起的通话媒体类型
 @param extra  附件信息
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前通话 Session
 */

- (RCCallIWCallSession *)startCall:(NSString *)userId
                              type:(RCCallIWMediaType)type
                             extra:(nullable NSString *)extra;

/*!
 拨打电话-群聊
 
 @param groupId 群组Id
 @param userIds 被叫端的用户ID列表, 数组中仅填写被叫端UserId, 请不要填写主叫端UserId, 否则无法发起呼叫
 @param type    发起的通话媒体类型
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前通话 Session
 */
- (RCCallIWCallSession *)startCall:(NSString *)groupId
                           userIds:(NSArray<NSString *> *)userIds
                              type:(RCCallIWMediaType)type;

/*!
 拨打电话-群聊
 
 @param groupId 群组Id
 @param userIds 被叫端的用户ID列表, 数组中仅填写被叫端UserId, 请不要填写主叫端UserId, 否则无法发起呼叫
 @param type    发起的通话媒体类型
 @param extra   附件信息
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前通话 Session
 */
- (RCCallIWCallSession *)startCall:(NSString *)groupId
                           userIds:(NSArray<NSString *> *)userIds
                              type:(RCCallIWMediaType)type
                             extra:(nullable NSString *)extra;

/*!
 拨打电话-群聊
 
 @param groupId 群组Id
 @param userIds 被叫端的用户ID列表, 数组中仅填写被叫端UserId, 请不要填写主叫端UserId, 否则无法发起呼叫
 @param observerUserIds 主叫端指定需要以观察者身份加入房间的用户ID列表, 如果主叫端需要以观察者身份加入房间也需要填写主叫端UserId
 @param type    发起的通话媒体类型
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前通话 Session
 */
- (RCCallIWCallSession *)startCall:(NSString *)groupId
                           userIds:(NSArray<NSString *> *)userIds
                   observerUserIds:(nullable NSArray<NSString *> *)observerUserIds
                              type:(RCCallIWMediaType)type;

/*!
 拨打电话-群聊
 
 @param groupId 群组Id
 @param userIds 被叫端的用户ID列表, 数组中仅填写被叫端UserId, 请不要填写主叫端UserId, 否则无法发起呼叫
 @param observerUserIds 主叫端指定需要以观察者身份加入房间的用户ID列表, 如果主叫端需要以观察者身份加入房间也需要填写主叫端UserId
 @param type    发起的通话媒体类型
 @param extra   附件信息
 @discussion
 如果type为音视频，直接打开默认（前置）摄像头。
 
 @return 当前通话 Session
 */
- (RCCallIWCallSession *)startCall:(NSString *)groupId
                           userIds:(NSArray<NSString *> *)userIds
                   observerUserIds:(nullable NSArray<NSString *> *)observerUserIds
                              type:(RCCallIWMediaType)type
                             extra:(nullable NSString *)extra;

/*!
 获取当前通话 Session
 
 @return 当前通话 Session
 */
- (RCCallIWCallSession *)getCurrentCallSession;

/*!
 接电话

 @discussion
 如果呼入类型为语音通话，即接受语音通话，如果呼入类型为视频通话，即接受视频通话，打开默认（前置）摄像头。
 观察者不开启摄像头。
 */
- (void)accept;

/*!
 挂断电话
 */
- (void)hangup;

/*!
 麦克风控制
 
 @param enable YES 开启麦克风，NO 关闭麦克风
 */
- (void)enableMicrophone:(BOOL)enable;

/*!
 获取当前麦克风状态
 
 @return 当前麦克风是否开启
 */
- (BOOL)isEnableMicrophone;

/*!
 扬声器控制
 
 @param enable YES 开启扬声器，NO 关闭扬声器
 */
- (void)enableSpeaker:(BOOL)enable;

/*!
 获取当前扬声器状态
 
 @return 当前扬声器是否开启
 */
- (BOOL)isEnableSpeaker;

/*!
 摄像头控制
 
 @param enable YES 开启摄像头，NO 关闭摄像头
 */
- (void)enableCamera:(BOOL)enable;

/*!
 摄像头控制
 
 @param enable YES 开启摄像头，NO 关闭摄像头
 @param camera 指定摄像头
 */
- (void)enableCamera:(BOOL)enable camera:(RCCallIWCamera)camera;

/*!
 获取当前摄像头状态
 
 @return 当前摄像头是否开启
 */
- (BOOL)isEnableCamera;

/*!
 获取当前摄像头
 
 @return 当前摄像头
 */
- (RCCallIWCamera)currentCamera;

/*!
 翻转摄像头
 */
- (void)switchCamera;

/*!
 设置预览窗口
 
 @param userId 用户id
 @param view   视频预览视图
 */
- (void)setVideoView:(NSString *)userId
                view:(UIView *)view;

/*!
 设置预览窗口
 
 @param userId 用户id
 @param view   视频预览视图
 @param fit    视频显示模式
 */
- (void)setVideoView:(NSString *)userId
                view:(UIView *)view
                 fit:(RCCallIWViewFitType)fit;

/*!
 修改通话媒体类型
 
 @param type 通话媒体类型
 */
- (void)changeMediaType:(RCCallIWMediaType)type;

/*!
 邀请用户
 
 @param userIds 被邀请用户id列表
 */
- (void)inviteUsers:(NSArray<NSString *> *)userIds;

/*!
 邀请用户
 
 @param userIds         被邀请用户id列表
 @param observerUserIds 被邀请观察者id列表
 */
- (void)inviteUsers:(NSArray<NSString *> *)userIds
    observerUserIds:(NSArray<NSString *> *)observerUserIds;

- (void)setLocalVideoProcessedDelegate:(id<RCCallIWSampleBufferVideoFrameDelegate>)delegate;

@end


@protocol RCCallIWEngineDelegate <NSObject>

@required
/*!
 接收到通话呼入的回调
 
 @param session 通话Session
 */
- (void)didReceiveCall:(RCCallIWCallSession *)session;

/*!
 通话已接通
 */
- (void)callDidConnect;

/*!
 通话已结束
 
 @param reason 结束原因
 */
- (void)callDidDisconnect:(RCCallIWDisconnectReason)reason;

/*!
 对端用户加入了通话
 
 @param user 对端用户信息
 */
- (void)remoteUserDidJoin:(RCCallIWUserProfile *)user;

/*!
 对端用户挂断
 
 @param userId 对端用户信息
 @param reason 挂断原因
 */
- (void)remoteUserDidLeave:(NSString *)userId
                    reason:(RCCallIWDisconnectReason)reason;


@optional
/*!
 接收到通话呼入的远程通知的回调
 */
- (void)didReceiveCallRemoteNotification:(NSString *)callId
                           inviterUserId:(NSString *)inviterUserId
                               mediaType:(RCCallIWMediaType)mediaType
                              userIdList:(NSArray *)userIdList
                                userDict:(NSDictionary *)userDict
                              isVoIPPush:(BOOL)isVoIPPush
                              pushConfig:(RCCallIWPushConfig *)pushConfig;

/*!
 接收到取消通话的远程通知的回调
 */
- (void)didCancelCallRemoteNotification:(NSString *)callId
                          inviterUserId:(NSString *)inviterUserId
                              mediaType:(RCCallIWMediaType)mediaType
                             userIdList:(NSArray *)userIdList
                             pushConfig:(RCCallIWPushConfig *)pushConfig
                         isRemoteCancel:(BOOL)isRemoteCancel;
 
/*!
 开启/关闭摄像头的回调
 */
- (void)didEnableCamera:(RCCallIWCamera)camera
                 enable:(BOOL)enable;

/*!
 切换摄像头的回调
 
 @param camera 当前选择的摄像头
 */
- (void)didSwitchCamera:(RCCallIWCamera)camera;

/*!
 通话出现错误的回调
 */
- (void)callDidError:(RCCallIWErrorCode)code;

/*!
 开始呼叫通话的回调
 */
- (void)callDidMake;

/*!
 对端用户正在振铃
 */
- (void)remoteUserDidRing:(NSString *)userId;

/*!
 有用户被邀请加入通话
 */
- (void)remoteUserDidInvite:(NSString *)userId
                  mediaType:(RCCallIWMediaType)mediaType;

/*!
 对端用户切换了媒体类型
 */
- (void)remoteUserDidChangeMediaType:(RCCallIWUserProfile *)user
                           mediaType:(RCCallIWMediaType)mediaType;

/*!
 对端用户开启或关闭了麦克风的状态
 */
- (void)remoteUserDidChangeMicrophoneState:(RCCallIWUserProfile *)user
                                    enable:(BOOL)enable;

/*!
 对端用户开启或关闭了摄像头的状态
 */
- (void)remoteUserDidChangeCameraState:(RCCallIWUserProfile *)user
                                enable:(BOOL)enable;

/*!
 当前通话网络状态的回调，该回调方法每秒触发一次
 @param user    用户信息
 @param quality 网络质量
 @discussion
 如果user是本端用户, quality代表上行网络质量
 如果user是远端用户, quality代表下行网络质量
 */
- (void)user:(RCCallIWUserProfile *)user networkQuality:(RCCallIWNetworkQuality)quality;

/*!
 当前通话某用户声音音量回调，该回调方法每两秒触发一次
 @param user    用户信息
 @param volume  声音音量
 @discussion
 声音级别: 0~9, 0为无声, 依次变大
 如果user是本端用户, volume代表发送音量
 如果user是远端用户, volume代表接收音量
 */
- (void)user:(RCCallIWUserProfile *)user audioVolume:(int)volume;

@end

NS_ASSUME_NONNULL_END

