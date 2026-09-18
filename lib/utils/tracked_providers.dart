import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:provider/provider.dart';

typedef InstanceDisposer<T> = void Function(T instance);

abstract final class DiLog {
  static bool enabled = kDebugMode;

  static void Function(String line)? output;

  static void created(Object instance) => _log('+', instance);

  static void disposed(Object instance) => _log('-', instance);

  static void _log(String sign, Object instance) {
    if (!enabled) return;
    final id = identityHashCode(instance).toRadixString(16);
    final line = '[di] $sign ${instance.runtimeType}#$id';
    final sink = output;
    if (sink != null) {
      sink(line);
      return;
    }
    debugPrint(line);
  }
}

Provider<T> trackedProvider<T extends Object>(
  T Function(BuildContext context) create, {
  InstanceDisposer<T>? dispose,
}) {
  return Provider<T>(
    create: (context) {
      final instance = create(context);
      DiLog.created(instance);
      return instance;
    },
    dispose: (context, instance) {
      dispose?.call(instance);
      DiLog.disposed(instance);
    },
  );
}

ListenableProvider<T> trackedViewModel<T extends ChangeNotifier>(
  T Function(BuildContext context) create,
) {
  return ListenableProvider<T>(
    create: (context) {
      final instance = create(context);
      DiLog.created(instance);
      return instance;
    },
    dispose: (context, instance) {
      instance.dispose();
      DiLog.disposed(instance);
    },
  );
}
