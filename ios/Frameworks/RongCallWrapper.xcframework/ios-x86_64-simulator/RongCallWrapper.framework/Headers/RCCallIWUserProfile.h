//
//  RCCallIWUserProfile.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <Foundation/Foundation.h>
#import <RongCallWrapper/RCCallIWDefine.h>

NS_ASSUME_NONNULL_BEGIN

@interface RCCallIWUserProfile : NSObject
/*!
 用户身份类型
 */
@property (nonatomic, readonly) RCCallIWUserType userType;
/*!
 通话媒体类型
 */
@property (nonatomic, readonly) RCCallIWMediaType mediaType;
/*!
 用户id
 */
@property (nonatomic, readonly) NSString *userId;
/*!
 用户的通话媒体连接ID
 */
@property (nonatomic, readonly) NSString *mediaId;
/*!
 用户是否开启摄像头
 */
@property (nonatomic, readonly) BOOL enableCamera;
/*!
 用户是否开启麦克风
 */
@property (nonatomic, readonly) BOOL enableMicrophone;

@end

NS_ASSUME_NONNULL_END
