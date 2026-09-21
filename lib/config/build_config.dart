import 'env.dart';

/// Reads the values injected by `--dart-define-from-file=_env/<env>.env`.
///
/// `String.fromEnvironment` must be `const` and its key must be a literal, so
/// every lookup is spelled out below rather than driven by a loop.
class BuildConfig {
  factory BuildConfig() => _instance;

  BuildConfig._internal();

  static final BuildConfig _instance = BuildConfig._internal();

  late final bool isDebug;
  late final String appName;
  late final String appSuffix;
  late final String appVersion;
  late final String appVersionCode;
  late final Env env;

  /// Call once from `main()` before `runApp`.
  void setupEnvironment() {
    isDebug =
        const String.fromEnvironment('APP_IS_DEBUG', defaultValue: 'n') == 'y';
    appName = const String.fromEnvironment(
      'APP_NAME',
      defaultValue: 'Sun Shine',
    );
    appSuffix = const String.fromEnvironment('APP_SUFFIX');
    appVersion = const String.fromEnvironment(
      'APP_VERSION',
      defaultValue: '1.0.0',
    );
    appVersionCode = const String.fromEnvironment(
      'APP_VERSION_CODE',
      defaultValue: '1',
    );
    env = Env.fromName(
      const String.fromEnvironment('APP_ENVIRONMENT_TYPE', defaultValue: 'dev'),
    );
  }
}
