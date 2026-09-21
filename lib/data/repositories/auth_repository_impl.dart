import '../../domain/models/user.dart';
import '../services/api/auth_api_client.dart';
import '../services/local/auth_local_service.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  /// Two dependencies, both injected: the network, and the source of truth.
  AuthRepositoryImpl({
    required AuthApiClient apiClient,
    required AuthLocalService localService,
  }) : _apiClient = apiClient,
       _localService = localService;

  final AuthApiClient _apiClient;
  final AuthLocalService _localService;

  @override
  Stream<User?> get user => _localService.user;

  @override
  User? get currentUser => _localService.value;

  @override
  bool get isSignedIn => _localService.value != null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    final json = await _apiClient.signIn(email: email, password: password);
    _localService.set(_toUser(json));
  }

  @override
  void signOut() => _localService.set(null);

  /// The API -> domain boundary.
  User _toUser(Map<String, Object?> json) => User(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
  );
}
