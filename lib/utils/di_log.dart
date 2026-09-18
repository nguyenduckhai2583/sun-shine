import 'package:flutter/foundation.dart';

import 'di.dart';

/// A [DiObserver] that prints one line per lifecycle event:
///
/// ```
/// [di] ChannelLocalService created
/// [di] ChannelLocalService deleted
/// ```
///
/// Install it with `Di.observer = const DiLog()`.
class DiLog extends DiObserver {
  const DiLog();

  /// Silences the log without uninstalling the observer.
  static bool enabled = kDebugMode;

  /// Swaps the sink — leave it null to print through [debugPrint].
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
