import 'package:dio/dio.dart';
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
  bool _isAddingAccount = false;

  Session? get pending => _pending;

  bool get isAddingAccount => _isAddingAccount;

  void setPending(Session session) {
    _pending = session;
    dio.options.headers['Authorization'] = 'Bearer ${session.token}';
  }

  void beginAddAccount() => _isAddingAccount = true;

  void clearPending() {
    _pending = null;
    dio.options.headers.remove('Authorization');
  }

  void reset() {
    clearPending();
    _isAddingAccount = false;
  }
}
