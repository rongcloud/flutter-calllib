package cn.rongcloud.call.wrapper.flutter;

import io.flutter.plugin.common.EventChannel;

final class MainThreadSink implements EventChannel.EventSink {

    MainThreadSink(EventChannel.EventSink sink) {
        this.sink = sink;
    }

    @Override
    public void success(final Object event) {
        MainThreadPoster.post(new Runnable() {
            @Override
            public void run() {
                sink.success(event);
            }
        });
    }

    @Override
    public void error(final String errorCode, final String errorMessage, final Object errorDetails) {
        MainThreadPoster.post(new Runnable() {
            @Override
            public void run() {
                sink.error(errorCode, errorMessage, errorDetails);
            }
        });
    }

    @Override
    public void endOfStream() {
        MainThreadPoster.post(new Runnable() {
            @Override
            public void run() {
                sink.endOfStream();
            }
        });
    }

    private final EventChannel.EventSink sink;
}
