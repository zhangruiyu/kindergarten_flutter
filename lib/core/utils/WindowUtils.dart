import 'dart:ui';

class WindowUtils {
  static double getScreenWidth() {
    return window.physicalSize.width / window.devicePixelRatio;
  }

  static double getScreenHeight() {
    return window.physicalSize.height / window.devicePixelRatio;
  }
}
