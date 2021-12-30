#import "RCCallWrapperPlugin.h"

#import <RongCallLib/RongCallLib.h>

#import "RCCallEngineWrapper.h"
#import "RCCallViewWrapper.h"

static NSString* const VER = @"5.1.14";

@implementation RCCallWrapperPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
    [RCCallEngineWrapper registerWithRegistrar:registrar];
    [RCCallViewWrapper registerWithRegistrar:registrar];
}

+ (NSString*)getVersion {
    return VER;
}

+ (void)load {
    [RCUtilities setModuleName:@"callflutter" version:[self getVersion]];
}


@end
