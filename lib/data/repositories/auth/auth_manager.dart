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
    authApiClient = Di.observed(AuthApiClient(dio));
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
