#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
    [[RCCallEngineWrapper sharedInstance] setLocalVideoProcessedDelegate:self];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}



- (void)onPixelBuffer:(CVPixelBufferRef)pixelBuffer {
    
    
}

@end
