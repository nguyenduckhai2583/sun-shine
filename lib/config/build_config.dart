import 'env.dart';

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

  /// Salts for the client-side password digests. They arrive through
  /// `--dart-define-from-file`, so they are never literals in the source.
  late final String passwordSalt;
  late final String unlockedSalt;

  bool _isSetUp = false;

  /// Safe to call more than once: `main()` calls it, and so does any test
  /// harness that boots part of the tree. The fields are `late final`, so a
  /// second assignment would throw.
  void setupEnvironment() {
    if (_isSetUp) return;
    _isSetUp = true;

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
    passwordSalt = const String.fromEnvironment('PASSWORD_SALT');
    unlockedSalt = const String.fromEnvironment('UNLOCKED_SALT');
  }
}
