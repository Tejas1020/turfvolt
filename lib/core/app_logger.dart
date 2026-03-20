import 'package:flutter/foundation.dart';

class AppLogger {
  static void i(String message) {
    debugPrint('[IronLog] $message');
  }

  static void e(String message, [Object? error, Object? stackTrace]) {
    debugPrint('[IronLog][ERR] $message${error == null ? '' : ' — $error'}${stackTrace == null ? '' : '\n$stackTrace'}');
  }

  static void d(String message) {
    debugPrint('[IronLog][DBG] $message');
  }
}

