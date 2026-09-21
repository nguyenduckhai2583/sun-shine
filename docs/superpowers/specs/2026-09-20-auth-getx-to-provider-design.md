# Auth module: GetX → Provider

Date: 2026-09-20
Status: approved design, not yet implemented

## Goal

Port the auth module of `employer-mobile` (GetX) into `sun-shine` (provider +
MVVM), screen by screen, following the standard Flutter architecture already
established in `docs/architecture.md`. `employer-mobile` stays untouched and
serves as the reference.

Screen 1 is **Sign In**, covering all three entry paths: password, passkey,
and QR.

## Why a port and not an in-place migration

`sun-shine` already carries the target shape: `data/` `domain/` `ui/`,
`Command<T>`, `Di`/`BaseViewModel`, `go_router`, provider scopes, and stub
modules named after employer's (`home`, `channels`, `dms`, `planix`). It is a
rewrite target, and its layers are hollow — scaffolding over fake data.

`employer-mobile` is the opposite: real substance, three GetX-shaped seams.
So the port moves substance into shape. `sun-shine` contributes the skeleton;
`employer-mobile` contributes nearly all the logic.

## What employer already gets right

Its layering is not typical GetX. These carry over essentially unchanged:

- `services/` → `repositories/` → `use_cases/` → presentation is already clean
- `AuthManager` builds a **dedicated `Dio` for the sign-in flow**, never cloned
  from the active account's, so no header can leak in; the pending session is
  handed to the session layer only at finalize. This is the strongest piece of
  design in the module and its shape is preserved exactly.
- `use_cases/` earns its keep: `FinalizeSessionUseCase` spans three
  repositories plus session adoption plus FCM/VoIP registration. Not ViewModel
  work.
- One client (`chat_http_service.dart`) already uses retrofit with a
  `ResultCallAdapter`. That is the newer of employer's two API styles and the
  one adopted here — not the 55 legacy `BaseApiClient` clients.

## The three GetX-shaped seams

### 1. The session layer navigates (the one real inversion)

`session_manager.dart:290` and `:371` call `Get.offAllNamed` from inside the
session layer. Navigation moves out entirely:

```
BEFORE                                 AFTER
SessionManager.instance        →       SessionRepository (abstract)
  static singleton                       + SessionRepositoryImpl
  RxnString _currentUserIdRx   →         Stream<Session?> activeSession
  Rx<WorkspaceState>           →         Stream<WorkspaceState> workspace
  List<SessionState> _sessions →         Stream<List<Session>> sessions
  Get.offAllNamed(...)         →         (removed — router decides)
```

```dart
refreshListenable: GoRouterRefreshStream(sessionRepository.activeSession),
redirect: (context, state) => switch (sessionRepository.currentSession) {
  null                       => Routes.signIn,
  Session(workspaceId: null) => Routes.workspace,
  _                          => Routes.home,
},
```

**Correction.** An earlier draft called this a live bug. It is not:
`AuthScope` keys its subtree on `ValueKey(userId)`, so a sign-in remounts
`MainApp` and its `initState` builds a new router at `Routes.home`. What
`refreshListenable` adds is redirect on changes that keep the same user id —
assigning a workspace — and removes the need to tear down the whole app to
change route.

### 2. `BaseController` hands every controller an ambient global

```dart
abstract class BaseController extends GetxController {
  final session = SessionManager.instance;   // ambient, untestable
```

Replaced by constructor injection. `BaseViewModel` takes nothing; repositories
arrive through the constructor.

### 3. Bindings, Obx, and controller-owned input state

- `bindings/` → `<feature>_providers.dart` returning `List<SingleChildWidget>`
- `GetxController` + `Rx` → `BaseViewModel` + `Command<T>`
- `TextEditingController` / `FocusNode` move out of the controller into the
  View's `State` (sun-shine's `_SignInViewState` already does this correctly)
- `SignInView` calls `ProcessingDialog.show()` and `Get.toNamed` directly from
  `build`; these become `Command.running` and `context.push`

## Decisions

| # | Decision | Rationale |
|---|---|---|
| 1 | Port into `sun-shine`; `employer-mobile` untouched | sun-shine is the rewrite target |
| 2 | Use cases live in `lib/domain/use_cases/auth/` | Type-grouped, matches `domain/models/` and the Flutter guideline; shared use cases get a home |
| 3 | `Result.error(Exception)` with typed `ApiException(message, statusCode)` | Keeps sun-shine's type-safe `Result`; preserves the `statusCode` employer branches on; leaves localization to the view |
| 4 | Split API DTO ↔ domain model only where the UI reads it | `Session`, `User`, `Workspace` split; wire-only payloads (`AuthRequest`, passkey challenges) pass through. Avoids ~30 pointless mapper pairs |
| 5 | retrofit with `callAdapter: ResultCallAdapter` | Employer's newer style; clients return `Result<T>` and never throw |
| 6 | `Di.observed<T>()` helper for API clients | Retrofit generates `implements`, never `extends`, so `BaseApiClient`'s constructor cannot run |
| 7 | `RepositoryImpl`, not `RepositoryRemote` | Applied 2026-09-20; analyze clean, 116 tests pass |
| 8 | Port the shared widgets; gen-l10n from the start | Screen 1 lays the UI foundation every later screen reuses |
| 8b | Ship **English only** | Employer's `intl_vi.arb` holds 124 of 1863 keys and **none** of the auth ones — there is no Vietnamese auth copy to port. `app_vi.arb` is added when translations exist |
| 9 | Keep Isar for session persistence | Multi-account model is built on Isar queries; replacing it is a rewrite, not a port |
| 9b | Split employer's `SessionRepository` into a local service + a repository | Employer's `SessionRepository extends BaseLocalService<SessionModel>` — it *is* the Isar layer. sun-shine's layering keeps Isar in `data/services/local/` and puts the domain-facing API in `data/repositories/`. This is a deliberate re-layering, not a straight port |
| 10 | Copy `flutter_passkey_service` plugin into sun-shine | It is a patched local fork; a cross-repo relative path breaks CI |

## Target layout

```
lib/
├── config/
│   ├── env.dart                      + passwordSalt, unlockedSalt (baseApiUrl exists)
│   └── auth_providers.dart           Dio, AuthApiClient, AuthManager, repos
├── data/
│   ├── services/
│   │   ├── api/
│   │   │   ├── client/
│   │   │   │   ├── dio_factory.dart          Dio + interceptors
│   │   │   │   ├── result_call_adapter.dart  CallAdapter → Result<T>
│   │   │   │   └── api_exception.dart        ApiException.from(Object)
│   │   │   ├── auth_api_client.dart          @RestApi
│   │   │   ├── qr_share_api_client.dart      @RestApi
│   │   │   └── model/                        *ApiModel (freezed + json)
│   │   └── local/
│   │       ├── session_local_service.dart    Isar, multi-account
│   │       ├── passkey_local_service.dart
│   │       └── device_key_store.dart         flutter_secure_storage
│   └── repositories/auth/
│       ├── auth_repository.dart  + auth_repository_impl.dart
│       └── session_repository.dart + session_repository_impl.dart
├── domain/
│   ├── models/         session.dart, user.dart, workspace.dart
│   └── use_cases/auth/ sign_in, sign_in_passkey, sign_in_qr,
│                       sign_in_flow, finalize_session, local_private_key
├── ui/
│   ├── core/ui/        text_field_input, widget_with_label,
│   │                   processing_dialog, grid_tile_background
│   └── auth/
│       ├── auth_providers.dart
│       ├── view_models/ sign_in_viewmodel.dart
│       └── widgets/     sign_in_screen.dart, auth_card.dart,
│                        glass_icon.dart, qr_waiting_dialog.dart
├── l10n/               app_en.arb  (~32 auth keys; see note)
└── utils/di.dart       + Di.observed<T>()
assets/svg/             ic_app_icon.svg, img_app_text_logo.svg
plugins/flutter_passkey_service/   copied from employer-mobile
```

## API layer

Wire contract, verified against employer's `BaseApiClient.request()`:

- **success** returns the payload at the top level — no envelope, so no
  unwrapping interceptor is needed
- **error** returns `{"error": "..."}`
- `440` → refresh token, `401` → token invalid

```dart
@RestApi(baseUrl: '/user-services/auth', callAdapter: ResultCallAdapter)
abstract class AuthApiClient {
  factory AuthApiClient(Dio dio, {String? baseUrl}) = _AuthApiClient;

  @POST('/sign-in')
  Future<Result<SessionApiModel>> signIn(@Body() AuthRequest request);

  @DELETE('/sign-out')
  Future<Result<void>> signOut(@Header('Authorization') String? authorization);
}
```

`@RestApi(baseUrl:)` carries only the **path prefix**; the host comes from
`Dio.options.baseUrl` at runtime via the existing `Env.baseApiUrl`, preserving the
`--dart-define-from-file` setup.

Resolved versions on Flutter 3.47.4 / Dart 3.13.3 (verified by dry run):
`retrofit 4.10.0`, `retrofit_generator 10.2.11`, `dio 5.11.1`.

**Cross-account calls need care.** `signOut({String? token})` today uses
`tokenOptions(token)`, which sets an `Authorization` override *and* a
`crossAccountKey` extra that stops the refresh interceptor retrying as the
wrong account. In retrofit this splits into `@Header` + `@Extra`, and `@Extra`
requires a const map.

## Environment

Base URLs come from employer:

- dev — `https://employer-api.dev.hodfords.uk/`
- prod — `https://api.hplix.com/`

Sign-in hashes the password client-side (`EncryptUtil.generateSha1Password`),
so `_env/*.env` must also carry `PASSWORD_SALT` and `UNLOCKED_SALT`, read
through `BuildConfig`. Values are copied from employer's `_env/` and are not
reproduced here.

## Screen 1 — Sign In

| Slice | Pulls in |
|---|---|
| foundation | retrofit + Dio stack, `ApiException`, `Di.observed`, Isar, gen-l10n (~32 EN keys), 6 shared widgets, 2 SVGs |
| password | `SignInUseCase`, `AuthRepository`, `AuthApiClient`, `AuthManager` |
| passkey | `PasskeyService`, `LocalPrivateKeyUseCase`, `DeviceKeyStore`, copied plugin |
| QR | `QrShareRepository`, trimmed `SocketService`, scanner view, waiting dialog |
| session | `SessionRepository`, router redirect, `FinalizeSessionUseCase` |

New packages: `dio` `retrofit` `isar_community` `flutter_svg`
`phosphor_flutter` `socket_io_client` `mobile_scanner`
`flutter_secure_storage` `crypto` `intl` `flutter_localizations`
(dev: `retrofit_generator` `isar_community_generator`).

`SocketService` is ported as a **trimmed slice** — `connectAnonymously`,
`joinRoom`, `events`, `shutdown` — which is all the QR flow touches. It grows
when channels and DMs need the rest.

## Testing

Mirrors the existing suite under `test/`:

- ViewModel tests with faked repositories (`test/testing/fakes/`)
- Repository tests with faked API clients, asserting DTO → domain mapping
- `ResultCallAdapter` unit tests: success, `DioException`, `SocketException`,
  timeout → 408
- Router redirect tests via `createRouter(initialLocation: ...)` covering
  signed-out, signed-in-no-workspace, signed-in-with-workspace

**No widget tests.** Coverage stops at the ViewModel: a `Command`'s `running`,
`error`, and `result` are asserted directly, and the screens are verified by
running the app.

## Out of scope

Later screens, in order: auth code (OTP) → passcode → workspace selection →
passkey registration prompt. Then the remaining modules.

## Follow-ups

- **Session tokens are stored in Isar unencrypted.** Carried over from
  employer unchanged rather than altered mid-port. Worth its own ticket.
- Employer pins `retrofit '>=4.9.0 <4.9.2'`, suggesting a past breakage;
  sun-shine starts on 4.10.0 and should watch for the same issue.

## Risks

| Risk | Mitigation |
|---|---|
| Screen 1 is a large vertical slice (all three paths) | Build in the order password → session/routing → passkey → QR, each independently verifiable |
| Isar + retrofit + freezed all generate code | Get `build_runner` green on a single model before porting in bulk |
| The patched passkey plugin may not build on the newer Flutter | Copy and build it first; it gates the passkey path only |
| `@Extra` const-map constraint on cross-account calls | Prototype `signOut` early; fall back to a hand-written client for that one call if needed |
