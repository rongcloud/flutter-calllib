//
//  RCCallIWVideoFrameDelegate.h
//  RongCallWrapper
//
//  Created by 潘铭达 on 2021/12/27.
//

#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RCCallIWSampleBufferVideoFrameDelegate <NSObject>

- (void)onPixelBuffer:(CVPixelBufferRef)pixelBuffer;

@end

NS_ASSUME_NONNULL_END
