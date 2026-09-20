import 'package:flutter/foundation.dart';

/// Observes the lifecycle of the objects this app injects.
///
/// `package:provider` has no observer hook of its own — that is a Riverpod
/// API — and [ChangeNotifier] has none either: it is a `mixin class` with no
/// constructor, so there is nothing to notify from. The seam therefore lives
/// on the objects, not on the registration: one base class per layer reports
/// through [Di.observer], exactly the way `BlocBase` reports through
/// `Bloc.observer`.
///
/// Registration sites stay plain `ChangeNotifierProvider` / `Provider`.
abstract class DiObserver {
  const DiObserver();

  /// An observer that records nothing — the default until one is installed,
  /// and the way a test puts things back.
  const factory DiObserver.silent() = _SilentDiObserver;

  /// Called from the constructor of every base class below.
  void onCreate(Object instance) {}

  /// Called from `dispose()` of the two layers that own resources:
  /// [BaseViewModel] and [BaseLocalService].
  void onDispose(Object instance) {}
}

class _SilentDiObserver extends DiObserver {
  const _SilentDiObserver();
}

/// The single install point for a [DiObserver].
abstract final class Di {
  /// Set once, in `main()` or in a test's `setUp`. Silent until then.
  static DiObserver observer = const DiObserver.silent();

  /// Reports creation for an object that cannot extend a base class.
  ///
  /// Retrofit generates `class _FooApiClient implements FooApiClient`, and an
  /// `implements` never inherits a constructor — so a generated client can
  /// never report through [BaseApiClient]. Registration sites wrap it instead:
  /// `Provider(create: (c) => Di.observed(FooApiClient(c.read())))`.
  static T observed<T extends Object>(T instance) {
    observer.onCreate(instance);
    return instance;
  }
}

/// Base class for ViewModels, so they are observed without wrapping the
/// provider that creates them.
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

/// Base class for API clients.
///
/// It declares nothing but a constructor, and that is deliberate: a
/// constructor is not part of a class's implicit interface, so the fakes in
/// `test/testing/fakes/` keep saying `implements ChannelApiClient` with
/// nothing extra to stub out. API clients hold no resources, so they report
/// creation only.
abstract class BaseApiClient {
  BaseApiClient() {
    Di.observer.onCreate(this);
  }
}

/// Base class for repositories.
///
/// Constructor-only for the same reason as [BaseApiClient] — repositories are
/// faked by interface throughout the test suite. Repositories hold no
/// resources of their own, so they report creation only.
abstract class BaseRepo {
  BaseRepo() {
    Di.observer.onCreate(this);
  }
}

/// Base class for local services.
///
/// These are the only data-layer objects that own a resource — a stream the
/// tree has to close — so this is the one data-layer base that carries
/// [dispose]. Subclasses override it, close their stream, and call `super`.
abstract class BaseLocalService {
  BaseLocalService() {
    Di.observer.onCreate(this);
  }

  @mustCallSuper
  void dispose() {
    Di.observer.onDispose(this);
  }
}
