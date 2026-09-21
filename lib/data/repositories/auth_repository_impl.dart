import '../../domain/models/user.dart';
import '../services/api/auth_api_client.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  /// The client arrives through the constructor — never a global, never a
  /// singleton looked up from inside. That is what makes this class testable
  /// with a fake client and nothing else.
  AuthRepositoryImpl({required AuthApiClient apiClient}) : _apiClient = apiClient;

  final AuthApiClient _apiClient;

  User? _currentUser;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isSignedIn => _currentUser != null;

  @override
  Future<void> signIn({required String email, required String password}) async {
    final json = await _apiClient.signIn(email: email, password: password);
    _currentUser = _toUser(json);
    notifyListeners();
  }

  @override
  void signOut() {
    _currentUser = null;
    notifyListeners();
  }

  /// The API -> domain boundary. Nothing above this layer sees the wire format.
  User _toUser(Map<String, Object?> json) => User(
    id: json['id']! as String,
    name: json['full_name']! as String,
    email: json['email']! as String,
  );
}
