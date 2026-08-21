#import "AppDelegate.h"
#import "GeneratedPluginRegistrant.h"
#import "RCCallDemoPictureInPictureManager.h"

@interface AppDelegate ()

@property(nonatomic, strong) FlutterMethodChannel *pictureInPictureChannel;
@property(nonatomic, strong) RCCallDemoPictureInPictureManager *pictureInPictureManager;

@end


@implementation AppDelegate

- (BOOL)application:(UIApplication *)application
    didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  [GeneratedPluginRegistrant registerWithRegistry:self];
  [[RCCallEngineWrapper sharedInstance] setLocalVideoProcessedDelegate:self];
  [self configurePictureInPictureChannel];
  // Override point for customization after application launch.
  return [super application:application didFinishLaunchingWithOptions:launchOptions];
}

- (void)configurePictureInPictureChannel {
  UIViewController *rootViewController = self.window.rootViewController;
  if (![rootViewController isKindOfClass:FlutterViewController.class]) {
    NSLog(@"[RCCallDemoPiP] FlutterViewController is unavailable.");
    return;
  }

  FlutterViewController *flutterViewController =
      (FlutterViewController *)rootViewController;
  self.pictureInPictureChannel = [FlutterMethodChannel
      methodChannelWithName:RCCallDemoPictureInPictureChannelName
            binaryMessenger:flutterViewController.binaryMessenger];
  self.pictureInPictureManager = [[RCCallDemoPictureInPictureManager alloc]
      initWithSourceView:flutterViewController.view
                   channel:self.pictureInPictureChannel];

  __weak typeof(self) weakSelf = self;
  [self.pictureInPictureChannel
      setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        __strong typeof(self) strongSelf = weakSelf;
        if (strongSelf == nil) {
          result([FlutterError errorWithCode:@"pip_unavailable"
                                     message:@"Picture in Picture manager is unavailable."
                                     details:nil]);
          return;
        }

        if ([call.method isEqualToString:@"setEnabled"]) {
          NSNumber *enabled = nil;
          if ([call.arguments isKindOfClass:NSNumber.class]) {
            enabled = (NSNumber *)call.arguments;
          } else if ([call.arguments isKindOfClass:NSDictionary.class]) {
            id value = ((NSDictionary *)call.arguments)[@"enabled"];
            if ([value isKindOfClass:NSNumber.class]) {
              enabled = (NSNumber *)value;
            }
          }
          if (enabled == nil) {
            result([FlutterError errorWithCode:@"invalid_arguments"
                                       message:@"setEnabled requires a boolean enabled value."
                                       details:nil]);
            return;
          }
          [strongSelf.pictureInPictureManager setEnabled:enabled.boolValue
                                                   result:result];
        } else if ([call.method isEqualToString:@"getState"]) {
          result([strongSelf.pictureInPictureManager state]);
        } else {
          result(FlutterMethodNotImplemented);
        }
      }];
}


- (void)onPixelBuffer:(CVPixelBufferRef)pixelBuffer {
}

@end
