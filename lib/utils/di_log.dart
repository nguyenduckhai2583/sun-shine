import 'package:flutter/foundation.dart';

import 'di.dart';

class DiLog extends DiObserver {
  const DiLog();

  static bool enabled = kDebugMode;

  static void Function(String line)? output;

  @override
  void onCreate(Object instance) => _log('created', instance);

  @override
  void onDispose(Object instance) => _log('deleted', instance);

  static void _log(String event, Object instance) {
    if (!enabled) return;
    final line = '[di] ${instance.runtimeType} $event';
    final sink = output;
    if (sink != null) {
      sink(line);
      return;
    }
    debugPrint(line);
  }
}
