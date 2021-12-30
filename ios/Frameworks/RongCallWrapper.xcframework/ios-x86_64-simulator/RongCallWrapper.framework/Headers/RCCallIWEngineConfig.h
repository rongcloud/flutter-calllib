//
//  RCCallIWEngineConfig.h
//  RongCallWrapper
//
//  Created by RongCloud on 2021/7/14.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN
/*!
 引擎配置
 */
@interface RCCallIWEngineConfig : NSObject
/*!
 开启通话记录 默认NO
 */
@property (nonatomic, assign) BOOL enableCallSummary;

@end

NS_ASSUME_NONNULL_END
