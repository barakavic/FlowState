import 'package:flutter/foundation.dart';

class Log {
  static void debug(String message) {
    if (kDebugMode) {
      print('DEBUG: $message');
    }
  }

  static void telemetry(String event, Map<String, dynamic> data) {
    final payload = {
      'event': event,
      'data': data,
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    };
    print('TELEMETRY: $payload');
  }

  static void error(String message, [dynamic error, StackTrace? stackTrace]) {
    print('ERROR: $message');
    if (error != null) print('DETAILS: $error');
    if (stackTrace != null) print('STACKTRACE: $stackTrace');
  }
}
