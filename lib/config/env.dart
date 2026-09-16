sealed class Env {
  const Env();

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
