#import <Flutter/Flutter.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSString *const RCCallDemoPictureInPictureChannelName;

@interface RCCallDemoPictureInPictureManager : NSObject

- (instancetype)initWithSourceView:(UIView *)sourceView
                           channel:(FlutterMethodChannel *)channel NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)setEnabled:(BOOL)enabled result:(FlutterResult)result;

- (NSDictionary<NSString *, id> *)state;

- (void)disable;

@end

NS_ASSUME_NONNULL_END
