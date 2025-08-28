//
//  RCCallIWCallSession.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <UIKit/UIKit.h>
#import <RongCallWrapper/RCCallIWUserProfile.h>
#import <RongCallWrapper/RCCallIWDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallIWCallSession : NSObject

/*!
 通话类型
 */
@property (nonatomic, readonly) RCCallIWCallType callType;

/*!
 通话媒体类型
 */
@property (nonatomic, readonly) RCCallIWMediaType mediaType;

/*!
 通话id
 */
@property (nonatomic, readonly) NSString *callId;

/*!
 通话目标id
 */
@property (nonatomic, readonly) NSString *targetId;

/*!
 RTC会话唯一标识, 用于 Server API
 */
@property (nonatomic, readonly) NSString *sessionId;

/*!
 通话的扩展信息
 */
@property (nonatomic, readonly) NSString *extra;

/*!
 通话开始的时间

 @discussion 如果是用户呼出的通话，则startTime为通话呼出时间；如果是呼入的通话，则startTime为通话呼入时间。
 */
@property (nonatomic, readonly) long long startTime;

/*!
 通话接通时间
 */
@property (nonatomic, readonly) long long connectedTime;

/*!
 通话结束时间
 */
@property (nonatomic, readonly) long long endTime;

/*!
 当前通话发起者
 */
@property (nonatomic, readonly) RCCallIWUserProfile *caller;

/*!
 邀请当前用户到当前通话的邀请者
 */
@property (nonatomic, readonly) RCCallIWUserProfile *inviter;

/*!
 当前用户
 */
@property (nonatomic, readonly) RCCallIWUserProfile *mine;

/*!
 当前通话的全部用户列表
 */
@property (nonatomic, readonly) NSArray<RCCallIWUserProfile *> *users;

@end

NS_ASSUME_NONNULL_END
