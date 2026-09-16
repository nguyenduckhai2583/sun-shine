/// Per-environment values that are *not* secrets and benefit from being
/// compile-time checked: base urls, database names, log levels…
///
/// These stay in Dart on purpose (see doc §3) — only values the native build
/// needs (app name, suffix, version) travel through `_env/<env>.env`.
sealed class Env {
  const Env();

  /// Maps `APP_ENVIRONMENT_TYPE` from `_env/<env>.env` onto a concrete [Env].
  factory Env.fromName(String name) => switch (name) {
    'dev' => const DevEnv(),
    'prod' => const ProdEnv(),
    _ => throw ArgumentError.value(name, 'name', 'Unknown environment'),
  };

  String get name;

  String get baseApiUrl;

  String get dbName;
}

class DevEnv extends Env {
  const DevEnv();

  @override
  String get name => 'dev';

  @override
  String get baseApiUrl => 'https://api.dev.sunshine.com';

  @override
  String get dbName => 'sun_shine_dev';
}

class ProdEnv extends Env {
  const ProdEnv();

  @override
  String get name => 'prod';

  @override
  String get baseApiUrl => 'https://api.sunshine.com';

  @override
  String get dbName => 'sun_shine';
}
