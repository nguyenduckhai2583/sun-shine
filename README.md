# sun_shine

## Getting started

```bash
fvm install            # Flutter 3.47.4, pinned in .fvmrc
fvm flutter pub get
fvm dart run build_runner build   # only after editing a freezed model
fvm flutter run --dart-define-from-file=_env/dev.env
```

Builds go through the wrapper, which picks the right `_env/<env>.env`:

```bash
./_buildScripts/app_build.sh -env dev -platform apk -mode debug
```

## Docs

- [docs/architecture.md](docs/architecture.md) — layers, state management,
  testing, and how this maps to the Flutter team's recommendations
- [docs/routing.md](docs/routing.md) — how `go_router` is wired up

## Checks

```bash
fvm flutter analyze
fvm flutter test
```
