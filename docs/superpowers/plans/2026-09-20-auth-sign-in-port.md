# Auth Sign In Port — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Port the Sign In screen of `employer-mobile` (GetX) into `sun-shine` (provider + MVVM), covering all three entry paths — password, passkey, QR — plus the session layer and routing they depend on.

**Architecture:** Layered per `docs/architecture.md`: retrofit API clients returning `Result<T>` → repositories mapping DTO to domain → use cases holding cross-repository logic → `ChangeNotifier` ViewModels exposing `Command<T>` → dumb views. Dependency injection is provider scopes nested along the widget tree. Navigation is decided by a `go_router` redirect watching the session stream, never by the data layer.

**Tech Stack:** Flutter 3.47.4 (FVM), Dart 3.13.3, `provider`, `go_router`, `retrofit`/`dio`, `freezed`, `json_serializable`, `isar_community`, `rxdart`, `material_ui`.

**Spec:** `docs/superpowers/specs/2026-09-20-auth-getx-to-provider-design.md`

**Reference source:** `/Users/sunshine/Documents/Project/employer-mobile` — read-only. Paths below written as `employer:lib/...` refer to it.

## Global Constraints

- Always use `fvm`: `fvm flutter analyze`, `fvm flutter test`, `fvm dart run build_runner build`.
  `--delete-conflicting-outputs` was **removed** in build_runner 2.16 and is now ignored with a warning — do not pass it.
- `flutter analyze` does not compile package sources. A dependency that is
  incompatible with this Flutter version can pass analysis and still fail the
  build, so verify with `fvm flutter test` or `fvm flutter build bundle`.
- **Import `package:material_ui/material_ui.dart`, never `package:flutter/material.dart`.** Non-widget code may import `package:flutter/foundation.dart`.
- Import project code through the barrel `package:sun_shine/core.dart`. Add every new public file to its layer barrel (`lib/data/data.dart`, `lib/domain/domain.dart`, `lib/ui/ui.dart`, `lib/utils/utils.dart`).
- Generated `*.freezed.dart` / `*.g.dart` are checked into the repo. Never hand-edit them.
- Async actions that can fail use `Command<T>` from `lib/utils/command.dart`, never a manual `isLoading` bool.
- Repositories are abstract + `<Name>RepositoryImpl`. ViewModels extend `BaseViewModel`. Local services extend `BaseLocalService`.
- `Result.error` takes an `Exception`. Never a bare `String`.
- Write `providers:` lists inline at the `MultiProvider` that mounts them. No `<feature>_providers.dart` files.
- Run `fvm flutter analyze` at the end of every task; it must report **No issues found!**
- Base URLs: dev `https://employer-api.dev.hodfords.uk/`, prod `https://api.hplix.com/`.
- API path prefix for auth: `/user-services/auth`. Profile: `/user-services/users/me`.

---

## File Structure

**New foundation**

| File | Responsibility |
|---|---|
| `lib/data/services/api/client/api_exception.dart` | `ApiException(message, statusCode)` + `ApiException.from(Object)` |
| `lib/data/services/api/client/result_call_adapter.dart` | Turns a retrofit call into `Result<T>` |
| `lib/data/services/api/client/dio_factory.dart` | Builds a configured `Dio` |
| `lib/utils/di.dart` (modify) | Adds `Di.observed<T>()` |

**Auth data layer**

| File | Responsibility |
|---|---|
| `lib/data/services/api/auth_api_client.dart` | `@RestApi` auth endpoints |
| `lib/data/services/api/model/auth_request.dart` | Sign-in request body |
| `lib/data/services/api/model/session_api_model.dart` (modify) | Wire shape of a session |
| `lib/data/services/api/model/user_api_model.dart` | Wire shape of a user |
| `lib/data/services/local/session_local_service.dart` | Isar multi-account session store |
| `lib/data/repositories/auth/auth_manager.dart` | Sign-in–scoped `Dio` + pending session |
| `lib/data/repositories/auth/auth_repository.dart` (modify) | Abstract auth contract |
| `lib/data/repositories/auth/auth_repository_impl.dart` (modify) | Maps DTO → domain |
| `lib/data/repositories/auth/session_repository.dart` | Abstract session contract |
| `lib/data/repositories/auth/session_repository_impl.dart` | Multi-account session state |

**Auth domain layer**

| File | Responsibility |
|---|---|
| `lib/domain/models/session.dart` (modify) | Domain session |
| `lib/domain/models/user.dart` | Domain user |
| `lib/domain/use_cases/auth/sign_in_use_case.dart` | Password sign-in + hashing |
| `lib/domain/use_cases/auth/sign_in_flow_use_case.dart` | Non-HTTP flow verbs |
| `lib/domain/use_cases/auth/finalize_session_use_case.dart` | Hand pending session to the session layer |
| `lib/domain/use_cases/auth/sign_in_passkey_use_case.dart` | Passkey sign-in |
| `lib/domain/use_cases/auth/sign_in_qr_use_case.dart` | QR sign-in |

**Auth UI layer**

| File | Responsibility |
|---|---|
| `lib/ui/auth/view_models/sign_in_viewmodel.dart` (modify) | Three sign-in commands + validation |
| `lib/ui/auth/widgets/sign_in_screen.dart` (modify) | The screen |
| `lib/ui/auth/widgets/auth_card.dart` | Card container |
| `lib/ui/auth/widgets/glass_icon.dart` | Frosted app icon |
| `lib/main.dart` (modify) | Auth scope registrations, written inline |

**Shared UI**

`lib/ui/core/ui/text_field_input.dart`, `widget_with_label.dart`, `processing_dialog.dart`, `grid_tile_background.dart`

---

## Phase A — Foundation

### Task 1: HTTP foundation (dio + retrofit + Result)

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/data/services/api/client/api_exception.dart`
- Create: `lib/data/services/api/client/result_call_adapter.dart`
- Create: `lib/data/services/api/client/dio_factory.dart`
- Modify: `lib/utils/di.dart`
- Modify: `lib/data/data.dart`
- Test: `test/data/api_exception_test.dart`, `test/data/result_call_adapter_test.dart`

**Interfaces:**
- Consumes: `Result`/`Ok`/`Error` from `lib/utils/result.dart`; `Di.observer` from `lib/utils/di.dart`.
- Produces:
  - `enum ApiErrorEnum { noInternet, timeout, cancelled, badCertificate, badFormat, server, unknown }`
  - `class ApiException implements Exception { final ApiErrorEnum error; final String? serverMessage; final int? statusCode; static ApiException from(Object error); }`
  - `class ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>>`
  - `Dio DioFactory.create({required String baseUrl})`
  - `static T Di.observed<T extends Object>(T instance)`

- [x] **Step 1: Add dependencies**

```bash
cd /Users/sunshine/Documents/Project/sun-shine
fvm flutter pub add dio retrofit
fvm flutter pub add dev:retrofit_generator
```

Expected: resolves `dio 5.11.1`, `retrofit 4.10.0`, `retrofit_generator 10.2.11`.

- [x] **Step 2: Write the failing test for `ApiException.from`**

Create `test/data/api_exception_test.dart`:

```dart
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ApiException.from', () {
    DioException badResponse({Object? data, int statusCode = 400}) {
      return DioException(
        requestOptions: RequestOptions(path: '/x'),
        response: Response(
          requestOptions: RequestOptions(path: '/x'),
          statusCode: statusCode,
          data: data,
        ),
        type: DioExceptionType.badResponse,
      );
    }

    test('keeps the server error body verbatim', () {
      final mapped = ApiException.from(
        badResponse(data: {'error': 'Email already taken'}),
      );

      expect(mapped.error, ApiErrorEnum.server);
      expect(mapped.serverMessage, 'Email already taken');
      expect(mapped.statusCode, 400);
    });

    test('a server error without a body carries no message to show', () {
      final mapped = ApiException.from(badResponse(data: null));

      expect(mapped.error, ApiErrorEnum.server);
      expect(mapped.serverMessage, isNull);
    });

    test('maps a connection timeout to the timeout kind and 408', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.connectionTimeout,
      );

      final mapped = ApiException.from(error);

      expect(mapped.error, ApiErrorEnum.timeout);
      expect(mapped.statusCode, 408);
    });

    test('maps a socket failure to the no-internet kind', () {
      final mapped = ApiException.from(const SocketException('no route'));

      expect(mapped.error, ApiErrorEnum.noInternet);
      expect(mapped.statusCode, 408);
    });

    test('maps a cancellation to the cancelled kind', () {
      final error = DioException(
        requestOptions: RequestOptions(path: '/x'),
        type: DioExceptionType.cancel,
      );

      expect(ApiException.from(error).error, ApiErrorEnum.cancelled);
    });

    test('falls back for an unknown error', () {
      final mapped = ApiException.from(Exception('boom'));

      expect(mapped.error, ApiErrorEnum.unknown);
      expect(mapped.statusCode, isNull);
    });

    test('carries no user-facing English of its own', () {
      // The data layer must not choose wording — only an ApiErrorEnum and, when
      // the server supplied one, its verbatim text. A regression here would
      // reintroduce strings that ignore the user's locale.
      final mapped = ApiException.from(
        DioException(
          requestOptions: RequestOptions(path: '/x'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(mapped.serverMessage, isNull);
    });
  });
}
```

- [x] **Step 3: Run it and watch it fail**

Run: `fvm flutter test test/data/api_exception_test.dart`
Expected: FAIL — `Undefined name 'ApiException'`.

- [x] **Step 4: Implement `ApiException`**

Create `lib/data/services/api/client/api_exception.dart`.

**No user-facing strings live here.** The data layer has no `BuildContext`, so
any English it picked would freeze into whichever locale was active when the
request failed — switching language later would not change it. It carries a
language-independent `ApiErrorEnum`; the view turns that into words (Task 2,
Step 6).

Employer has this bug: `ErrorMessageDelegate` is settable, but
`DioHelper.errorText` is only ever assigned `ErrorMessageDelegateDefault()`, so
its transport errors are permanently English.

```dart
import 'dart:io';

import 'package:dio/dio.dart';

/// What went wrong, independent of any language.
///
/// The data layer has no `BuildContext`, so it must not decide wording: a
/// string chosen here would freeze into whatever locale was active when the
/// request failed. The view maps this to a localized message instead.
enum ApiErrorEnum {
  /// The request never reached the network.
  noInternet,

  /// The connection or the response ran out of time.
  timeout,

  /// The caller cancelled the request.
  cancelled,

  /// The certificate did not match what was configured.
  badCertificate,

  /// The response arrived but could not be parsed.
  badFormat,

  /// The server answered with an error — see [ApiException.serverMessage].
  server,

  unknown,
}

/// The single error type the data layer puts inside [Result.error].
///
/// [statusCode] is null when the failure never reached the server, or when it
/// carries a sentinel outside the HTTP range — callers branch on a real status
/// or on nothing at all.
class ApiException implements Exception {
  const ApiException({
    required this.error,
    this.serverMessage,
    this.statusCode,
  });

  final ApiErrorEnum error;

  /// The server's own text, from `{"error": "..."}`.
  ///
  /// Null unless [error] is [ApiErrorEnum.server]. This is the one message the
  /// app does not translate: it is the backend's wording, and only the backend
  /// knows what a given rejection means.
  final String? serverMessage;

  final int? statusCode;

  static const _timeout = 408;

  static ApiException from(Object error) {
    if (error is DioException) return _fromDio(error);
    if (error is SocketException) {
      return const ApiException(
        error: ApiErrorEnum.noInternet,
        statusCode: _timeout,
      );
    }
    if (error is FormatException) {
      return const ApiException(error: ApiErrorEnum.badFormat);
    }
    return const ApiException(error: ApiErrorEnum.unknown);
  }

  static ApiException _fromDio(DioException error) {
    final status = error.response?.statusCode;
    return switch (error.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.sendTimeout ||
      DioExceptionType.receiveTimeout => ApiException(
        error: ApiErrorEnum.timeout,
        statusCode: status ?? _timeout,
      ),
      DioExceptionType.connectionError => ApiException(
        error: ApiErrorEnum.noInternet,
        statusCode: status ?? _timeout,
      ),
      DioExceptionType.cancel => ApiException(
        error: ApiErrorEnum.cancelled,
        statusCode: status,
      ),
      DioExceptionType.badCertificate => ApiException(
        error: ApiErrorEnum.badCertificate,
        statusCode: status,
      ),
      DioExceptionType.badResponse => ApiException(
        error: ApiErrorEnum.server,
        serverMessage: _serverMessage(error),
        statusCode: status,
      ),
      _ =>
        error.error is SocketException
            ? ApiException(
                error: ApiErrorEnum.noInternet,
                statusCode: status ?? _timeout,
              )
            : ApiException(
                error: ApiErrorEnum.server,
                serverMessage: _serverMessage(error),
                statusCode: status,
              ),
    };
  }

  /// The API reports failures as `{"error": "..."}`.
  static String? _serverMessage(DioException error) {
    final data = error.response?.data;
    if (data is Map && data['error'] != null) return data['error'].toString();
    return null;
  }

  /// Developer-facing only — never shown to a user, so English is fine here.
  @override
  String toString() =>
      'ApiException(${error.name}, $statusCode, ${serverMessage ?? '-'})';
}
```

- [x] **Step 5: Export it and re-run**

Add to `lib/data/data.dart`:

```dart
export 'services/api/client/api_exception.dart';
```

Run: `fvm flutter test test/data/api_exception_test.dart`
Expected: PASS (4 tests).

- [x] **Step 6: Write the failing test for `ResultCallAdapter`**

Create `test/data/result_call_adapter_test.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('ResultCallAdapter', () {
    test('wraps a value in Ok', () async {
      final adapter = ResultCallAdapter<int>();

      final result = await adapter.adapt(() async => 42);

      expect(result, isA<Ok<int>>());
      expect((result as Ok<int>).value, 42);
    });

    test('turns a thrown DioException into Error<ApiException>', () async {
      final adapter = ResultCallAdapter<int>();

      final result = await adapter.adapt(
        () async => throw DioException(
          requestOptions: RequestOptions(path: '/x'),
          response: Response(
            requestOptions: RequestOptions(path: '/x'),
            statusCode: 401,
            data: {'error': 'Unauthorized'},
          ),
          type: DioExceptionType.badResponse,
        ),
      );

      expect(result, isA<Error<int>>());
      final error = (result as Error<int>).error as ApiException;
      expect(error.error, ApiErrorEnum.server);
      expect(error.statusCode, 401);
      expect(error.serverMessage, 'Unauthorized');
    });

    test('never rethrows', () async {
      final adapter = ResultCallAdapter<int>();

      await expectLater(
        adapter.adapt(() async => throw Exception('boom')),
        completes,
      );
    });
  });
}
```

- [x] **Step 7: Run it and watch it fail**

Run: `fvm flutter test test/data/result_call_adapter_test.dart`
Expected: FAIL — `Undefined name 'ResultCallAdapter'`.

- [x] **Step 8: Implement the adapter**

Create `lib/data/services/api/client/result_call_adapter.dart`:

```dart
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

/// Adapts a retrofit call into the app's [Result], so generated API clients
/// return `Result<T>` instead of throwing.
///
/// Named in `@RestApi(callAdapter: ResultCallAdapter)`; retrofit instantiates
/// it per method, so it must have a zero-argument constructor.
class ResultCallAdapter<T> extends CallAdapter<Future<T>, Future<Result<T>>> {
  @override
  Future<Result<T>> adapt(Future<T> Function() call) async {
    try {
      return Result.ok(await call());
    } catch (error) {
      return Result.error(ApiException.from(error));
    }
  }
}
```

- [x] **Step 9: Export and re-run**

Add to `lib/data/data.dart`:

```dart
export 'services/api/client/result_call_adapter.dart';
```

Run: `fvm flutter test test/data/result_call_adapter_test.dart`
Expected: PASS (3 tests).

- [x] **Step 10: Add `Di.observed`**

In `lib/utils/di.dart`, inside `abstract final class Di`, below the `observer` field:

```dart
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
```

- [x] **Step 11: Test `Di.observed`**

Append to `test/utils/di_log_test.dart` inside the existing top-level `main()`:

```dart
  test('Di.observed reports creation and returns the instance', () {
    final recorded = <Object>[];
    Di.observer = _RecordingObserver(recorded.add);
    addTearDown(() => Di.observer = const DiObserver.silent());

    final value = Di.observed(StringBuffer('x'));

    expect(recorded, hasLength(1));
    expect(identical(recorded.single, value), isTrue);
  });
}

class _RecordingObserver extends DiObserver {
  const _RecordingObserver(this.onCreated);

  final void Function(Object) onCreated;

  @override
  void onCreate(Object instance) => onCreated(instance);
```

Note: the snippet closes `main()` then opens the helper class — place the
closing brace correctly rather than pasting blindly.

Run: `fvm flutter test test/utils/di_log_test.dart`
Expected: PASS.

- [x] **Step 12: Implement `DioFactory`**

Create `lib/data/services/api/client/dio_factory.dart`:

```dart
import 'package:dio/dio.dart';

/// Builds the `Dio` instances the app talks to the API through.
///
/// Each call returns a brand new instance. The sign-in flow depends on that:
/// its Dio must never share headers with the active account's.
abstract final class DioFactory {
  static Dio create({required String baseUrl}) {
    return Dio(
      BaseOptions(
        baseUrl: baseUrl,
        contentType: Headers.jsonContentType,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 20),
      ),
    );
  }
}
```

Add to `lib/data/data.dart`:

```dart
export 'services/api/client/dio_factory.dart';
```

- [x] **Step 13: Verify the whole suite**

```bash
fvm flutter analyze
fvm flutter test
```

Expected: **No issues found!** and all tests pass (116 existing + 8 new).

---

### Task 2: Localization (gen-l10n)

**Note:** English only. Employer's `intl_vi.arb` holds 124 of 1863 keys and none of the auth ones, so there is no Vietnamese auth copy to port. Add `app_vi.arb` when translations exist.

**Files:**
- Modify: `pubspec.yaml`
- Create: `l10n.yaml`
- Create: `lib/l10n/app_en.arb`
- Generated: `lib/l10n/app_localizations.dart`, `lib/l10n/app_localizations_en.dart` (checked in)
- Modify: `lib/main.dart`, `lib/core.dart`, `lib/ui/core/core.dart`
- Create: `lib/ui/core/ui/api_error_text.dart`
- Test: `test/ui/core/api_error_text_test.dart`

**Interfaces:**
- Produces: `AppLocalizations.of(context)` with the keys listed below, generated into `lib/l10n/` and exported from `lib/core.dart`. `nullable-getter: false` makes `of(context)` non-null.
  - `extension ApiErrorText on ApiException` with `String localizedMessage(AppLocalizations l10n)`

- [x] **Step 1: Add the localization dependencies**

```bash
fvm flutter pub add flutter_localizations --sdk=flutter
fvm flutter pub add intl:any
```

Then in `pubspec.yaml` under the existing `flutter:` section, alongside `uses-material-design: true`:

```yaml
  generate: true
```

- [x] **Step 2: Create `l10n.yaml` at the repo root**

```yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart
output-class: AppLocalizations
nullable-getter: false
```

- [x] **Step 3: Create `lib/l10n/app_en.arb`**

Values copied verbatim from `employer:lib/l10n/intl_en.arb`.

```json
{
  "@@locale": "en",

  "signIn": "Sign in",
  "signInSubtitle": "Start a new conversation with the team",
  "addNewAccount": "Add new account",
  "email": "Email",
  "emailInputHint": "Your email address here",
  "password": "Password",
  "passwordInputHint": "Enter the password",
  "incorrectEmailOrPassword": "Your email address and/or password are incorrect.",
  "continueWithPasskey": "Continue with Passkey",
  "scanQrCodeAction": "Scan QR code",
  "processing": "Processing",
  "cancel": "Cancel",

  "somethingWentWrong": "Something went wrong",
  "noInternetConnection": "No internet connection",
  "requestTimeOut": "Request timed out. Please check your connection.",
  "requestCancelled": "The request was cancelled",
  "badResponseFormat": "Bad response format",
  "incorrectCertificate": "Incorrect certificate as configured"
}
```

- [x] **Step 4: Wire it into `MaterialApp.router`**

gen-l10n writes into `lib/l10n/` (the `arb-dir`, since `output-dir` is unset).
There is **no** `package:flutter_gen/...` import on this Flutter version — the
synthetic package was removed, and `--synthetic-package` now reports
"DEPRECATED. This flag cannot be enabled."

Export the generated class from the barrel instead, so widgets reach it the
same way they reach everything else. In `lib/core.dart`:

```dart
export 'l10n/app_localizations.dart';
```

Then inside `MaterialApp.router(...)` in `lib/main.dart`:

```dart
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
```

- [x] **Step 5: Generate and verify it compiles**

```bash
fvm flutter pub get
fvm flutter analyze
```

Expected: **No issues found!** (`flutter pub get` runs gen-l10n when `generate: true`).

- [x] **Step 6: Map `ApiErrorEnum` to localized text**

This is the view-side half of Task 1: the data layer reports an `ApiErrorEnum`,
and this turns it into words in the user's language.

Create `lib/ui/core/ui/api_error_text.dart`:

```dart
import 'package:sun_shine/core.dart';

extension ApiErrorText on ApiException {
  /// The message to show a user, in their language.
  ///
  /// A server rejection keeps the backend's own wording — only the backend
  /// knows what a given rejection means. Everything else is translated here.
  String localizedMessage(AppLocalizations l10n) => switch (error) {
    ApiErrorEnum.noInternet => l10n.noInternetConnection,
    ApiErrorEnum.timeout => l10n.requestTimeOut,
    ApiErrorEnum.cancelled => l10n.requestCancelled,
    ApiErrorEnum.badCertificate => l10n.incorrectCertificate,
    ApiErrorEnum.badFormat => l10n.badResponseFormat,
    ApiErrorEnum.server => serverMessage ?? l10n.somethingWentWrong,
    ApiErrorEnum.unknown => l10n.somethingWentWrong,
  };
}
```

Export it from `lib/ui/core/core.dart`:

```dart
export 'ui/api_error_text.dart';
```

The `switch` is exhaustive over the enum, so adding a value later fails to
compile until it has a translation — which is the point.

- [x] **Step 7: Verify**

```bash
fvm flutter analyze
```

---

### Task 3: Shared UI foundation

**Files:**
- Modify: `pubspec.yaml` (assets, `flutter_svg`)
- Create: `assets/icons/ic_app_icon.svg`, `assets/images/img_app_text_logo.svg`, `lib/ui/core/app_asset.dart`
- Create: `lib/ui/core/ui/text_field_input.dart`
- Create: `lib/ui/core/ui/widget_with_label.dart`
- Create: `lib/ui/core/ui/grid_tile_background.dart`
- Modify: `lib/ui/core/core.dart`

**Interfaces:**
- Produces:
  - `TextFieldInput({TextEditingController? inputController, String? hintText, bool obscureText, FocusNode? focusNode, TextInputType? keyboardType, int? maxLength, TextInputAction? textInputAction, void Function(String?)? onFieldSubmitted, List<TextInputFormatter>? inputFormatters})`
  - `WidgetWithLabel({required String label, required Widget child})`
  - `GridTileBackground({required Widget child})`

- [x] **Step 1: Add packages and assets**

```bash
fvm flutter pub add flutter_svg
```

**Do not add `phosphor_flutter`.** Version 2.1.0 is the latest published and it
does not compile on Flutter 3.47.4: `IconData` is now a `final class`, so its
`class PhosphorIconData extends IconData` is illegal. There is no fixed
release. Use Material icons instead — `Icons.visibility_outlined` /
`Icons.visibility_off_outlined` for the password toggle, `Icons.key` for
passkey, `Icons.qr_code_scanner` for QR.

Note that `flutter analyze` reports **no errors** for this — only the compiler
catches it, so verify with `fvm flutter test` or a build, not analysis alone.

In `pubspec.yaml`, under `flutter:`, replace the commented-out assets block with:

```yaml
  assets:
    - assets/icons/
    - assets/images/
```

- [x] **Step 2: Copy the two SVGs**

Employer keeps them in two directories, mirrored here:

```bash
EMP=/Users/sunshine/Documents/Project/employer-mobile
mkdir -p assets/icons assets/images
cp "$EMP/assets/icons/ic_app_icon.svg" assets/icons/
cp "$EMP/assets/images/img_app_text_logo.svg" assets/images/
ls -la assets/icons assets/images
```

Then create `lib/ui/core/app_asset.dart`:

```dart
abstract final class AppAsset {
  static const String icAppIcon = 'assets/icons/ic_app_icon.svg';
  static const String imgAppTextLogo = 'assets/images/img_app_text_logo.svg';
}
```

and export it from `lib/ui/core/core.dart`:

```dart
export 'app_asset.dart';
```

- [x] **Step 3: Port the four shared widgets**

Port each from employer, changing **only** the import line from
`package:flutter/material.dart` to `package:material_ui/material_ui.dart`,
replacing `S.of(context).x` with `AppLocalizations.of(context).x`, and
replacing `context.colorScheme` with `Theme.of(context).colorScheme`:

| Create | Port from |
|---|---|
| `lib/ui/core/ui/text_field_input.dart` | `employer:lib/app/core/widgets/inputs/text_field_input.dart` |
| `lib/ui/core/ui/widget_with_label.dart` | `employer:lib/app/modules/channels/widgets/widget_with_label.dart` |
| `lib/ui/core/ui/grid_tile_background.dart` | `employer:lib/app/core/widgets/background/grid_tile_background.dart` |
| `lib/ui/core/ui/gradient_border.dart` | `employer:lib/app/core/widgets/background/gradient_border.dart` |

**`TextFieldInput` is a focused port, not a transcription.** Employer's carries
60-odd parameters — multiline, debounced onChanged, emoji filtering, validators,
12 border options — and depends on `Debouncer`, `DisableAccessibility`,
`emojiUnicodePattern` and `NoLeadingSpaceFormatter`, none of which exist here.
Port only the parameters in the Interfaces block above, plus the obscure-text
toggle, the clear button, and `counterText: ''` (without which `maxLength`
prints a "0/50" counter). Add the rest back when a screen needs it.

**`ProcessingDialog` is not ported.** Task 7 replaces
`ProcessingDialog.show()`/`hide()` with `Command.running`, and Task 14's QR flow
has its own dialog, so nothing in this plan would call it. Porting it now would
be dead code.

`GridTileBackground` needs `GradientBorder`, so that comes too. It also reads
`context.isTablet` from a GetX extension — express the same 600px threshold
against `LayoutBuilder` constraints instead.

Drop any `Get`, `Obx`, or `GetView` reference. If a widget pulls in a helper
that does not exist here (`Space`, `LimitedScaleFactor`), inline the plain
equivalent — `Space.vertical(value: 24)` becomes `const SizedBox(height: 24)`.

- [x] **Step 4: Export them**

Add to `lib/ui/core/core.dart`:

```dart
export 'app_asset.dart';
export 'ui/gradient_border.dart';
export 'ui/grid_tile_background.dart';
export 'ui/text_field_input.dart';
export 'ui/widget_with_label.dart';
```

- [x] **Step 5: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

---

## Phase B — Password sign-in

Tasks 4 → 5 → 5b → 6 → 7.

### Task 4: Domain and API models

**Files:**
- Modify: `lib/domain/models/session.dart`
- Create: `lib/domain/models/user.dart`
- Modify: `lib/data/services/api/model/session_api_model.dart`
- Create: `lib/data/services/api/model/user_api_model.dart`
- Create: `lib/data/services/api/model/auth_request.dart`
- Modify: `lib/domain/domain.dart`, `lib/data/data.dart`
- Test: `test/domain/session_test.dart`

**Interfaces:**
- Produces:
  - `Session({required String userId, required String token, String? refreshToken, int? expireAt, bool isTmpToken, String? workspaceId, User? user, String? md5Password, String? encryptedPrivateKey, String? localEncryptedPrivateKey})`
    The last three mirror employer's `SessionModel`: `md5Password` is derived at sign-in and, with the passcode, unlocks the E2E private key; the two key fields are read by `sign_in_passkey_use_case`, `register_passkey_use_case` and `verify_passcode_use_case`.
  - `User({required String id, required String email, String? fullName, String? avatar})`
  - `SessionApiModel` with `fromJson`/`toJson`, fields `token`, `refreshToken`, `expireAt`, `isTmpToken`, `user`
  - `UserApiModel` with `fromJson`/`toJson`, fields `id`, `email`, `fullName`, `avatar`
  - `AuthRequest({required String email, required String sha1Password})` with `toJson()` emitting `{'email': ..., 'password': ...}`

Employer's `SessionModel` (`employer:lib/app/modules/auth/models/session_model.dart`) mixes wire fields, Isar fields, and locally derived secrets in one class. The split here: `SessionApiModel` carries only what the server sends; `Session` carries what the UI and use cases read.

- [x] **Step 1: Write the failing domain test**

Create `test/domain/session_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('Session', () {
    const user = User(id: 'u1', email: 'khai@sunshine.com');

    test('is not authenticated while the token is temporary', () {
      const session = Session(
        userId: 'u1',
        token: 't',
        isTmpToken: true,
        user: user,
      );

      expect(session.isFullyAuthenticated, isFalse);
    });

    test('is authenticated with a real token', () {
      const session = Session(userId: 'u1', token: 't', user: user);

      expect(session.isFullyAuthenticated, isTrue);
    });

    test('needs a workspace until one is assigned', () {
      const session = Session(userId: 'u1', token: 't', user: user);

      expect(session.needsWorkspace, isTrue);
      expect(session.copyWith(workspaceId: 'w1').needsWorkspace, isFalse);
    });
  });
}
```

- [x] **Step 2: Run it and watch it fail**

Run: `fvm flutter test test/domain/session_test.dart`
Expected: FAIL — `User` undefined, `isFullyAuthenticated` undefined.

- [x] **Step 3: Write the domain models**

Replace `lib/domain/models/session.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user.dart';

part 'session.freezed.dart';

@freezed
abstract class Session with _$Session {
  const factory Session({
    required String userId,
    required String token,
    String? refreshToken,
    int? expireAt,
    @Default(false) bool isTmpToken,
    String? workspaceId,
    User? user,
  }) = _Session;

  const Session._();

  /// A temporary token still needs a second factor (auth code or passcode).
  bool get isFullyAuthenticated => !isTmpToken;

  bool get needsWorkspace => workspaceId == null;
}
```

Create `lib/domain/models/user.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';

@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? fullName,
    String? avatar,
  }) = _User;
}
```

- [x] **Step 4: Write the API models**

Replace `lib/data/services/api/model/session_api_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_api_model.dart';

part 'session_api_model.freezed.dart';
part 'session_api_model.g.dart';

@freezed
abstract class SessionApiModel with _$SessionApiModel {
  const factory SessionApiModel({
    required String token,
    String? refreshToken,
    int? expireAt,
    bool? isTmpToken,
    UserApiModel? user,
  }) = _SessionApiModel;

  factory SessionApiModel.fromJson(Map<String, dynamic> json) =>
      _$SessionApiModelFromJson(json);
}
```

Create `lib/data/services/api/model/user_api_model.dart`:

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_api_model.freezed.dart';
part 'user_api_model.g.dart';

@freezed
abstract class UserApiModel with _$UserApiModel {
  const factory UserApiModel({
    required String id,
    required String email,
    String? fullName,
    String? avatar,
  }) = _UserApiModel;

  factory UserApiModel.fromJson(Map<String, dynamic> json) =>
      _$UserApiModelFromJson(json);
}
```

Create `lib/data/services/api/model/auth_request.dart`:

```dart
/// The sign-in request body.
///
/// The password is SHA1-salted on the client before it leaves, and the server
/// expects that digest under the key `password`.
class AuthRequest {
  const AuthRequest({required this.email, required this.sha1Password});

  final String email;
  final String sha1Password;

  Map<String, dynamic> toJson() => {
    'email': email,
    'password': sha1Password,
  };
}
```

- [x] **Step 5: Generate the code**

```bash
fvm dart run build_runner build
```

Expected: writes `session.freezed.dart`, `user.freezed.dart`, `session_api_model.{freezed,g}.dart`, `user_api_model.{freezed,g}.dart`.

- [x] **Step 6: Export and run**

Add to `lib/domain/domain.dart`:

```dart
export 'models/user.dart';
```

Add to `lib/data/data.dart`:

```dart
export 'services/api/model/auth_request.dart';
export 'services/api/model/user_api_model.dart';
```

Run: `fvm flutter test test/domain/session_test.dart`
Expected: PASS (3 tests).

- [x] **Step 7: Fix the fallout**

`Session` changed shape, so three call sites break. `email` moved off `Session`
onto its nested `User`:

- `lib/data/services/api/auth_api_client.dart` — the fake still builds a
  `SessionApiModel(userId:, email:, accessToken:)`. Give it
  `token:` plus a nested `UserApiModel`. It stays a fake until Task 5.
- `lib/data/repositories/auth/auth_repository_impl.dart` — `_toDomain` maps the
  new fields and nests the user.
- `test/data/auth_repository_impl_test.dart` — `currentSession?.email` becomes
  `currentSession?.user?.email`, in two places.

```bash
fvm flutter analyze
fvm flutter test
```

---

### Task 5: The sign-in vertical slice (merged with the old Task 6)

**Why merged.** Tasks 5 and 6 could not be separated. Swapping the fake
`AuthApiClient` for the retrofit one breaks `test/testing/pump_app.dart`, which
**10 test files** use to boot the app — they would attempt real HTTPS calls.
Fixing that needs `FakeAuthApiClient` (old Task 6, Step 6), and sending a
*correct* request needs `EncryptUtil` (old Task 6, Steps 1-5). Splitting them
would have meant either a red tree between tasks or a plaintext password parked
in the `sha1Password` field behind a TODO.

Removing session state from `AuthRepository` then cascaded into `AuthScope`,
`router.dart`, `home_drawer.dart` and `pump_app`, so a minimal
`SessionRepository` (old Task 9) landed here too — in-memory, with Task 8
swapping Isar in behind the same interface.

**Delivered:** retrofit `AuthApiClient`, `AuthManager`, `EncryptUtil`,
`AuthRepository`/`Impl`, `SignInUseCase`, `SignInFlowUseCase`,
`FinalizeSessionUseCase`, `SessionRepository`/`Impl`, `FakeAuthApiClient`,
rewired `SignInViewModel`.

#### Original Task 5: AuthApiClient and AuthManager

**Files:**
- Modify: `lib/config/env.dart`, `lib/config/build_config.dart`
- Modify: `_env/dev.env`, `_env/prod.env`
- Create: `lib/data/services/api/auth_api_client.dart`
- Create: `lib/data/repositories/auth/auth_manager.dart`
- Modify: `lib/data/data.dart`
- Test: `test/data/auth_manager_test.dart`

**Interfaces:**
- Consumes: `DioFactory.create`, `ResultCallAdapter`, `SessionApiModel`, `UserApiModel`, `AuthRequest`, `Session`.
- Produces:
  - `AuthApiClient(Dio dio, {String? baseUrl})` with `signIn`, `getMyProfile`, `signOut`
  - `AuthManager({required String baseUrl})` exposing `Dio dio`, `AuthApiClient authApiClient`, `Session? pending`, `bool isAddingAccount`, `void setPending(Session)`, `void beginAddAccount()`, `void clearPending()`, `void reset()`

- [x] **Step 1: Add the real base URLs and salts to `Env`**

In `lib/config/env.dart`, change `DevEnv.baseApiUrl` to
`'https://employer-api.dev.hodfords.uk/'` and `ProdEnv.baseApiUrl` to
`'https://api.hplix.com/'`.

In `lib/config/build_config.dart`, add two fields beside `appName`:

```dart
  late final String passwordSalt;
  late final String unlockedSalt;
```

and inside `setupEnvironment()`:

```dart
    passwordSalt = const String.fromEnvironment('PASSWORD_SALT');
    unlockedSalt = const String.fromEnvironment('UNLOCKED_SALT');
```

Append to both `_env/dev.env` and `_env/prod.env`, copying the values from the
matching file in `employer-mobile/_env/`:

```
PASSWORD_SALT="<copy from employer _env>"
UNLOCKED_SALT="<copy from employer _env>"
```

- [x] **Step 2: Write the `AuthApiClient`**

Create `lib/data/services/api/auth_api_client.dart`, replacing the fake one:

```dart
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sun_shine/core.dart';

part 'auth_api_client.g.dart';

/// `baseUrl` here is only the path prefix — the host comes from
/// `Dio.options.baseUrl`, so the environment stays a runtime value.
@RestApi(baseUrl: '/user-services', callAdapter: ResultCallAdapter)
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  @POST('/auth/sign-in')
  Future<Result<SessionApiModel>> signIn(@Body() AuthRequest request);

  @GET('/users/me')
  Future<Result<UserApiModel>> getMyProfile();

  @DELETE('/auth/sign-out')
  Future<Result<void>> signOut();
}
```

Employer's `signOut({String? token})` also accepts a **cross-account** token via
`tokenOptions(token)`, which overrides `Authorization` and sets a
`crossAccountKey` extra so the refresh interceptor does not retry the call as
the active account. That variant is deferred: screen 1 signs a user *in*, and
signing out a non-active account only becomes reachable once the account
switcher exists. When it does, add:

```dart
  @DELETE('/auth/sign-out')
  @Extra({'crossAccount': true})
  Future<Result<void>> signOutAs(@Header('Authorization') String authorization);
```

and teach the refresh interceptor to skip requests carrying that extra.

- [x] **Step 3: Generate and check it compiles**

```bash
fvm dart run build_runner build
fvm flutter analyze
```

The old fake `AuthApiClient()` had a zero-argument constructor; `analyze` will
now flag `lib/main.dart`, `test/testing/pump_app.dart`, and
`test/data/auth_repository_impl_test.dart`.
Leave those failing until Task 6 — or stub them with
`AuthApiClient(DioFactory.create(baseUrl: ''))` to keep analyze green.

- [x] **Step 4: Write the failing `AuthManager` test**

Create `test/data/auth_manager_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('AuthManager', () {
    late AuthManager manager;

    const session = Session(
      userId: 'u1',
      token: 'tok',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );

    setUp(() {
      manager = AuthManager(baseUrl: 'https://example.test/');
    });

    test('starts with nothing pending and not adding an account', () {
      expect(manager.pending, isNull);
      expect(manager.isAddingAccount, isFalse);
    });

    test('setPending stores the session and sets the auth header', () {
      manager.setPending(session);

      expect(manager.pending, session);
      expect(
        manager.dio.options.headers['Authorization'],
        'Bearer tok',
      );
    });

    test('clearPending drops the session but keeps the flow open', () {
      manager
        ..beginAddAccount()
        ..setPending(session)
        ..clearPending();

      expect(manager.pending, isNull);
      expect(manager.dio.options.headers['Authorization'], isNull);
      expect(manager.isAddingAccount, isTrue);
    });

    test('reset ends the flow', () {
      manager
        ..beginAddAccount()
        ..setPending(session)
        ..reset();

      expect(manager.pending, isNull);
      expect(manager.isAddingAccount, isFalse);
    });

    test('its Dio is not the app-wide one', () {
      final other = AuthManager(baseUrl: 'https://example.test/');

      expect(identical(manager.dio, other.dio), isFalse);
    });
  });
}
```

- [x] **Step 5: Run it and watch it fail**

Run: `fvm flutter test test/data/auth_manager_test.dart`
Expected: FAIL — `Undefined name 'AuthManager'`.

- [x] **Step 6: Implement `AuthManager`**

Create `lib/data/repositories/auth/auth_manager.dart`:

```dart
import 'package:dio/dio.dart';
import 'package:sun_shine/core.dart';

/// Owns the sign-in flow: its own [Dio], its own API client, and the session
/// being signed in.
///
/// The Dio is built fresh rather than cloned from the active account's, so no
/// header of theirs can leak into the sign-in flow. The pending session is
/// handed to the session layer only at finalize.
class AuthManager {
  AuthManager({required String baseUrl})
    : dio = DioFactory.create(baseUrl: baseUrl) {
    authApiClient = AuthApiClient(dio);
  }

  final Dio dio;

  late final AuthApiClient authApiClient;

  Session? _pending;
  bool _isAddingAccount = false;

  Session? get pending => _pending;

  bool get isAddingAccount => _isAddingAccount;

  void setPending(Session session) {
    _pending = session;
    dio.options.headers['Authorization'] = 'Bearer ${session.token}';
  }

  void beginAddAccount() => _isAddingAccount = true;

  /// Drops the session being signed in but keeps the flow open: a failed
  /// attempt leaves the user on the sign-in screen, still adding an account.
  void clearPending() {
    _pending = null;
    dio.options.headers.remove('Authorization');
  }

  /// Ends the flow — on finalize, or when the user backs out.
  void reset() {
    clearPending();
    _isAddingAccount = false;
  }
}
```

- [x] **Step 7: Export and verify**

Add to `lib/data/data.dart`:

```dart
export 'repositories/auth/auth_manager.dart';
```

```bash
fvm flutter test test/data/auth_manager_test.dart
fvm flutter analyze
```

---

### Task 5b: Dio interceptors

**Files:**
- Modify: `lib/data/services/api/client/dio_factory.dart`
- Create: `lib/data/services/api/client/auth_interceptor.dart`
- Create: `lib/data/services/api/client/refresh_token_interceptor.dart`
- Test: `test/data/refresh_token_interceptor_test.dart`

**Interfaces:**
- Consumes: `SessionRepository` is **not** available yet (Task 9), so the token
  is read through a callback the caller supplies.
- Produces:
  - `AuthInterceptor({required String? Function() readToken, required String? Function() readWorkspaceId})`
  - `RefreshTokenInterceptor({required Dio dio, required Future<String?> Function() refresh, required void Function() onRefreshFailed})`, with `static const crossAccountKey = 'crossAccount'`
  - `DioFactory.create({required String baseUrl, List<Interceptor> interceptors = const []})`

**Why this task exists.** `DioFactory` as built in Task 1 attaches nothing, so
`expireAt` is carried on the session but never acted on and a `440` is a plain
failure. Employer refreshes on `440` and treats `401` as token-invalid
(`DioHelper.refreshTokenStatus = [440]`, `tokenInvalidStatus = [401]`). Without
this, a session that outlives its token signs the user out instead of renewing
— sign-in itself still works, which is why it is easy to miss until later
screens are in place.

**The sign-in Dio does not get the refresh interceptor.** `AuthManager` builds
its own `Dio` precisely so the active account's headers cannot leak in; adding a
refresh interceptor there would let a failed sign-in retry as whoever is
currently signed in. It gets the logger and retry only.

- [x] **Step 1: Write the failing interceptor test**

Create `test/data/refresh_token_interceptor_test.dart` covering:
- a `440` triggers `refresh()` once and replays the original request with the
  new token
- two concurrent `440`s trigger `refresh()` **once**, not twice, and both
  requests replay
- a failed `refresh()` calls `onRefreshFailed` and surfaces the original error
- a request carrying the `crossAccountKey` extra is passed through untouched
- a `401` does **not** refresh — it calls `onRefreshFailed` directly

Drive it with `DioAdapter` from `package:http_mock_adapter`, or a hand-written
`HttpClientAdapter` fake if you would rather not add the dependency.

- [x] **Step 2: Run it and watch it fail**

Run: `fvm flutter test test/data/refresh_token_interceptor_test.dart`
Expected: FAIL — `RefreshTokenInterceptor` undefined.

- [x] **Step 3: Write `AuthInterceptor`**

It adds `Authorization: Bearer <token>` and `x-workspace-id` when the callbacks
return a value, and leaves the request alone when they return null. Reading
through callbacks rather than holding a repository keeps this usable before
Task 9 exists, and keeps the data layer free of a provider lookup.

- [x] **Step 4: Write `RefreshTokenInterceptor`**

Port the behaviour of
`employer:lib/common/services/refresh_token_interceptor.dart`. The parts that
matter:

- refresh on `440` only; `401` means the token is not renewable
- hold a single in-flight refresh `Future` so concurrent failures share it
- skip any request whose `options.extra[crossAccountKey] == true`
- replay the original request through `dio.fetch` with the new header

- [x] **Step 5: Let `DioFactory` take interceptors**

```dart
static Dio create({
  required String baseUrl,
  List<Interceptor> interceptors = const [],
}) {
  final dio = Dio(BaseOptions(/* unchanged */));
  dio.interceptors.addAll(interceptors);
  return dio;
}
```

Existing callers pass nothing and keep working.

- [x] **Step 6: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

**Left unwired on purpose — and there is a gap behind it.** This task builds and
tests the interceptors; nothing attaches them yet, because there is no
app-scoped `Dio` to attach them to. Today every call goes through
`AuthManager.dio`, which exists to be *unauthenticated* — correct for sign-in,
wrong for `getMyProfile` and `signOut`.

Closing it needs three things, which belong with Task 7's provider work:

1. A `refreshToken` endpoint. Employer sends it on a **bare `Dio` with no
   headers and no interceptors** (`auth_http_service.dart:113-122`), because
   the call must not carry the expired token and must not re-enter the refresh
   interceptor. Body is `{'refreshToken': ...}`.
2. An app-scoped `Dio` built with `AuthInterceptor` + `RefreshTokenInterceptor`,
   reading the token from `SessionRepository.currentSession`.
3. Splitting `AuthRepository`'s calls: `signInRemote` stays on the sign-in Dio,
   `getMyProfileRemote` and `signOutRemote` move to the app Dio.

Until then `expireAt` is still carried but unused, and a `440` still surfaces
as a plain error.

---

### Task 6: AuthRepository and SignInUseCase

**Files:**
- Create: `lib/utils/encrypt_util.dart`
- Modify: `lib/data/repositories/auth/auth_repository.dart`
- Modify: `lib/data/repositories/auth/auth_repository_impl.dart`
- Create: `lib/domain/use_cases/auth/sign_in_use_case.dart`
- Create: `lib/domain/use_cases/auth/sign_in_flow_use_case.dart`
- Modify: `lib/domain/domain.dart`, `lib/utils/utils.dart`
- Create: `test/testing/fakes/fake_auth_api_client.dart`
- Test: `test/utils/encrypt_util_test.dart`, `test/domain/sign_in_use_case_test.dart`

**Interfaces:**
- Consumes: `AuthManager`, `AuthApiClient`, `Session`, `User`, `ApiException`.
- Produces:
  - `String EncryptUtil.generateSha1Password(String input)`, `String EncryptUtil.generateMd5Password(String input)`
  - `abstract class AuthRepository` with `Future<Result<Session>> signInRemote(AuthRequest)`, `Future<Result<User>> getMyProfileRemote()`, `Future<Result<void>> signOutRemote()`
  - `SignInUseCase({required AuthManager authManager, required AuthRepository authRepository})` with `Future<Result<bool>> signIn({required String email, required String password})` — the `bool` is `isTmpToken`
  - `SignInFlowUseCase({required AuthManager authManager})` with `isAddingAccount`, `beginAddAccount()`, `cancel()`, `discardAttempt()`

- [x] **Step 1: Add the crypto dependency**

```bash
fvm flutter pub add crypto
```

- [x] **Step 2: Write the failing hashing test**

Create `test/utils/encrypt_util_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('EncryptUtil', () {
    test('sha1 hashing is deterministic', () {
      expect(
        EncryptUtil.generateSha1Password('password'),
        EncryptUtil.generateSha1Password('password'),
      );
    });

    test('different passwords hash differently', () {
      expect(
        EncryptUtil.generateSha1Password('password'),
        isNot(EncryptUtil.generateSha1Password('password1')),
      );
    });

    test('it never returns the plaintext', () {
      expect(EncryptUtil.generateSha1Password('password'), isNot('password'));
    });

    test('md5 hashing is deterministic', () {
      expect(
        EncryptUtil.generateMd5Password('abc'),
        EncryptUtil.generateMd5Password('abc'),
      );
    });
  });
}
```

- [x] **Step 3: Run it and watch it fail**

Run: `fvm flutter test test/utils/encrypt_util_test.dart`
Expected: FAIL — `Undefined name 'EncryptUtil'`.

- [x] **Step 4: Implement `EncryptUtil`**

Create `lib/utils/encrypt_util.dart`, mirroring
`employer:lib/app/core/utils/encrypt_util.dart`:

```dart
import 'dart:convert';

import 'package:crypto/crypto.dart';

import '../config/build_config.dart';

/// Client-side password hashing.
///
/// The server never sees a plaintext password: sign-in sends a salted SHA1
/// digest. The salts arrive through `--dart-define-from-file`.
abstract final class EncryptUtil {
  static String generateSha1Password(String input) =>
      _sha1(input, salt: BuildConfig().passwordSalt);

  static String generateMd5Password(String input) =>
      _md5(input, salt: BuildConfig().unlockedSalt);

  static String _sha1(String input, {String salt = ''}) =>
      sha1.convert(utf8.encode('$input$salt')).toString();

  static String _md5(String input, {String salt = ''}) =>
      md5.convert(utf8.encode('$input$salt')).toString();
}
```

Add to `lib/utils/utils.dart`:

```dart
export 'encrypt_util.dart';
```

**Salt order is `input + salt`** — verified against
`employer:lib/app/core/utils/encrypt_util.dart:10`, which reads
`sha1.convert(utf8.encode(input + salt.valueOrEmpty))`. Reversing it produces a
correct-looking digest that fails every sign-in against the real API, so do not
"tidy" this line.

- [x] **Step 5: Run the hashing test**

`BuildConfig().passwordSalt` is `late final` and unset in tests, so call
`BuildConfig().setupEnvironment()` in a `setUpAll`. Add to the test file:

```dart
  setUpAll(() => BuildConfig().setupEnvironment());
```

Run: `fvm flutter test test/utils/encrypt_util_test.dart`
Expected: PASS (4 tests).

- [x] **Step 6: Write the fake API client**

Create `test/testing/fakes/fake_auth_api_client.dart`:

```dart
import 'package:sun_shine/core.dart';

class FakeAuthApiClient implements AuthApiClient {
  FakeAuthApiClient({this.signInResult, this.profileResult});

  Result<SessionApiModel>? signInResult;
  Result<UserApiModel>? profileResult;

  AuthRequest? lastRequest;
  int signOutCount = 0;

  @override
  Future<Result<SessionApiModel>> signIn(AuthRequest request) async {
    lastRequest = request;
    return signInResult ??
        const Result.ok(
          SessionApiModel(
            token: 'tok',
            user: UserApiModel(id: 'u1', email: 'khai@sunshine.com'),
          ),
        );
  }

  @override
  Future<Result<UserApiModel>> getMyProfile() async =>
      profileResult ??
      const Result.ok(UserApiModel(id: 'u1', email: 'khai@sunshine.com'));

  @override
  Future<Result<void>> signOut() async {
    signOutCount++;
    return const Result.ok(null);
  }
}
```

- [x] **Step 7: Write the failing use-case test**

Create `test/domain/sign_in_use_case_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_auth_api_client.dart';

void main() {
  group('SignInUseCase', () {
    late FakeAuthApiClient apiClient;
    late AuthManager authManager;
    late SignInUseCase useCase;

    setUpAll(() => BuildConfig().setupEnvironment());

    setUp(() {
      apiClient = FakeAuthApiClient();
      authManager = AuthManager(baseUrl: 'https://example.test/');
      useCase = SignInUseCase(
        authManager: authManager,
        authRepository: AuthRepositoryImpl(apiClient: apiClient),
      );
    });

    test('never sends the plaintext password', () async {
      await useCase.signIn(email: 'khai@sunshine.com', password: 'password');

      expect(apiClient.lastRequest?.sha1Password, isNot('password'));
      expect(apiClient.lastRequest?.email, 'khai@sunshine.com');
    });

    test('derives the md5 unlock material from the salted digest', () async {
      await useCase.signIn(email: 'khai@sunshine.com', password: 'password');

      final pending = authManager.pending;
      expect(pending?.md5Password, isNotNull);
      expect(pending?.md5Password, isNot('password'));
      expect(
        pending?.md5Password,
        EncryptUtil.generateMd5Password(
          EncryptUtil.generateSha1Password('password'),
        ),
      );
    });

    test('stores the session as pending on success', () async {
      final result = await useCase.signIn(
        email: 'khai@sunshine.com',
        password: 'password',
      );

      expect(result, isA<Ok<bool>>());
      expect((result as Ok<bool>).value, isFalse);
      expect(authManager.pending?.token, 'tok');
    });

    test('reports a temporary token so the caller can route to the OTP step',
        () async {
      apiClient.signInResult = const Result.ok(
        SessionApiModel(
          token: 'tmp',
          isTmpToken: true,
          user: UserApiModel(id: 'u1', email: 'khai@sunshine.com'),
        ),
      );

      final result = await useCase.signIn(
        email: 'khai@sunshine.com',
        password: 'password',
      );

      expect((result as Ok<bool>).value, isTrue);
    });

    test('leaves nothing pending on failure', () async {
      apiClient.signInResult = const Result.error(
        ApiException(
          error: ApiErrorEnum.server,
          serverMessage: 'Invalid credentials',
          statusCode: 401,
        ),
      );

      final result = await useCase.signIn(
        email: 'khai@sunshine.com',
        password: 'wrong',
      );

      expect(result, isA<Error<bool>>());
      expect(authManager.pending, isNull);
    });
  });
}
```

- [x] **Step 8: Run it and watch it fail**

Run: `fvm flutter test test/domain/sign_in_use_case_test.dart`
Expected: FAIL — `SignInUseCase` undefined.

- [x] **Step 9: Rewrite the repository**

Replace `lib/data/repositories/auth/auth_repository.dart`:

```dart
import 'package:sun_shine/core.dart';

abstract class AuthRepository {
  Future<Result<Session>> signInRemote(AuthRequest request);

  Future<Result<User>> getMyProfileRemote();

  Future<Result<void>> signOutRemote();
}
```

Replace `lib/data/repositories/auth/auth_repository_impl.dart`:

```dart
import 'package:sun_shine/core.dart';

class AuthRepositoryImpl extends BaseRepo implements AuthRepository {
  AuthRepositoryImpl({required AuthApiClient apiClient})
    : _apiClient = apiClient;

  final AuthApiClient _apiClient;

  @override
  Future<Result<Session>> signInRemote(AuthRequest request) async {
    final result = await _apiClient.signIn(request);
    return switch (result) {
      Ok(:final value) => Result.ok(_toSession(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<User>> getMyProfileRemote() async {
    final result = await _apiClient.getMyProfile();
    return switch (result) {
      Ok(:final value) => Result.ok(_toUser(value)),
      Error(:final error) => Result.error(error),
    };
  }

  @override
  Future<Result<void>> signOutRemote() => _apiClient.signOut();

  Session _toSession(SessionApiModel model) {
    final user = model.user;
    return Session(
      userId: user?.id ?? '',
      token: model.token,
      refreshToken: model.refreshToken,
      expireAt: model.expireAt,
      isTmpToken: model.isTmpToken ?? false,
      user: user == null ? null : _toUser(user),
    );
  }

  User _toUser(UserApiModel model) => User(
    id: model.id,
    email: model.email,
    fullName: model.fullName,
    avatar: model.avatar,
  );
}
```

Note the session-holding responsibility has moved out: `AuthRepository` is now
purely the HTTP facade. `AuthLocalService` and its `session` stream are
replaced by `SessionRepository` in Task 8 — delete
`lib/data/services/local/auth_local_service.dart` and its export once Task 8
lands, not before.

- [x] **Step 10: Write the use cases**

Create `lib/domain/use_cases/auth/sign_in_use_case.dart`:

```dart
import 'package:sun_shine/core.dart';

/// Password sign-in.
///
/// Returns whether the server issued a *temporary* token — true means the user
/// still owes a second factor, so the caller routes to the auth-code or
/// passcode step instead of finalizing.
class SignInUseCase {
  SignInUseCase({
    required AuthManager authManager,
    required AuthRepository authRepository,
  }) : _authManager = authManager,
       _authRepository = authRepository;

  final AuthManager _authManager;
  final AuthRepository _authRepository;

  Future<Result<bool>> signIn({
    required String email,
    required String password,
  }) async {
    final sha1Password = EncryptUtil.generateSha1Password(password);
    final result = await _authRepository.signInRemote(
      AuthRequest(email: email, sha1Password: sha1Password),
    );

    return switch (result) {
      Ok(value: final session) => () {
        // The MD5 of the salted digest is what later unlocks the E2E private
        // key, together with the user's passcode. This is the only moment it
        // can be derived — the password is gone after this method returns.
        _authManager.setPending(
          session.copyWith(
            md5Password: EncryptUtil.generateMd5Password(sha1Password),
          ),
        );
        return Result<bool>.ok(session.isTmpToken);
      }(),
      Error(:final error) => Result<bool>.error(error),
    };
  }
}
```

Create `lib/domain/use_cases/auth/sign_in_flow_use_case.dart`:

```dart
import 'package:sun_shine/core.dart';

/// The sign-in flow's non-HTTP verbs, so ViewModels never reach [AuthManager].
class SignInFlowUseCase {
  SignInFlowUseCase({required AuthManager authManager})
    : _authManager = authManager;

  final AuthManager _authManager;

  bool get isAddingAccount => _authManager.isAddingAccount;

  void beginAddAccount() => _authManager.beginAddAccount();

  /// Back out of the sign-in screen: ends the flow.
  void cancel() => _authManager.reset();

  /// Back out of a step above the sign-in screen (auth code, passcode): drops
  /// the half-signed-in session, but the flow stays open.
  void discardAttempt() => _authManager.clearPending();
}
```

- [x] **Step 11: Export and verify**

Add to `lib/domain/domain.dart`:

```dart
export 'use_cases/auth/sign_in_flow_use_case.dart';
export 'use_cases/auth/sign_in_use_case.dart';
```

```bash
fvm flutter test test/domain/sign_in_use_case_test.dart
fvm flutter analyze
```

---

### Task 7: SignInViewModel and SignInScreen (password path)

**Files:**
- Modify: `lib/ui/auth/view_models/sign_in_viewmodel.dart`
- Modify: `lib/ui/auth/widgets/sign_in_screen.dart`
- Create: `lib/ui/auth/widgets/auth_card.dart`, `lib/ui/auth/widgets/glass_icon.dart`
- Modify: `lib/main.dart`, `test/testing/pump_app.dart`, `lib/ui/auth/auth.dart`
- Test: `test/ui/auth/view_models/sign_in_viewmodel_test.dart`

**Interfaces:**
- Consumes: `SignInUseCase`, `SignInFlowUseCase`, `Command1`, `BaseViewModel`.
- Produces: `SignInViewModel({required SignInUseCase signInUseCase, required SignInFlowUseCase signInFlowUseCase})` exposing `Command1<bool, Credentials> signIn`, `bool get isAddingAccount`, `void cancel()`, and `typedef Credentials = ({String email, String password})`.

The ViewModel holds **no** `TextEditingController` and **no** `FocusNode` — those live in the View's `State`, as they already do in the current `_SignInViewState`. Employer's controller owned them; that is the GetX habit being dropped.

- [x] **Step 1: Write the failing ViewModel test**

Create `test/ui/auth/view_models/sign_in_viewmodel_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../../../testing/fakes/fake_auth_api_client.dart';

void main() {
  group('SignInViewModel', () {
    late FakeAuthApiClient apiClient;
    late AuthManager authManager;
    late SignInViewModel viewModel;

    setUpAll(() => BuildConfig().setupEnvironment());

    setUp(() {
      apiClient = FakeAuthApiClient();
      authManager = AuthManager(baseUrl: 'https://example.test/');
      viewModel = SignInViewModel(
        signInUseCase: SignInUseCase(
          authManager: authManager,
          authRepository: AuthRepositoryImpl(apiClient: apiClient),
        ),
        signInFlowUseCase: SignInFlowUseCase(authManager: authManager),
      );
      addTearDown(viewModel.dispose);
    });

    test('starts idle', () {
      expect(viewModel.signIn.running, isFalse);
      expect(viewModel.signIn.error, isFalse);
      expect(viewModel.isAddingAccount, isFalse);
    });

    test('a successful sign-in completes the command', () async {
      await viewModel.signIn.execute((
        email: 'khai@sunshine.com',
        password: 'password',
      ));

      expect(viewModel.signIn.completed, isTrue);
      expect(viewModel.signIn.running, isFalse);
    });

    test('a failed sign-in surfaces the server message', () async {
      apiClient.signInResult = const Result.error(
        ApiException(
          error: ApiErrorEnum.server,
          serverMessage: 'Invalid credentials',
          statusCode: 401,
        ),
      );

      await viewModel.signIn.execute((
        email: 'khai@sunshine.com',
        password: 'wrong',
      ));

      expect(viewModel.signIn.error, isTrue);
      final result = viewModel.signIn.result! as Error<bool>;
      expect((result.error as ApiException).serverMessage, 'Invalid credentials');
    });

    test('cancel ends the add-account flow', () {
      authManager.beginAddAccount();

      viewModel.cancel();

      expect(authManager.isAddingAccount, isFalse);
    });
  });
}
```

- [x] **Step 2: Run it and watch it fail**

Run: `fvm flutter test test/ui/auth/view_models/sign_in_viewmodel_test.dart`
Expected: FAIL — the constructor does not take these arguments.

- [x] **Step 3: Rewrite the ViewModel**

Replace `lib/ui/auth/view_models/sign_in_viewmodel.dart`:

```dart
import 'package:sun_shine/core.dart';

typedef Credentials = ({String email, String password});

class SignInViewModel extends BaseViewModel {
  SignInViewModel({
    required SignInUseCase signInUseCase,
    required SignInFlowUseCase signInFlowUseCase,
  }) : _signInUseCase = signInUseCase,
       _signInFlowUseCase = signInFlowUseCase {
    signIn = Command1(_signIn);
    _isAddingAccount = _signInFlowUseCase.isAddingAccount;
  }

  final SignInUseCase _signInUseCase;
  final SignInFlowUseCase _signInFlowUseCase;

  /// Completes with `true` when the server issued a temporary token, meaning
  /// the user still owes a second factor.
  late final Command1<bool, Credentials> signIn;

  late final bool _isAddingAccount;

  /// Captured at construction: finalize ends the flow, so the live flag is
  /// already false by the time the view decides how to route.
  bool get isAddingAccount => _isAddingAccount;

  void cancel() => _signInFlowUseCase.cancel();

  Future<Result<bool>> _signIn(Credentials credentials) {
    return _signInUseCase.signIn(
      email: credentials.email.trim(),
      password: credentials.password,
    );
  }
}
```

- [x] **Step 4: Run the ViewModel test**

Run: `fvm flutter test test/ui/auth/view_models/sign_in_viewmodel_test.dart`
Expected: PASS (4 tests).

- [x] **Step 5: Port the two auth-only widgets**

Port `employer:lib/app/modules/auth/sign_in/widgets/auth_card.dart` to
`lib/ui/auth/widgets/auth_card.dart`, and
`employer:lib/app/modules/auth/sign_in/widgets/glass_icon.dart` to
`lib/ui/auth/widgets/glass_icon.dart`. Same conversions as Task 3 Step 3:
`material_ui` import, `Theme.of(context).colorScheme`, plain `SizedBox` for
`Space`.

- [x] **Step 6: Rewrite the screen**

Port the layout from `employer:lib/app/modules/auth/sign_in/views/sign_in_view.dart`
into `lib/ui/auth/widgets/sign_in_screen.dart`, keeping the existing
`SignInScreen` → `MultiProvider(providers: [...])` → `_SignInView`
shape. Required changes from employer's version:

| Employer | Here |
|---|---|
| `GetView<SignInController>` + `controller.x` | `StatefulWidget` + `context.read<SignInViewModel>()` |
| `controller.emailController` | a `TextEditingController` owned by `_SignInViewState`, disposed in `dispose()` |
| `Obx(() => ...)` around the buttons | `ListenableBuilder(listenable: viewModel.signIn, ...)` |
| `_isFormValid` / `_isEmailValid` `RxBool` | local `setState` driven by controller listeners in the `State` |
| `ProcessingDialog.show()` then `.hide()` | `viewModel.signIn.running` inside the `ListenableBuilder` |
| `Get.toNamed(route, arguments: OTPInput(...))` | `context.push(Routes.authCode, extra: ...)` — **left as a TODO until the auth-code screen exists**; for now, on `Ok(false)` do nothing and let Task 10's redirect take over |
| `S.of(context).x` | `AppLocalizations.of(context).x` |
| `context.colorScheme` | `Theme.of(context).colorScheme` |
| `Space.vertical(value: n)` | `SizedBox(height: n)` |

Render the passkey and QR buttons but leave their `onPressed: null` with a
`// TODO(task-12/14)` comment. They are wired in Phase D and E.

Show the error by reading the command's result:

```dart
if (viewModel.signIn.error)
  Text(
    switch (viewModel.signIn.result) {
      Error(error: final ApiException e) =>
        e.localizedMessage(AppLocalizations.of(context)),
      _ => AppLocalizations.of(context).incorrectEmailOrPassword,
    },
    style: TextStyle(color: Theme.of(context).colorScheme.error),
  ),
```

- [x] **Step 7: Update the provider scopes**

Providers are written inline at the `MultiProvider` that mounts them — this
repo has no `<feature>_providers.dart` indirection.

In `lib/ui/auth/widgets/sign_in_screen.dart`, the `SignInScreen` wrapper
becomes:

```dart
class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(
          create: (context) => SignInUseCase(
            authManager: context.read(),
            authRepository: context.read(),
          ),
        ),
        Provider(
          create: (context) => SignInFlowUseCase(authManager: context.read()),
        ),
        ChangeNotifierProvider(
          create: (context) => SignInViewModel(
            signInUseCase: context.read(),
            signInFlowUseCase: context.read(),
          ),
        ),
      ],
      child: const _SignInView(),
    );
  }
}
```

In `lib/main.dart`, replace the auth-scope list that currently registers
`AuthApiClient` / `AuthLocalService` with:

```dart
      providers: [
        Provider(
          create: (context) => AuthManager(baseUrl: BuildConfig().env.baseApiUrl),
        ),
        Provider<AuthRepository>(
          create: (context) => AuthRepositoryImpl(
            apiClient: Di.observed(context.read<AuthManager>().authApiClient),
          ),
        ),
      ],
```

Mirror the same change in `test/testing/pump_app.dart`, which builds the auth
scope by hand so tests boot the real tree.

- [x] **Step 8: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

Expected: **No issues found!**, all tests pass.

**Checkpoint:** the password path now runs end to end against the real API. Verify manually before continuing:

```bash
fvm flutter run --dart-define-from-file=_env/dev.env
```

---

## Phase C — Session and routing

### Task 8: Isar and SessionLocalService — SKIPPED (blocked)

**Isar cannot build on Flutter 3.47.4.** Not a pin that can be loosened:

```
build_runner 2.16         -> analyzer >=13.3.0 <15.0.0
json_serializable 6.14    -> source_gen ^4.1.2
isar_community_generator  -> analyzer >=8.0.0 <11.0.0, source_gen ^2/^3
```

`isar_community_generator` is stranded on an old analyzer and cannot coexist
with the build_runner + freezed + json_serializable + retrofit toolchain this
project already depends on. Downgrading `retrofit_generator` does not help —
`build_runner` alone forces the conflict.

**This reaches past auth.** Employer uses Isar in 20 files (channels, messages,
roles, link previews, blocked users); every one of those modules meets the same
wall later in the migration. Candidates when it is decided:
`flutter_secure_storage` for credentials, `drift` or `sqflite` for the rest.

**Decision: sessions stay in memory for now.** They do not survive a restart,
so the app signs in again each launch. `SessionRepository` already hides this —
swapping the backing store changes nothing above it.

#### Original plan, for whenever persistence is chosen

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/data/services/local/isar_database.dart`
- Create: `lib/data/services/local/model/session_entity.dart`
- Create: `lib/data/services/local/session_local_service.dart`
- Delete: `lib/data/services/local/auth_local_service.dart`
- Modify: `lib/data/data.dart`, `lib/utils/di.dart`
- Test: `test/data/session_local_service_test.dart`

**Interfaces:**
- Produces:
  - `SessionEntity` — Isar `@collection`, fields `Id id`, `@Index() String accountUserId`, `String token`, `String? refreshToken`, `int? expireAt`, `String? workspaceId`, `bool isActive`, `String email`, `String? fullName`, `String? avatar`, `String? md5Password`, `String? encryptedPrivateKey`, `String? localEncryptedPrivateKey`

**`isTmpToken` is deliberately not stored.** `FinalizeSessionUseCase` rejects a
pending session that still carries a temporary token, so nothing half-signed-in
ever reaches Isar. Reading a row back therefore yields `isTmpToken: false`, and
that is the invariant, not an oversight — assert it in the round-trip test.
  - `SessionLocalService` with `Future<void> put(Session)`, `Future<List<Session>> getAll()`, `Future<Session?> getActive()`, `Future<void> setActive(String userId)`, `Future<void> remove(String userId)`, `Stream<List<Session>> watchAll()`, `Stream<Session?> watchActive()`, `void dispose()`

Employer's `SessionRepository extends BaseLocalService<SessionModel>` — it *is* the Isar layer. Here Isar stays in `data/services/local/` and the domain-facing API lives in `data/repositories/` (Task 9).

- [ ] **Step 1: Add Isar**

```bash
fvm flutter pub add isar_community isar_community_flutter_libs path_provider
fvm flutter pub add dev:isar_community_generator
```

Match employer's pinned `3.3.0-dev.3` if resolution complains.

- [ ] **Step 2: Write the failing test**

Create `test/data/session_local_service_test.dart`. Isar needs a real
directory, so open it in a temp dir:

```dart
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';
import 'package:sun_shine/core.dart';

void main() {
  group('SessionLocalService', () {
    late Directory dir;
    late Isar isar;
    late SessionLocalService service;

    const khai = Session(
      userId: 'u1',
      token: 't1',
      user: User(id: 'u1', email: 'khai@sunshine.com'),
    );
    const linh = Session(
      userId: 'u2',
      token: 't2',
      user: User(id: 'u2', email: 'linh@sunshine.com'),
    );

    setUpAll(() => Isar.initializeIsarCore(download: true));

    setUp(() async {
      dir = await Directory.systemTemp.createTemp('sun_shine_test');
      isar = await Isar.open([SessionEntitySchema], directory: dir.path);
      service = SessionLocalService(isar: isar);
    });

    tearDown(() async {
      service.dispose();
      await isar.close(deleteFromDisk: true);
      if (dir.existsSync()) dir.deleteSync(recursive: true);
    });

    test('starts empty', () async {
      expect(await service.getAll(), isEmpty);
      expect(await service.getActive(), isNull);
    });

    test('stores a session and makes it active', () async {
      await service.put(khai);
      await service.setActive('u1');

      expect(await service.getActive(), isNotNull);
      expect((await service.getActive())!.userId, 'u1');
    });

    test('holds several accounts with exactly one active', () async {
      await service.put(khai);
      await service.put(linh);
      await service.setActive('u1');
      await service.setActive('u2');

      final all = await service.getAll();
      expect(all, hasLength(2));
      expect((await service.getActive())!.userId, 'u2');
    });

    test('upserts rather than duplicating the same account', () async {
      await service.put(khai);
      await service.put(khai.copyWith(token: 'refreshed'));

      final all = await service.getAll();
      expect(all, hasLength(1));
      expect(all.single.token, 'refreshed');
    });

    test('remove drops the account', () async {
      await service.put(khai);
      await service.remove('u1');

      expect(await service.getAll(), isEmpty);
    });

    test('watchActive emits on change', () async {
      await service.put(khai);

      expect(
        service.watchActive().map((s) => s?.userId),
        emitsThrough('u1'),
      );

      await service.setActive('u1');
    });
  });
}
```

- [ ] **Step 3: Run it and watch it fail**

Run: `fvm flutter test test/data/session_local_service_test.dart`
Expected: FAIL — `SessionEntity` and `SessionLocalService` undefined.

- [ ] **Step 4: Write the entity**

Create `lib/data/services/local/model/session_entity.dart`:

```dart
import 'package:isar_community/isar.dart';

part 'session_entity.g.dart';

/// The stored shape of a signed-in account.
///
/// Deliberately flat: employer's `SessionModel` carried an `IsarLink<UserModel>`
/// that every read had to `syncDataFromLink()` before use. The auth flow only
/// needs the user's identity, so it is denormalised here.
@collection
class SessionEntity {
  SessionEntity();

  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String accountUserId;

  late String token;
  String? refreshToken;
  int? expireAt;
  String? workspaceId;
  late bool isActive;

  late String email;
  String? fullName;
  String? avatar;

  /// Derived at sign-in; with the passcode it unlocks [encryptedPrivateKey].
  String? md5Password;

  /// The E2E private key as the server holds it.
  String? encryptedPrivateKey;

  /// The same key re-wrapped with this device's key.
  String? localEncryptedPrivateKey;
}
```

- [ ] **Step 5: Write the database opener and the service**

Create `lib/data/services/local/isar_database.dart`:

```dart
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sun_shine/core.dart';

abstract final class IsarDatabase {
  static Future<Isar> open() async {
    final dir = await getApplicationDocumentsDirectory();
    return Isar.open([SessionEntitySchema], directory: dir.path,
        name: BuildConfig().env.dbName);
  }
}
```

Create `lib/data/services/local/session_local_service.dart` implementing the
interface listed above. Map `SessionEntity` ↔ `Session` in private helpers.
`setActive(userId)` runs one write transaction that clears `isActive` on every
row and sets it on the matching one. `watchAll()` / `watchActive()` wrap
`isar.sessionEntitys.where().watch(fireImmediately: true)` and map to domain.
Extend `BaseLocalService` so `Di` observes it, and close any stream
controller in `dispose()`.

- [ ] **Step 6: Generate and verify**

```bash
fvm dart run build_runner build
fvm flutter test test/data/session_local_service_test.dart
```

Expected: PASS (6 tests).

Delete `lib/data/services/local/auth_local_service.dart` and its export from
`lib/data/data.dart`; add the three new exports. Fix the analyzer fallout in
`AuthScope` and `test/data/auth_repository_impl_test.dart`.

```bash
fvm flutter analyze
fvm flutter test
```

---

### Task 9: SessionRepository and FinalizeSessionUseCase

**Files:**
- Create: `lib/data/repositories/auth/session_repository.dart`, `session_repository_impl.dart`
- Create: `lib/domain/use_cases/auth/finalize_session_use_case.dart`
- Modify: `lib/data/data.dart`, `lib/domain/domain.dart`, `lib/main.dart`
- Create: `test/testing/fakes/fake_session_repository.dart`
- Test: `test/data/session_repository_impl_test.dart`, `test/domain/finalize_session_use_case_test.dart`

**Interfaces:**
- Produces:
  - `abstract class SessionRepository` with `Stream<Session?> get activeSession`, `Session? get currentSession`, `Stream<List<Session>> get sessions`, `bool get isSignedIn`, `Future<void> adoptSession(Session)`, `Future<void> assignWorkspace(String workspaceId)`, `Future<void> signOut()`, `Future<void> load()`
  - `SessionRepositoryImpl({required SessionLocalService localService})`
  - `FinalizeSessionUseCase({required AuthManager authManager, required SessionRepository sessionRepository})` with `Future<Result<Session>> execute()`
  - `FakeSessionRepository implements SessionRepository` — backs `activeSession` with a `BehaviorSubject<Session?>.seeded(null)`, has `currentSession` read that subject's value, and adds `void emit(Session? session)` for tests to drive it. Task 10's router test depends on `emit`.

**No navigation in this layer.** Employer's `SessionManager` called
`Get.offAllNamed` at `session_manager.dart:290` and `:371`; that responsibility
moves to the router in Task 10. If you find yourself importing `go_router`
here, stop — it belongs in Task 10.

- [x] **Step 1: Write the failing repository test**

Create `test/data/session_repository_impl_test.dart` covering:
- `isSignedIn` is false before any session is adopted
- `adoptSession` persists and makes it current
- `activeSession` emits the adopted session
- `assignWorkspace` updates `currentSession.workspaceId`
- `signOut` clears the active session and emits null
- adopting a second account leaves both in `sessions` with the newer active

Use a real `SessionLocalService` over a temp-dir Isar, same `setUp`/`tearDown`
as Task 8.

- [x] **Step 2: Run it and watch it fail**

Run: `fvm flutter test test/data/session_repository_impl_test.dart`
Expected: FAIL — `SessionRepository` undefined.

- [x] **Step 3: Implement the repository**

`SessionRepositoryImpl extends BaseRepo implements SessionRepository`. Hold a
`BehaviorSubject<Session?>` seeded from `localService.getActive()` in `load()`,
and mirror `localService.watchActive()` into it. `currentSession` reads the
subject's value so the router's `redirect` can stay synchronous.

- [x] **Step 4: Write the failing use-case test**

Create `test/domain/finalize_session_use_case_test.dart` covering:
- with nothing pending, `execute()` returns `Error`
- with a pending session, it is adopted into `SessionRepository`
- after success, `authManager.pending` is null and `isAddingAccount` is false
- a pending session with `isTmpToken: true` is rejected with `Error`

Use `FakeSessionRepository`.

- [x] **Step 5: Implement `FinalizeSessionUseCase`**

Create `lib/domain/use_cases/auth/finalize_session_use_case.dart`:

```dart
import 'package:sun_shine/core.dart';

/// Hands the pending session over to the session layer.
///
/// Everything before this point ran on the sign-in scoped Dio; after it, the
/// account is live and the router's redirect takes the user onward.
class FinalizeSessionUseCase {
  FinalizeSessionUseCase({
    required AuthManager authManager,
    required SessionRepository sessionRepository,
  }) : _authManager = authManager,
       _sessionRepository = sessionRepository;

  final AuthManager _authManager;
  final SessionRepository _sessionRepository;

  Future<Result<Session>> execute() async {
    final pending = _authManager.pending;
    if (pending == null) {
      return const Result.error(
        ApiException(error: ApiErrorEnum.unknown),
      );
    }
    if (pending.isTmpToken) {
      return const Result.error(
        ApiException(error: ApiErrorEnum.unknown),
      );
    }

    await _sessionRepository.adoptSession(pending);
    _authManager.reset();
    return Result.ok(pending);
  }
}
```

Employer's version also registered FCM and VoIP tokens when adding an account
(`employer:lib/app/modules/auth/use_cases/finalize_session_use_case.dart:47-60`)
and loaded workspaces. Both are out of scope here — workspace selection is its
own screen, and push registration arrives with the notifications module.

- [x] **Step 6: Register and verify**

Add `SessionLocalService`, `SessionRepository`, and `FinalizeSessionUseCase` to
the auth scope in `lib/main.dart`, giving the local service a `dispose:`.

```bash
fvm flutter analyze
fvm flutter test
```

---

### Task 10: Router redirect on the session stream

**Files:**
- Modify: `lib/routing/router.dart`, `lib/routing/routes.dart`, `lib/main.dart`
- Modify: `lib/ui/auth/widgets/auth_scope.dart`
- Create: `lib/routing/go_router_refresh_stream.dart`
- Test: `test/routing/router_test.dart`

**Interfaces:**
- Consumes: `SessionRepository.activeSession`, `SessionRepository.currentSession`.
- Produces: `GoRouterRefreshStream(Stream<dynamic>)` — a `ChangeNotifier` that calls `notifyListeners()` on each event; `createRouter({required SessionRepository sessionRepository, String initialLocation, bool debugLogDiagnostics})`.

**Correction to an earlier claim.** This was written up as a live bug — that a
sign-in would strand the user on the form. It does not: `AuthScope` keys its
subtree on `ValueKey(userId)`, so signing in unmounts and remounts `MainApp`,
whose `initState` builds a *new* router starting at `Routes.home`. Navigation
works today, by full scope teardown.

`refreshListenable` is still worth adding, for two reasons the teardown does
not cover: a change that does **not** alter the user id — assigning a workspace
— currently re-runs no redirect at all; and rebuilding the entire app to move
between two routes is a heavy, implicit mechanism to depend on.

- [x] **Step 1: Write the failing router test**

Create `test/routing/router_test.dart`:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:sun_shine/core.dart';

import '../testing/fakes/fake_session_repository.dart';

void main() {
  group('createRouter redirect', () {
    late FakeSessionRepository sessionRepository;

    setUp(() => sessionRepository = FakeSessionRepository());

    String locationOf(GoRouter router) =>
        router.routerDelegate.currentConfiguration.uri.toString();

    test('a signed-out user lands on sign-in', () async {
      final router = createRouter(
        sessionRepository: sessionRepository,
        initialLocation: Routes.channels,
      );
      addTearDown(router.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(locationOf(router), Routes.signIn);
    });

    test('a signed-in user without a workspace lands on workspace', () async {
      sessionRepository.emit(
        const Session(
          userId: 'u1',
          token: 't',
          user: User(id: 'u1', email: 'khai@sunshine.com'),
        ),
      );
      final router = createRouter(
        sessionRepository: sessionRepository,
        initialLocation: Routes.signIn,
      );
      addTearDown(router.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(locationOf(router), Routes.workspace);
    });

    test('a fully signed-in user lands on home', () async {
      sessionRepository.emit(
        const Session(
          userId: 'u1',
          token: 't',
          workspaceId: 'w1',
          user: User(id: 'u1', email: 'khai@sunshine.com'),
        ),
      );
      final router = createRouter(
        sessionRepository: sessionRepository,
        initialLocation: Routes.signIn,
      );
      addTearDown(router.dispose);
      await Future<void>.delayed(Duration.zero);

      expect(locationOf(router), Routes.home);
    });

    test('signing in redirects away from sign-in without rebuilding the router',
        () async {
      final router = createRouter(
        sessionRepository: sessionRepository,
        initialLocation: Routes.signIn,
      );
      addTearDown(router.dispose);
      await Future<void>.delayed(Duration.zero);
      expect(locationOf(router), Routes.signIn);

      sessionRepository.emit(
        const Session(
          userId: 'u1',
          token: 't',
          workspaceId: 'w1',
          user: User(id: 'u1', email: 'khai@sunshine.com'),
        ),
      );
      await Future<void>.delayed(Duration.zero);

      expect(locationOf(router), Routes.home);
    });
  });
}
```

The last test is the regression guard for the bug — it fails today.

- [x] **Step 2: Run it and watch it fail**

Run: `fvm flutter test test/routing/router_test.dart`
Expected: FAIL — `createRouter` does not accept `sessionRepository`.

- [x] **Step 3: Add the refresh listenable**

Create `lib/routing/go_router_refresh_stream.dart`:

```dart
import 'dart:async';

import 'package:flutter/foundation.dart';

/// Bridges a stream to `GoRouter.refreshListenable`.
///
/// `go_router` re-runs `redirect` whenever this notifies, which is how a sign
/// in or sign out moves the user without anyone calling `context.go`.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
```

- [x] **Step 4: Rewrite the redirect**

Add `static const workspace = '/workspace';` to `lib/routing/routes.dart`.

In `lib/routing/router.dart`, change the signature to take
`required SessionRepository sessionRepository`, and replace the `redirect`:

```dart
    refreshListenable: GoRouterRefreshStream(sessionRepository.activeSession),
    redirect: (context, state) {
      final session = sessionRepository.currentSession;
      final location = state.matchedLocation;

      if (session == null) {
        return location == Routes.signIn ? null : Routes.signIn;
      }
      if (session.needsWorkspace) {
        return location == Routes.workspace ? null : Routes.workspace;
      }
      if (location == Routes.signIn || location == Routes.workspace) {
        return Routes.home;
      }
      return null;
    },
```

Add a placeholder `GoRoute` for `Routes.workspace` rendering
`const PlaceholderTab(title: 'Workspace')` until that screen is ported.

- [x] **Step 5: Update `main.dart` and `AuthScope`**

In `lib/main.dart`, pass `sessionRepository: context.read<SessionRepository>()`.
In `lib/ui/auth/widgets/auth_scope.dart`, switch the `StreamBuilder` from
`authRepository.session` to `sessionRepository.activeSession` and keep the
`ValueKey(userId)` — that is what disposes a signed-out account's scope.

- [x] **Step 6: Verify**

```bash
fvm flutter test test/routing/router_test.dart
fvm flutter analyze
fvm flutter test
```

**Checkpoint:** sign in with a real account and confirm the app navigates to the workspace placeholder on its own.

---

## Phase D — Passkey

### Task 11: Passkey plugin, service, and device key store

**Files:**
- Copy: `plugins/flutter_passkey_service/` from employer
- Modify: `pubspec.yaml`
- Create: `lib/data/services/local/device_key_store.dart`
- Create: `lib/data/services/local/passkey_local_service.dart`
- Create: `lib/data/services/api/passkey_api_client.dart`
- Modify: `lib/data/data.dart`
- Test: `test/data/passkey_local_service_test.dart`

**Interfaces:**
- Produces:
  - `PasskeyService` with `Future<CreatePasskeyResponseData> register({required Map<String, dynamic> optionsJson})`, `Future<GetPasskeyAuthenticationResponseData> authenticate({required Map<String, dynamic> optionsJson})`, `static bool isSilent(PasskeyException)`
  - `PasskeyLocalService` with `Future<bool> hasAnyForUser(String userId)`, `Future<void> markRegistered({required String userId, String? passkeyId, String? deviceName})`
  - `DeviceKeyStore` — `flutter_secure_storage` wrapper
  - `PasskeyApiClient` — `@RestApi(baseUrl: '/user-services/passkeys', callAdapter: ResultCallAdapter)` with `generateAuthenticationOptions`, `authenticate`, `generateRegistrationOptions`, `register`

Endpoints, from `employer:lib/app/constants/app_api.dart`:
`/user-services/passkeys/authentication-options`, `/authenticate`,
`/registration-options`, `/register`.

- [ ] **Step 1: Copy the plugin**

It is a patched local fork — read `PATCH_NOTES.md` before touching it.

```bash
EMP=/Users/sunshine/Documents/Project/employer-mobile
mkdir -p plugins
cp -R "$EMP/plugins/flutter_passkey_service" plugins/
cat plugins/flutter_passkey_service/PATCH_NOTES.md
```

- [ ] **Step 2: Add the dependencies**

In `pubspec.yaml` under `dependencies:`:

```yaml
  flutter_passkey_service:
    path: plugins/flutter_passkey_service
```

```bash
fvm flutter pub add flutter_secure_storage
fvm flutter pub get
```

- [ ] **Step 3: Confirm the plugin builds on this Flutter version**

```bash
fvm flutter analyze
fvm flutter build apk --debug --dart-define-from-file=_env/dev.env
```

Expected: builds. If the plugin fails against Flutter 3.47.4, **stop and report** — the passkey path is gated on it and the remaining tasks are unaffected.

- [ ] **Step 4: Port `PasskeyService`**

Copy `employer:lib/app/modules/auth/services/passkey_service.dart` verbatim to
`lib/data/services/api/passkey_service.dart`. It has no GetX dependency — the
import line is the only change.

- [ ] **Step 5: Write the failing local-service test**

Create `test/data/passkey_local_service_test.dart` covering:
- `hasAnyForUser` is false for an unknown user
- after `markRegistered`, it is true for that user and still false for another
- `markRegistered` twice does not duplicate

Back it with the same temp-dir Isar pattern as Task 8, adding a
`PasskeyEntity` collection (`@Index() String userId`, `String? passkeyId`,
`String? deviceName`).

- [ ] **Step 6: Implement it, generate, run**

```bash
fvm dart run build_runner build
fvm flutter test test/data/passkey_local_service_test.dart
```

- [ ] **Step 7: Write `DeviceKeyStore` and `PasskeyApiClient`**

Port `employer:lib/app/modules/auth/services/device_key_store.dart` — it is a
plain `flutter_secure_storage` wrapper with no GetX.

Write `PasskeyApiClient` as a retrofit client per the interface above.

- [ ] **Step 8: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

---

### Task 12: SignInPasskeyUseCase and the passkey button

**Files:**
- Create: `lib/domain/use_cases/auth/sign_in_passkey_use_case.dart`
- Create: `lib/domain/use_cases/auth/local_private_key_use_case.dart`
- Modify: `lib/ui/auth/view_models/sign_in_viewmodel.dart`
- Modify: `lib/ui/auth/widgets/sign_in_screen.dart`
- Test: `test/domain/sign_in_passkey_use_case_test.dart`, extend `test/ui/auth/view_models/sign_in_viewmodel_test.dart`

**Interfaces:**
- Consumes: `PasskeyService`, `PasskeyApiClient`, `AuthManager`, `AuthRepository`, `DeviceKeyStore`.
- Produces: `SignInPasskeyUseCase` with `Future<Result<Session>> signIn({required String email})`; `SignInViewModel.signInWithPasskey` as `Command1<Session, String>` keyed on email.

Port the flow from
`employer:lib/app/modules/auth/sign_in/use_cases/sign_in_passkey_use_case.dart`:
request authentication options → `PasskeyService.authenticate` → post the
assertion → `authManager.setPending`. A `PasskeyException` whose
`PasskeyService.isSilent` is true (the user cancelled) must resolve as a
**cancellation, not an error** — the screen shows nothing.

- [ ] **Step 1: Write the failing use-case test**

Cover: a successful passkey sign-in sets `authManager.pending`; a cancelled
prompt yields `Error` carrying a distinguishable `PasskeyCancelledException`;
a server rejection yields `Error` with the server message.

Add `class PasskeyCancelledException implements Exception` beside
`ApiException` so the ViewModel can tell the two apart.

- [ ] **Step 2: Run it, watch it fail, implement, re-run**

Run: `fvm flutter test test/domain/sign_in_passkey_use_case_test.dart`

- [ ] **Step 3: Add the command to the ViewModel**

```dart
  late final Command1<Session, String> signInWithPasskey;
```

built in the constructor from a private method that calls
`_signInPasskeyUseCase.signIn(email: email)` and, on success, chains
`_finalizeSessionUseCase.execute()`.

- [ ] **Step 4: Extend the ViewModel test**

Add: the passkey command completes on success; a cancellation leaves
`signInWithPasskey.error` true but carrying `PasskeyCancelledException`.

- [ ] **Step 5: Wire the button**

In `sign_in_screen.dart`, replace the passkey button's `onPressed: null` with a
call guarded on a valid email, and hide the error text when the failure is a
`PasskeyCancelledException`.

- [ ] **Step 6: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

---

## Phase E — QR login

**Blocked on Phase D, contrary to the plan's structure.** QR login is not a
transport problem with a scanner on the front; it is an end-to-end encrypted
key exchange:

1. `PrepareQrLoginUseCase` generates an **X25519 ephemeral key pair**
   (`E2EEncryption.generateEphemeralKeyPair`) and posts the public half.
2. The web client approves and returns the user's E2E private key, encrypted
   to that ephemeral public key.
3. `SignInQRUseCase` decrypts it with the ephemeral private key, fetches the
   profile on a temporary session, then **re-encrypts the private key with the
   device key** via `LocalPrivateKeyUseCase` → `DeviceKeyStore`.

`LocalPrivateKeyUseCase` and `DeviceKeyStore` were filed under Task 11
(passkey), so skipping Phase D removes what Phase E depends on. They do **not**
depend on the patched passkey plugin — `DeviceKeyStore` is a
`flutter_secure_storage` wrapper and `E2EEncryption` needs the `cryptography`
package. The plugin is the risky part; these are not.

`PasskeyLocalService` is separately blocked: it was specified on Isar.


### Task 13: Socket slice and QR share client

**Files:**
- Modify: `pubspec.yaml`
- Create: `lib/data/services/socket/socket_service.dart`
- Create: `lib/data/services/api/qr_share_api_client.dart`
- Create: `lib/data/services/api/model/qr_share_payload.dart`, `qr_share_event.dart`
- Create: `lib/data/repositories/auth/qr_share_repository.dart`, `qr_share_repository_impl.dart`
- Test: `test/data/qr_share_payload_test.dart`

**Interfaces:**
- Produces:
  - `SocketService({required String baseUrl})` with `void connectAnonymously({required void Function() onConnected})`, `Stream<SocketEvent> get events`, `void joinRoom(String roomId)`, `void shutdown()`
  - `QrSharePayload` with `fromJson`/`toJson`, fields `roomId`, `token`
  - `QrShareRepository` with `Future<Result<QrSharePayload>> prepare()`, `Future<Result<Session>> approve(QrSharePayload)`

**Port only the slice the QR flow uses.** Employer's `SocketService` is 383
lines and `lib/app/socket_io/` totals ~2000; the QR controller touches exactly
`connectAnonymously`, `events`, `joinRoom`, `shutdown`
(`employer:lib/app/modules/qr_login/controllers/qr_mobile_login_controller.dart:53-122`).
Port those four and their supporting `SocketEvent` type. It grows when the
channels and DMs modules need the rest.

- [ ] **Step 1: Add the packages**

```bash
fvm flutter pub add socket_io_client mobile_scanner
```

- [ ] **Step 2: Write the failing payload test**

Create `test/data/qr_share_payload_test.dart` covering a round trip through
`fromJson`/`toJson` and rejection of a malformed payload (missing `roomId`).

- [ ] **Step 3: Port the models, socket slice, client, and repository**

From `employer:lib/app/modules/qr_login/`: `models/qr_share_payload.dart`,
`models/qr_share_event.dart`, `services/qr_share_http_service.dart` (rewritten
as a retrofit `QrShareApiClient`), and the socket methods listed above.

- [ ] **Step 4: Verify**

```bash
fvm dart run build_runner build
fvm flutter analyze
fvm flutter test
```

---

### Task 14: QR scanner, waiting dialog, and the QR button

**Files:**
- Create: `lib/domain/use_cases/auth/sign_in_qr_use_case.dart`
- Create: `lib/ui/auth/widgets/qr_scanner_screen.dart`, `qr_waiting_dialog.dart`
- Modify: `lib/routing/routes.dart`, `lib/routing/router.dart`
- Modify: `lib/ui/auth/view_models/sign_in_viewmodel.dart`, `sign_in_screen.dart`
- Modify: `ios/Runner/Info.plist`, `android/app/src/main/AndroidManifest.xml`
- Test: `test/domain/sign_in_qr_use_case_test.dart`

**Interfaces:**
- Consumes: `QrShareRepository`, `SocketService`, `FinalizeSessionUseCase`.
- Produces: `SignInQrUseCase` with `Future<Result<Session>> completeFrom(QrSharePayload)`; `Routes.qrScanner = '/qr-scanner'`; `SignInViewModel.signInWithQr` as `Command1<Session, QrSharePayload>`.

- [ ] **Step 1: Add the camera permission strings**

`ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Scan a QR code to sign in.</string>
```

`android/app/src/main/AndroidManifest.xml`, above `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
```

- [ ] **Step 2: Write the failing use-case test**

Create `test/domain/sign_in_qr_use_case_test.dart` covering: an approved
payload yields a session and sets it pending; a rejected one yields `Error`; a
socket timeout yields `Error`.

- [ ] **Step 3: Run it, watch it fail, implement, re-run**

Port from `employer:lib/app/modules/qr_login/use_cases/sign_in_qr_use_case.dart`.

- [ ] **Step 4: Port the scanner screen and waiting dialog**

From `employer:lib/app/modules/qr_login/views/qr_scanner_view.dart` and
`widgets/qr_waiting_dialog.dart`. Conversions: `GetView` → `StatefulWidget` +
`context.read`, `Get.back(result: x)` → `context.pop(x)`, `Obx` →
`ListenableBuilder`. Register `Routes.qrScanner` with
`parentNavigatorKey: rootNavigatorKey` so it covers the tabs.

- [ ] **Step 5: Wire the button**

Replace the QR button's `onPressed: null` with
`context.push<QrSharePayload>(Routes.qrScanner)`, then show the waiting dialog
and run `signInWithQr` with the scanned payload.

- [ ] **Step 6: Verify**

```bash
fvm flutter analyze
fvm flutter test
```

**Checkpoint:** all three sign-in paths work against the dev API on a real device. Screen 1 is done.

---

## Definition of done

- [ ] `fvm flutter analyze` reports **No issues found!**
- [ ] `fvm flutter test` passes, including the 116 pre-existing tests
- [ ] Password, passkey, and QR sign-in each work against `_env/dev.env` on a device
- [ ] Signing in navigates away from the sign-in screen with no manual `context.go`
- [ ] Signing out returns to it and disposes the account's provider scope
- [ ] No `package:get` import anywhere in `lib/`
- [ ] No `package:flutter/material.dart` import in any widget file

## Next screens

Auth code (OTP) → passcode → workspace selection → passkey registration prompt.
Each follows the same shape and can reuse everything Phase A built.
