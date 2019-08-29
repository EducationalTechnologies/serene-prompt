import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speechrecognition/speechrecognition.dart';

void main() {
  const MethodChannel channel = MethodChannel('speechrecognition');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await Speechrecognition.platformVersion, '42');
  });
}
