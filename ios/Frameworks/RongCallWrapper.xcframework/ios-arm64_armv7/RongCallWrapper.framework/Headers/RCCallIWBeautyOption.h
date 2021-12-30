//
//  RCCallIWBeautyOption.h
//  RongCallWrapper
//
//  Created by lang.li on 2021/11/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/*!
 美颜配置
 */
@interface RCCallIWBeautyOption : NSObject

/*!
 美白 取值范围 [0 ~ 9] 0是正常值
 */
@property (nonatomic, assign) NSInteger whitenessLevel;

/*!
 磨皮 取值范围 [0 ~ 9] 0是正常值
 */
@property (nonatomic, assign) NSInteger smoothLevel;

/*!
 红润 取值范围 [0 ~ 9] 0是正常值
 */
@property (nonatomic, assign) NSInteger ruddyLevel;

/*!
 亮度 取值范围 [0 ~ 9] 5是正常值
 */
@property (nonatomic, assign) NSInteger brightLevel;

@end

NS_ASSUME_NONNULL_END
