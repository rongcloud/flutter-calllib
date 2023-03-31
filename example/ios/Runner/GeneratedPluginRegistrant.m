//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

#if __has_include(<leak_detector/LeakDetectorPlugin.h>)
#import <leak_detector/LeakDetectorPlugin.h>
#else
@import leak_detector;
#endif

#if __has_include(<permission_handler_apple/PermissionHandlerPlugin.h>)
#import <permission_handler_apple/PermissionHandlerPlugin.h>
#else
@import permission_handler_apple;
#endif

#if __has_include(<rongcloud_beauty_wrapper_plugin/RCBeautyWrapperPlugin.h>)
#import <rongcloud_beauty_wrapper_plugin/RCBeautyWrapperPlugin.h>
#else
@import rongcloud_beauty_wrapper_plugin;
#endif

#if __has_include(<rongcloud_call_wrapper_plugin/RCCallWrapperPlugin.h>)
#import <rongcloud_call_wrapper_plugin/RCCallWrapperPlugin.h>
#else
@import rongcloud_call_wrapper_plugin;
#endif

#if __has_include(<rongcloud_im_wrapper_plugin/RCIMWrapperPlugin.h>)
#import <rongcloud_im_wrapper_plugin/RCIMWrapperPlugin.h>
#else
@import rongcloud_im_wrapper_plugin;
#endif

#if __has_include(<shared_preferences_ios/FLTSharedPreferencesPlugin.h>)
#import <shared_preferences_ios/FLTSharedPreferencesPlugin.h>
#else
@import shared_preferences_ios;
#endif

#if __has_include(<sqflite/SqflitePlugin.h>)
#import <sqflite/SqflitePlugin.h>
#else
@import sqflite;
#endif

#if __has_include(<wakelock/WakelockPlugin.h>)
#import <wakelock/WakelockPlugin.h>
#else
@import wakelock;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [LeakDetectorPlugin registerWithRegistrar:[registry registrarForPlugin:@"LeakDetectorPlugin"]];
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [RCBeautyWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCBeautyWrapperPlugin"]];
  [RCCallWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCCallWrapperPlugin"]];
  [RCIMWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCIMWrapperPlugin"]];
  [FLTSharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"FLTSharedPreferencesPlugin"]];
  [SqflitePlugin registerWithRegistrar:[registry registrarForPlugin:@"SqflitePlugin"]];
  [WakelockPlugin registerWithRegistrar:[registry registrarForPlugin:@"WakelockPlugin"]];
}

@end
