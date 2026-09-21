import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sun_shine/core.dart';

class AuthManager {
  AuthManager({required String baseUrl, AuthApiClient? apiClient})
    : dio = DioFactory.create(baseUrl: baseUrl) {
    authApiClient = apiClient ?? AuthApiClient(dio);
    authRepository = AuthRepositoryImpl(client: authApiClient);
  }

  final Dio dio;

  late final AuthApiClient authApiClient;
  late final AuthRepository authRepository;

  Session? _pending;
  final _isAddingAccount = BehaviorSubject<bool>.seeded(false);

  Session? get pending => _pending;

  bool get isAddingAccount => _isAddingAccount.value;

  /// Routing listens to this so the sign-in screen can open while another
  /// account is still signed in.
  Stream<bool> get addingAccount => _isAddingAccount.stream.distinct();

  void setPending(Session session) {
    _pending = session;
    dio.options.headers['Authorization'] = 'Bearer ${session.token}';
  }

  void beginAddAccount() => _isAddingAccount.add(true);

  void clearPending() {
    _pending = null;
    dio.options.headers.remove('Authorization');
  }

  void reset() {
    clearPending();
    _isAddingAccount.add(false);
  }

  bool get isDisposed => _isAddingAccount.isClosed;

  void dispose() {
    _isAddingAccount.close();
  }
}
