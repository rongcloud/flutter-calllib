//
//  RCRTCLogUtility.h
//  RongRTCLib
//
//  Created by RongCloud on 2020/3/2.
//  Copyright © 2020 RongCloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMLibCore/RongIMLibCore.h>

#ifdef __cplusplus
extern "C" {
#endif

void RCRTCLog(RCFwLogLevel level, NSString *tag, NSString *format, ...);

#ifdef __cplusplus
}
#endif

#pragma mark - --------------------------------- 华丽的分割线 -------------------------------------------

#pragma mark - log 来源标记

/*!
 log 来源 APP 触发
 */
FOUNDATION_EXTERN NSString *const RongRTCLogFromAPP;

/*!
 log 来源 Lib 触发
 */
FOUNDATION_EXTERN NSString *const RongRTCLogFromLib;

/*!
 log 来源 protocol 触发
 */
FOUNDATION_EXTERN NSString *const RongRTCLogFromProtocol;

/*!
 操作
 */
FOUNDATION_EXTERN NSString *const RongRTCLogTaskOperation;

#pragma mark - --------------------------------- 华丽的分割线 -------------------------------------------

#pragma mark - log 任务生命周期标记

/*!
 任务开始标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogTaskBegin;

/*!
 任务成功标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogTaskResponse;

/*!
 任务失败标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogTaskError;

/*!
 任务状态标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogTaskStatus;

#pragma mark - --------------------------------- 华丽的分割线 -------------------------------------------

#pragma mark - log 任务名字标记

// ----以下字符串不能随便改-----

#pragma mark - joinRoom
/*!
 joinRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogJoinRoomTag;

#pragma mark - rtcRoomKVUpdate
/*!
 rtcRoomKVUpdate 标记 --kv更新回调
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRtcRoomKVUpdateTag;

#pragma mark - KVMessageHandle
/*!
 KVMessageHandle 标记 --kv 消息处理
 */
FOUNDATION_EXTERN NSString *const RongRTCLogKVMsgHandleTag;

#pragma mark - joinOtherRoom
/*!
 joinOtherRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogJoinOtherRoomTag;

#pragma mark - leaveOtherRoom
/*!
 leaveOtherRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogLeaveOtherRoomTag;

#pragma mark - joinRoomAndGetData
/*!
 joinRoom 从 IM 获取信息的标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogJoinRoomAndGetDataTag;

#pragma mark - leaveRoom
/*!
 leaveRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogLeaveRoomTag;

#pragma mark - createOffer
/*!
 createOffer 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogCreateOfferTag;

#pragma mark - setRemoteSDP
/*!
 setRemoteSDP 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetRemoteSDPTag;

#pragma mark - setLocalSDP
/*!
 setLocalSDP 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetLocalSDPTag;

#pragma mark - createAnswer
/*!
 createAnswer 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogCreateAnswerTag;

#pragma mark - publishStream
/*!
 publishStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogPublishAVStreamTag;

#pragma mark - unpublishStream
/*!
 publishStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUnpublishAVStreamTag;

#pragma mark - MSExchange
/*!
 MediaServerExchange 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMSExchangeTag;

#pragma mark - putInnerDatas
/*!
 putInnerDatas 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogPutInnerDatasTag;

#pragma mark - subscribeLiveStream
/*!
 subscribeLiveStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSubscribeLiveStreamTag;

#pragma mark - subscribeLiveUrl
/*!
 subscribeLiveUrl 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSubscribeLiveUrlTag;

#pragma mark - unsubscribeLiveStream
/*!
 unsubscribeLiveStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUnsubscribeLiveStreamTag;

#pragma mark - mediaLiveLeave
/*!
 mediaLiveLeave 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMediaLiveLeaveTag;

#pragma mark - getRtcToken
/*!
 getRtcToken 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogGetRTCTokenTag;

#pragma mark - subscribeStream
/*!
 subscribeStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSubscribeAVStreamTag;

#pragma mark - unsubscribeStream
/*!
 unsubscribeStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUnsubscribeAVStreamTag;

#pragma mark - startCapture
/*!
 startCapture 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogStartCaptureTag;

#pragma mark - stopCapture
/*!
 stopCapture 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogStopCaptureTag;

#pragma mark - switchCamera
/*!
 switchCamera 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSwitchCameraTag;

#pragma mark - changeVideoSize
/*!
 changeVideoSize 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogChangeVideoSizeTag;

#pragma mark - setMicrophoneDisable
/*!
 setMicrophoneDisable 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetMicrophoneDisableTag;

#pragma mark - useSpeaker
/*!
 useSpeaker 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUseSpeakerTag;

#pragma mark - RTCConfig
/*!
 RTCConfig 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRTCConfigTag;

#pragma mark - RTCAudioConfig
/*!
 RTCAudioConfig 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRTCAudioConfigTag;

#pragma mark - RTCVideoConfig
/*!
 RTCAudioConfig 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRTCVideoConfigTag;

#pragma mark - deviceInfo
/*!
 deviceInfo 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDeviceInfoTag;

#pragma mark - changeAudioScenario
/*!
 changeAudioScenario 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogChangeAudioScenarioTag;

#pragma mark - rejoinRoom
/*!
 rejoinRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRejoinRoomTag;

#pragma mark - resetIce
/*!
 resetIce 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogResetIceTag;

#pragma mark - setMixConfig
/*!
 setMixConfig 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetMixConfigTag;

#pragma mark - rtcPing
/*!
 rtcPing 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRtcPingTag;

#pragma mark - remoteUserPublishResource
/*!
 remoteUserPublishResource 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemoteUserPublishResourceTag;

#pragma mark - remoteUserModifyResource
/*!
 remoteUserModifyResource 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemoteUserModifyResourceTag;

#pragma mark - remoteUserUnpublishResource
/*!
 remoteUserUnpublishResource 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemoteUserUnpublishResourceTag;

#pragma mark - remoteUserTotalContentResource
/*!
 remoteUserTotalContentResource 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemoteUserTotalContentResourceTag;

#pragma mark - userJoined
/*!
 userJoined 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUserJoinedTag;

#pragma mark - userLeft
/*!
 userLeft 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUserLeftTag;

#pragma mark - userOffline
/*!
 userOffline 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUserOfflineTag;

#pragma mark - audioTrackAdd
/*!
 audioTrackAdd 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogAudioTrackAddTag;

#pragma mark - videoTrackAdd
/*!
 videoTrackAdd 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogVideoTrackAddTag;

#pragma mark - addTrack
/*!
 addTrack 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogAddTrackTag;

#pragma mark - firstFrameDraw
/*!
 收到视频第一帧firstFrameDraw 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogfirstFrameDrawTag;

/*!
 收到音频第一个包标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogFirstAudioFrameReceived;

#pragma mark - exceptionalLeaveRoom
/*!
 exceptionalLeaveRoom 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogExceptionalLeaveRoomTag;

#pragma mark - removeStream
/*!
 removeStream 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemoveStreamTag;

#pragma mark - iceConnectionChange
/*!
 iceConnectionChange 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogIceConnectionChangeTag;

#pragma mark - modifyResource
/*!
 modifyResource 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogModifyResourceTag;

#pragma mark - monitorSendStat
/*!
 monitorReceiveStat 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMonitorSendStatTag;

#pragma mark - monitorReceiveStat
/*!
 monitorReceiveStat 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMonitorReceiveStatTag;

#pragma mark - monitorLossStat
/*!
 monitorLossStat 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMonitorLossStatTag;

#pragma mark - muteAll
/*!
 mute all 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogMuteAllTag;

#pragma mark - kicked from Server
/*!
 kicked from Server 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogKickedFromServerTag;

#pragma mark - rtc navi data
/*!
 rtc navi data 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRTCNaviDataTag;

#pragma mark - diffData
/*!
 diffData 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDiffDataTag;

#pragma mark - best url
/*!
 best url 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRTCBestConnectUrlTag;

#pragma mark - set room attribute
/*!
 setRoomAttributeValue 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetRoomAttributeValueTag;

#pragma mark - getRoomAttribute
/*!
 getRoomAttribute 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogGetRoomAttributesTag;

#pragma mark - deleteRoomAttribute
/*!
 deleteRoomAttributes 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDeleteRoomAttributesTag;

#pragma mark - setAttributeValue
/*!
 setAttributeValue 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetAttributeValueTag;

#pragma mark - deleteAttributes
/*!
 deleteAttributes 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDeleteAttributesTag;

#pragma mark - getAttributes
/*!
 getAttributes 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogGetAttributesTag;

#pragma mark - setReconnectEnable
/*!
 setReconnectEnable 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetReconnectEnableTag;

#pragma mark - initRemoteVideoView
/*!
 initRemoteVideoView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogInitRemoteVideoViewTag;

#pragma mark - destroyRemoteVideoView
/*!
 destroyRemoteVideoView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDestroyRemoteVideoViewTag;

#pragma mark - setRemoteRenderView
/*!
 setRemoteRenderView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetRemoteRenderViewTag;

#pragma mark - setLocalRenderView
/*!
 setLocalRenderView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetLocalRenderViewTag;

#pragma mark - setRemoteTextureView
/*!
 setRemoteTextureView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetRemoteTextureViewTag;

#pragma mark - setLocalTextureView
/*!
 setLocalTextureView 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSetLocalTextureViewTag;

#pragma mark - httpRequest
/*!
 httpRequest 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogHttpRequestTag;

#pragma mark - illegalFrameTimestamp
/*!
 IllegalFrameTimestamp 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogIllegalFrameTimestampTag;

#pragma mark - decodeVideoFrameError
/*!
 DecodeVideoFrameError 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogDecodeVideoFrameErrorTag;

#pragma mark - addPublishStreamUrl
/*!
 添加推流地址
 */
FOUNDATION_EXTERN NSString *const RongRTCLogAddPublishStreamUrlTag;

#pragma mark - removePublishStreamUrl
/*!
 移除推流地址
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRemovePublishStreamUrlTag;

#pragma mark - requestJoinOtherRoom
/*!
 发起跨房间邀请, 上行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRequestJoinOtherRoomTag;

#pragma mark - cancelRequestJoinOtherRoom
/*!
 取消跨房间邀请, 上行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogCancelRequestJoinOtherRoomTag;

#pragma mark - responseJoinOtherRoom
/*!
 应答跨房间邀请, 上行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogResponseJoinOtherRoomTag;

#pragma mark - inviteTimeout
/*!
 跨房间邀请超时
 */
FOUNDATION_EXTERN NSString *const RongRTCLogInviteTimeoutTag;

#pragma mark - invite
/*!
 收到邀请, 下行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogInviteTag;

#pragma mark - answerInvite
/*!
 收到邀请应答, 下行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogAnswerInviteTag;

#pragma mark - cancelInvite
/*!
 收到取消邀请, 下行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogCancelInviteTag;

#pragma mark - endInvite
/*!
 收到结束连麦, 下行
 */
FOUNDATION_EXTERN NSString *const RongRTCLogEndInviteTag;

#pragma mark - getCDNUri
/*!
 获取 RTMP 地址
 */
FOUNDATION_EXTERN NSString *const RongRTCLogGetCDNUri;

#pragma mark - subscribeCDNStream
/*!
 订阅 CDN 流内部状态
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSubscribeCDNStream;

#pragma mark - unSubCDNStream
/*!
 取消订阅 CDN 流内部状态
 */
FOUNDATION_EXTERN NSString *const RongRTCLogUnSubCDNStream;

#pragma mark - enableInnerCDN
/*!
 是否启用内置 CDN
 */
FOUNDATION_EXTERN NSString *const RongRTCLogEnableInnerCDN;

#pragma mark - changeVideoSize
/*!
 是否启用内置 CDN
 */
FOUNDATION_EXTERN NSString *const RongRTCChangeCDNVideoSize;

#pragma mark - CDN PauseToPlay
/*!
 是否启用内置 CDN
 */
FOUNDATION_EXTERN NSString *const RongRTCChangeCDNPauseToPlay;

#pragma mark - --------------------------------- 华丽的分割线 -------------------------------------------

#pragma mark - other
/*!
 http error 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogHttpErrorTag;

/*!
 signal error 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogSignalErrorTag;

/*!
 other error 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogOtherErrorTag;

/*!
 room id is not validaty 标记
 */
FOUNDATION_EXTERN NSString *const RongRTCLogRoomIdNotValidatyTag;

#pragma mark - 解释
/*!
 以下规定死
 CALLER: 表示调用方，一般为 A 或者 L， A 表示 APP 调用 L 表示库内部调用，APP 用 A ，Lib 用 L ， 选下面的宏定义
 TAG:tag，日志的具体字符串，规定为宏定义，因为 IM 那边说必须严格按照这些tag，不一样不给上传，选下面的宏定义
 FLAG：Flag 的值一般为 T：task，任务的开始，R：response，任务的成功，E：error，任务的失败，S：任务的中间发生状态，选下面的宏定义
 FMT：具体打印的 log 格式
 */

#pragma mark - --------------------------------- 华丽的分割线 -------------------------------------------

#pragma mark - 宏定义

/*!
 打印 log 的时候，要注意组合，比如，A-jomRoom-T,A-jomRoom-R,A-jomRoom-E,// 来源 app 调用
 L-jomRoom-T,L-jomRoom-R,L-jomRoom-E,// 来源 lib 调用
 P-jomRoom-T,P-jomRoom-R,P-jomRoom-E,// 来源 protocol 调用
 */
#define FINALTAG(a, b, c) [NSString stringWithFormat:@"%@-%@-%@", a, b, c]
/// #define RongRTCLogE( A,t,T, k, ...) [[RCFwLog getInstance] write:RC_Level_E type:RC_Type_RTC tag:TAG(A,t,T) keys:k, ##__VA_ARGS__]
/// #define RongRTCLogI( A,t,T, k, ...) [[RCFwLog getInstance] write:RC_Level_I type:RC_Type_RTC tag:TAG(A,t,T) keys:k, ##__VA_ARGS__]
/// #define RongRTCLogD( A,t,T, k, ...) [[RCFwLog getInstance] write:RC_Level_D type:RC_Type_RTC tag:TAG(A,t,T) keys:k, ##__VA_ARGS__]

#define RongRTCLogD(CALLER, TAG, FLAG, FMT, ...) RCRTCLog(RC_Level_D, FINALTAG(CALLER, TAG, FLAG), FMT, ##__VA_ARGS__);
#define RongRTCLogI(CALLER, TAG, FLAG, FMT, ...) RCRTCLog(RC_Level_I, FINALTAG(CALLER, TAG, FLAG), FMT, ##__VA_ARGS__);
#define RongRTCLogW(CALLER, TAG, ERROR, FMT, ...) \
    RCRTCLog(RC_Level_W, FINALTAG(CALLER, TAG, ERROR), FMT, ##__VA_ARGS__);
#define RongRTCLogE(CALLER, TAG, ERROR, FMT, ...) \
    RCRTCLog(RC_Level_E, FINALTAG(CALLER, TAG, ERROR), FMT, ##__VA_ARGS__);

#define RongRTCLogAE(TAG, FMT, ...) \
    RCRTCLog(RC_Level_E, FINALTAG(RongRTCLogFromAPP, TAG, RongRTCLogTaskError), FMT, ##__VA_ARGS__);
#define RongRTCLogAR(TAG, FMT, ...) \
    RCRTCLog(RC_Level_I, FINALTAG(RongRTCLogFromAPP, TAG, RongRTCLogTaskResponse), FMT, ##__VA_ARGS__);
#define RongRTCLogLE(TAG, FMT, ...) \
    RCRTCLog(RC_Level_E, FINALTAG(RongRTCLogFromLib, TAG, RongRTCLogTaskError), FMT, ##__VA_ARGS__);
#define RongRTCLogLR(TAG, FMT, ...) \
    RCRTCLog(RC_Level_I, FINALTAG(RongRTCLogFromLib, TAG, RongRTCLogTaskResponse), FMT, ##__VA_ARGS__);
