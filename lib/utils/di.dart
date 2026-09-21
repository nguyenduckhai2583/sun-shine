import 'package:flutter/foundation.dart';

abstract class DiObserver {
  const DiObserver();

  const factory DiObserver.silent() = _SilentDiObserver;

  void onCreate(Object instance) {}

  void onDispose(Object instance) {}
}

class _SilentDiObserver extends DiObserver {
  const _SilentDiObserver();
}

abstract final class Di {
  static DiObserver observer = const DiObserver.silent();
}

abstract class BaseViewModel extends ChangeNotifier {
  BaseViewModel() {
    Di.observer.onCreate(this);
  }

  @override
  @mustCallSuper
  void dispose() {
    Di.observer.onDispose(this);
    super.dispose();
  }
}

abstract class BaseApiClient {
  BaseApiClient() {
    Di.observer.onCreate(this);
  }
}

abstract class BaseRepo {
  BaseRepo() {
    Di.observer.onCreate(this);
  }
}

abstract class BaseLocalService {
  BaseLocalService() {
    Di.observer.onCreate(this);
  }

  @mustCallSuper
  void dispose() {
    Di.observer.onDispose(this);
  }
}
