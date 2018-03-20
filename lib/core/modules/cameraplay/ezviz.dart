import 'dart:async';

import 'package:flutter/services.dart';

class Ezviz {
  static const MethodChannel _channel = const MethodChannel('ezviz');

  static Future<String> get platformVersion =>
      _channel.invokeMethod('getPlatformVersion', {'a': 1, 'b': 2});

  static startCameraPlayPage(
      String ezToken, String deviceSerial, String verifyCode, String cameraNo) {
    _channel.invokeMethod('startCameraPlayPage', {
      'ezToken': ezToken,
      'deviceSerial': deviceSerial,
      'verifyCode': verifyCode,
      'cameraNo': cameraNo
    });
  }
}
