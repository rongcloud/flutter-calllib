package cn.rongcloud.call.wrapper.flutter;

import android.util.LongSparseArray;

import androidx.annotation.NonNull;

import java.lang.reflect.InvocationTargetException;
import java.util.HashMap;

import cn.rongcloud.call.wrapper.platform.flutter.RCCallIWFlutterRenderEventsListener;
import cn.rongcloud.call.wrapper.platform.flutter.RCCallIWFlutterView;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.view.TextureRegistry;

public class RCCallViewWrapper implements MethodChannel.MethodCallHandler {

    public static RCCallViewWrapper getInstance() {
        return RCCallViewWrapper.SingletonHolder.instance;
    }

    private RCCallViewWrapper() {
    }

    void init(TextureRegistry registry, BinaryMessenger messenger) {
        this.registry = registry;
        this.messenger = messenger;
        channel = new MethodChannel(messenger, "cn.rongcloud.call.flutter/view");
        channel.setMethodCallHandler(this);
    }

    void unInit() {
        for (int i = 0, size = views.size(); i < size; i++) {
            RCCallView view = views.valueAt(i);
            view.destroy();
        }
        views.clear();
        channel.setMethodCallHandler(null);
    }

    RCCallView getView(long id) {
        return views.get(id);
    }

    @Override
    public void onMethodCall(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        switch (call.method) {
            case "create":
                create(result);
                break;
            case "destroy":
                destroy(call, result);
                break;
        }
    }

    private void create(@NonNull MethodChannel.Result result) {
        RCCallView view = null;
        try {
            view = new RCCallView(registry, messenger);
        } catch (IllegalAccessException | InvocationTargetException | InstantiationException e) {
            e.printStackTrace();
        }
        if (view != null) {
            views.put(view.id, view);
            MainThreadPoster.success(result, view.id);
        } else {
            MainThreadPoster.success(result, -1);
        }
    }

    private void destroy(@NonNull MethodCall call, @NonNull MethodChannel.Result result) {
        Integer id = (Integer) call.arguments;
        assert (id != null);
        RCCallView view = views.get(id.longValue());
        if (view != null) {
            view.destroy();
        }
        MainThreadPoster.success(result);
    }

    private static class SingletonHolder {
        private static final RCCallViewWrapper instance = new RCCallViewWrapper();
    }

    static class RCCallView extends RCCallIWFlutterRenderEventsListener implements EventChannel.StreamHandler {

        private RCCallView(TextureRegistry registry, BinaryMessenger messenger) throws IllegalAccessException, InvocationTargetException, InstantiationException {
            entry = registry.createSurfaceTexture();
            id = entry.id();
            channel = new EventChannel(messenger, "cn.rongcloud.call.flutter/view:" + id);
            channel.setStreamHandler(this);
            view = new RCCallIWFlutterView("RCCallView[" + id + "]");
            view.setRendererEventsListener(this);
            view.createSurface(entry.surfaceTexture());
        }

        @Override
        public void onListen(Object arguments, EventChannel.EventSink events) {
            sink = new MainThreadSink(events);
        }

        @Override
        public void onCancel(Object arguments) {
            sink = null;
        }

        @Override
        public void onFirstFrame() {
            if (sink != null) {
                HashMap<String, Object> arguments = new HashMap<>();
                arguments.put("event", "onFirstFrame");
                sink.success(arguments);
            }
        }

        @Override
        public void onFrameSizeChanged(int width, int height) {
            if (sink != null) {
                HashMap<String, Object> arguments = new HashMap<>();
                arguments.put("event", "onSizeChanged");
                arguments.put("width", width);
                arguments.put("height", height);
                sink.success(arguments);
            }
        }

        private void destroy() {
            view.destroySurface();
            view.release();
            channel.setStreamHandler(null);
            entry.release();
        }

        private final TextureRegistry.SurfaceTextureEntry entry;
        private final long id;
        private final EventChannel channel;
        final RCCallIWFlutterView view;

        private EventChannel.EventSink sink;
    }

    private TextureRegistry registry;
    private BinaryMessenger messenger;
    private MethodChannel channel;

    private final LongSparseArray<RCCallView> views = new LongSparseArray<>();

}
