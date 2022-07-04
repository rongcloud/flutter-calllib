//
//  RCIWLog.h
//  RCIWLog
//
//  Created by zhangyifan on 2022/6/13.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, RCIWLogLevel) {
    RCIW_Level_S = -2,//Statistics
    RCIW_Level_R = -1,//Record
    RCIW_Level_N = 0,//None
    RCIW_Level_F = 1,//Fatal
    RCIW_Level_E = 2,//Error
    RCIW_Level_W = 3,//Warn
    RCIW_Level_I = 4,//Info
    RCIW_Level_D = 5,//Debug
    RCIW_Level_V = 6//Verbose
};

#ifdef __cplusplus
extern "C" {
#endif
void RCIWRTCLog(RCIWLogLevel level, NSString *caller, NSString *tag, NSString *flag, NSString *fmt, ...);
#ifdef __cplusplus
}
#endif

