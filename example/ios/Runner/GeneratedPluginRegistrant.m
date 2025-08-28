//
//  Generated file. Do not edit.
//

// clang-format off

#import "GeneratedPluginRegistrant.h"

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

#if __has_include(<shared_preferences_foundation/SharedPreferencesPlugin.h>)
#import <shared_preferences_foundation/SharedPreferencesPlugin.h>
#else
@import shared_preferences_foundation;
#endif

@implementation GeneratedPluginRegistrant

+ (void)registerWithRegistry:(NSObject<FlutterPluginRegistry>*)registry {
  [PermissionHandlerPlugin registerWithRegistrar:[registry registrarForPlugin:@"PermissionHandlerPlugin"]];
  [RCBeautyWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCBeautyWrapperPlugin"]];
  [RCCallWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCCallWrapperPlugin"]];
  [RCIMWrapperPlugin registerWithRegistrar:[registry registrarForPlugin:@"RCIMWrapperPlugin"]];
  [SharedPreferencesPlugin registerWithRegistrar:[registry registrarForPlugin:@"SharedPreferencesPlugin"]];
}

@end
