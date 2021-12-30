//
//  RCCallIWPushConfig.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <RongCallWrapper/RCCallIWIOSPushConfig.h>
#import <RongCallWrapper/RCCallIWAndroidPushConfig.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 推送配置
 */
@interface RCCallIWPushConfig : NSObject

/*!
 是否屏蔽通知标题
 YES:  不显示通知标题
 NO: 显示通知标题
 
 @discussion 默认情况下融云单聊消息通知标题为用户名、群聊消息为群名称，设置后不会再显示通知标题。
 @discussion 此属性只针目标用户为 iOS 平台时有效，Android 第三方推送平台的通知标题为必填项，所以暂不支持。
 */
@property (nonatomic, assign) BOOL disableTitle;

/*!
 推送标题
 如果没有设置，会使用下面的默认标题显示规则
 默认标题显示规则：
    内置消息：单聊通知标题显示为发送者名称，群聊通知标题显示为群名称。
    自定义消息：默认不显示标题。
 */
@property (nonatomic, copy) NSString *title;

/*!
 推送内容
 优先使用 MessagePushConfig 的 pushContent，如果没有，则使用 sendMessage 或者 sendMediaMessage 的 pushContent。
 */
@property (nonatomic, copy) NSString *content;

/*!
 远程推送附加信息
 优先使用 MessagePushConfig 的 pushData，如果没有，则使用 sendMessage 或者 sendMediaMessage 的 pushData。
 */
@property (nonatomic, copy) NSString *data;

/*!
 是否强制显示通知详情
 当目标用户通过 RCPushProfile 中的 updateShowPushContentStatus 设置推送不显示消息详情时，可通过此参数，强制设置该条消息显示推送详情。
 */
@property (nonatomic, assign) BOOL forceShowDetailContent;

/*!
 推送模板 ID，设置后根据目标用户通过 SDK RCPushProfile 中的 setPushLauguageCode 设置的语言环境，匹配模板中设置的语言内容进行推送，未匹配成功时使用默认内容进行推送，模板内容在“开发者后台-自定义推送文案”中进行设置。
 注：RCMessagePushConfig 中的 Title 和 PushContent 优先级高于模板 ID（templateId）中对应的标题和推送内容。
 */
@property (nonatomic, copy) NSString *templateId;

/*!
 iOS 平台相关配置
 */
@property (nonatomic, strong) RCCallIWIOSPushConfig *iOSConfig;

/*!
 Android 平台相关配置
 */
@property (nonatomic, strong) RCCallIWAndroidPushConfig *androidConfig;

@end

NS_ASSUME_NONNULL_END
