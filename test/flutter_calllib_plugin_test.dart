import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rongcloud_call_wrapper_plugin/rongcloud_call_wrapper_plugin.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_call_plugin');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    RCCallEngine engine = await RCCallEngine.create();
    expect(await engine.getBeautyOption(), '42');
  });
}
