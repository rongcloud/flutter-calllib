package cn.rongcloud.call.wrapper.flutter;

import androidx.annotation.NonNull;

import io.flutter.embedding.engine.plugins.FlutterPlugin;

/**
 * RCCallWrapperPlugin
 */
public class RCCallWrapperPlugin implements FlutterPlugin {

    @Override
    public void onAttachedToEngine(@NonNull FlutterPluginBinding flutterPluginBinding) {
        RCCallEngineWrapper.getInstance().init(flutterPluginBinding.getBinaryMessenger());
        RCCallViewWrapper.getInstance().init(flutterPluginBinding.getTextureRegistry(), flutterPluginBinding.getBinaryMessenger());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        RCCallEngineWrapper.getInstance().unInit();
        RCCallViewWrapper.getInstance().unInit();
    }
}
