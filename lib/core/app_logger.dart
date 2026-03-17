import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message) {
    debugPrint('[IronLog] $message');
  }

  static void e(String message, [Object? error]) {
    debugPrint('[IronLog][ERR] $message${error == null ? '' : ' — $error'}');
  }
}

